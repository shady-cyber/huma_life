import 'package:flutter/services.dart';
// import 'package:local_auth/local_auth.dart';
/* for biometric face recognition */

class AuthService {
/*  static Future<bool> authenticateUser() async {
    final LocalAuthentication localAuthentication = LocalAuthentication();
    bool isAuthenticated = false;
    bool isBiometricSupported = await localAuthentication.isDeviceSupported();
    bool canCheckBiometrics = await localAuthentication.canCheckBiometrics;
    if (isBiometricSupported && canCheckBiometrics) {
      try {
        isAuthenticated = await localAuthentication.authenticate(
            localizedReason: 'Scan your fingerprint to authenticate',
            biometricOnly: true,
            useErrorDialogs: true,
            stickyAuth: true);
      } on PlatformException catch (e) {
        e.message;
      }
    }
    return isAuthenticated;
  }*/
}
