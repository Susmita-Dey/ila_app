import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class AuthService {
  static final LocalAuthentication _auth = LocalAuthentication();

  static Future<bool> authenticate() async {
    try {
      final bool canAuthenticateWithBiometrics = await _auth.canCheckBiometrics;
      final bool canAuthenticate = canAuthenticateWithBiometrics || await _auth.isDeviceSupported();

      if (!canAuthenticate) return true; // Fail open if device doesn't support biometrics

      return await _auth.authenticate(
        localizedReason: 'Unlock Ila Health to view your private data',
        persistAcrossBackgrounding: true,
        biometricOnly: false,
      );
    } catch (_) {
      return false; // Fail secure on exception
    }
  }
}
