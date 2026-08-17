import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';

class AuthService {
  static final LocalAuthentication _auth = LocalAuthentication();

  static Future<bool> authenticate() async {
    try {
      final bool canAuthenticateWithBiometrics = await _auth.canCheckBiometrics;
      final bool canAuthenticate = canAuthenticateWithBiometrics || await _auth.isDeviceSupported();

      if (!canAuthenticate) return true; // Fail open if device doesn't support biometrics

      final success = await _auth.authenticate(
        localizedReason: 'Unlock Imyra Health to view your private data',
        persistAcrossBackgrounding: true,
        biometricOnly: false,
      );
      debugPrint('[AUTH] Authentication result: $success');
      return success;
    } on PlatformException catch (e) {
      debugPrint('[AUTH] PlatformException: ${e.code} - ${e.message}');
      if (e.code == 'NotEnrolled' || e.code == 'NotAvailable' || e.code == 'PasscodeNotSet') {
        return true; // Fail open if device cannot authenticate securely
      }
      return false; // Fail secure on unexpected errors
    } catch (e) {
      debugPrint('[AUTH] Exception: $e');
      return false; // Fail secure on exception
    }
  }
}
