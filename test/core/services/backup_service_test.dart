import 'package:flutter_test/flutter_test.dart';
import 'package:imyra_app/core/services/backup_service.dart';

void main() {
  group('BackupService Cryptography Tests', () {
    const testPassphrase = 'my_super_secret_password_123!';
    final Map<String, dynamic> dummyData = {
      'LabResults': [
        {'id': 1, 'testName': 'HbA1c', 'value': 5.4}
      ],
      'ClinicalProfile': [
        {'id': 1, 'phenotype': 'PCOS_A', 'isDiagnosed': true}
      ]
    };

    test('Encryption and Decryption are lossless', () {
      // 1. Encrypt the data
      final encryptionArgs = {
        'data': dummyData,
        'passphrase': testPassphrase,
      };
      
      final encryptedString = performHeavyEncryption(encryptionArgs);
      
      // Ensure the string is formatted as salt:iv:encrypted
      final parts = encryptedString.split(':');
      expect(parts.length, 3);
      expect(parts[0].isNotEmpty, true); // salt
      expect(parts[1].isNotEmpty, true); // iv
      expect(parts[2].isNotEmpty, true); // payload

      // 2. Decrypt the data
      final decryptionArgs = {
        'content': encryptedString,
        'passphrase': testPassphrase,
      };

      final decryptedData = performHeavyDecryption(decryptionArgs);

      // 3. Verify Lossless Nature
      expect(decryptedData['LabResults'], isNotEmpty);
      expect(decryptedData['LabResults'][0]['testName'], 'HbA1c');
      expect(decryptedData['ClinicalProfile'][0]['phenotype'], 'PCOS_A');
    });

    test('Decryption fails with incorrect passphrase', () {
      // 1. Encrypt the data with correct passphrase
      final encryptionArgs = {
        'data': dummyData,
        'passphrase': testPassphrase,
      };
      
      final encryptedString = performHeavyEncryption(encryptionArgs);

      // 2. Attempt Decryption with wrong passphrase
      final badDecryptionArgs = {
        'content': encryptedString,
        'passphrase': 'wrong_password',
      };

      expect(
        () => performHeavyDecryption(badDecryptionArgs),
        throwsA(isA<Exception>().having((e) => e.toString(), 'message', contains('Incorrect passphrase'))),
      );
    });

    test('Decryption fails with corrupted payload', () {
      final corruptedString = 'badsalt:badiv:badpayload==';
      
      final badDecryptionArgs = {
        'content': corruptedString,
        'passphrase': testPassphrase,
      };

      expect(
        () => performHeavyDecryption(badDecryptionArgs),
        throwsA(isA<Exception>()),
      );
    });
  });
}
