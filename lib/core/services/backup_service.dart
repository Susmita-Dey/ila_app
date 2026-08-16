import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart' as enc;
import 'package:pointycastle/export.dart' as pc;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../database/app_database.dart';

class BackupService {
  static Future<void> exportEncryptedBackup(AppDatabase db, String passphrase) async {
    // 1. Query all tables (Runs asynchronously via Drift)
    final cycleEvents = await db.select(db.cycleEvents).get();
    final routines = await db.select(db.routines).get();
    final routineLogs = await db.select(db.routineLogs).get();
    final interventions = await db.select(db.treatmentInterventions).get();

    // Map to simple primitive Maps on the main thread (very fast)
    final dataMaps = {
      'cycleEvents': cycleEvents.map((e) => e.toJson()).toList(),
      'routines': routines.map((e) => e.toJson()).toList(),
      'routineLogs': routineLogs.map((e) => e.toJson()).toList(),
      'interventions': interventions.map((e) => e.toJson()).toList(),
    };

    // 2. Offload heavy serialization and encryption to a background Isolate
    final finalPayload = await compute(_performHeavyEncryption, {
      'data': dataMaps,
      'passphrase': passphrase,
    });

    // 3. Write to temporary file
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/ila_data.ila_backup');
    await file.writeAsString(finalPayload);

    // 4. Native Share
    // ignore: deprecated_member_use
    await Share.shareXFiles([XFile(file.path)], subject: 'Ila Encrypted Backup');
  }
}

/// Runs in a background Isolate to prevent UI freezing
String _performHeavyEncryption(Map<String, dynamic> args) {
  final dataMaps = args['data'] as Map<String, dynamic>;
  final passphrase = args['passphrase'] as String;

  final payload = {
    'version': 1,
    'timestamp': DateTime.now().toIso8601String(),
    'data': dataMaps,
  };

  // Heavy operation 1: JSON Encoding
  final jsonString = jsonEncode(payload);

  // Heavy operation 2: Cryptographic Key Derivation (PBKDF2)
  // Generates a mathematically secure 32-byte key from the passphrase
  // using 100,000 iterations of SHA-256 to prevent brute-force attacks
  final salt = enc.IV.fromSecureRandom(16);
  
  final derivator = pc.KeyDerivator('SHA-256/HMAC/PBKDF2')
    ..init(pc.Pbkdf2Parameters(salt.bytes, 100000, 32));
    
  final derivedKeyBytes = derivator.process(Uint8List.fromList(utf8.encode(passphrase)));
  final key = enc.Key(derivedKeyBytes);
  final iv = enc.IV.fromSecureRandom(16);

  // Heavy operation 3: AES-256 Encryption
  final encrypter = enc.Encrypter(enc.AES(key));
  final encrypted = encrypter.encrypt(jsonString, iv: iv);

  // Prepend salt and IV so we can decrypt later
  return '${salt.base64}:${iv.base64}:${encrypted.base64}';
}
