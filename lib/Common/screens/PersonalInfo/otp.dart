import 'package:otp/otp.dart';

class Otp {
  String getCode() {
    var otpStream = OTP.generateTOTPCodeString(
        "PEC6PJQY7P3TT7OFAH5ICUAS6UKQ2AUTX524PFA6SWRFGJ6RNL725YOXGN4NGUSGUE3O75JZ65NCYJEAO3XMNDHFOW7ZNSX2U4DRELY", DateTime.now().millisecondsSinceEpoch,
        interval: 60, algorithm: Algorithm.SHA1,isGoogle: true);
    return otpStream.toString();
  }
}