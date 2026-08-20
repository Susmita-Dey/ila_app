import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';

enum AuthResult { success, failed, missingSecurity }

class AuthService {
  static final LocalAuthentication _auth = LocalAuthentication();

  static Future<AuthResult> authenticate() async {
    try {
      final bool canAuthenticateWithBiometrics = await _auth.canCheckBiometrics;
      final bool canAuthenticate = canAuthenticateWithBiometrics || await _auth.isDeviceSupported();

      if (!canAuthenticate) return AuthResult.missingSecurity;

      final success = await _auth.authenticate(
        localizedReason: 'Unlock Imyra Health to view your private data',
        persistAcrossBackgrounding: true,
        biometricOnly: false,
      );
      debugPrint('[AUTH] Authentication result: $success');
      return success ? AuthResult.success : AuthResult.failed;
    } on PlatformException catch (e) {
      debugPrint('[AUTH] PlatformException: ${e.code} - ${e.message}');
      if (e.code == 'NotEnrolled' || e.code == 'NotAvailable' || e.code == 'PasscodeNotSet') {
        return AuthResult.missingSecurity;
      }
      return AuthResult.failed;
    } catch (e) {
      debugPrint('[AUTH] Exception: $e');
      return AuthResult.failed;
    }
  }
}
