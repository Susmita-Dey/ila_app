import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';

class AuthService {
  static final LocalAuthentication _auth = LocalAuthentication();

  static Future<bool> authenticate() async {
    try {
      final bool canAuthenticateWithBiometrics = await _auth.canCheckBiometrics;
      final bool canAuthenticate = canAuthenticateWithBiometrics || await _auth.isDeviceSupported();

      if (!canAuthenticate) return true; // Fail open if device doesn't support biometrics

      return await _auth.authenticate(
        localizedReason: 'Unlock Imyra Health to view your private data',
        persistAcrossBackgrounding: true,
        biometricOnly: false,
      );
    } on PlatformException catch (e) {
      if (e.code == 'NotEnrolled' || e.code == 'NotAvailable' || e.code == 'PasscodeNotSet') {
        return true; // Fail open if device cannot authenticate securely
      }
      return false; // Fail secure on unexpected errors
    } catch (_) {
      return false; // Fail secure on exception
    }
  }
}
