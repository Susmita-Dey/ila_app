import 'dart:convert';
import 'dart:io';
import 'package:encrypt/encrypt.dart' as enc;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../database/app_database.dart';

class BackupService {
  final AppDatabase db;

  BackupService(this.db);

  Future<void> exportEncryptedBackup(String passphrase) async {
    // 1. Fetch all data
    final cycleEvents = await db.select(db.cycleEvents).get();
    final routines = await db.select(db.routines).get();
    final routineLogs = await db.select(db.routineLogs).get();
    final interventions = await db.select(db.treatmentInterventions).get();

    // 2. Serialize to JSON map
    final data = {
      'cycleEvents': cycleEvents.map((e) => e.toJson()).toList(),
      'routines': routines.map((e) => e.toJson()).toList(),
      'routineLogs': routineLogs.map((e) => e.toJson()).toList(),
      'treatmentInterventions': interventions.map((e) => e.toJson()).toList(),
    };

    final jsonStr = jsonEncode(data);

    // 3. Encrypt AES-256
    // Pad or truncate passphrase to 32 chars for AES-256 key
    final keyStr = passphrase.padRight(32, '0').substring(0, 32);
    final key = enc.Key.fromUtf8(keyStr);
    final iv = enc.IV.fromLength(16);
    
    final encrypter = enc.Encrypter(enc.AES(key));
    final encrypted = encrypter.encrypt(jsonStr, iv: iv);

    // Combine IV and Ciphertext
    final payload = '${iv.base64}:${encrypted.base64}';

    // 4. Save to temp file and share
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/ila_data.ila_backup');
    await file.writeAsString(payload);

    // ignore: deprecated_member_use
    await Share.shareXFiles([XFile(file.path)], text: 'My Ila Health Backup');
  }
}
