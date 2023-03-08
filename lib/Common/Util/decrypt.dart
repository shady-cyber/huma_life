import 'dart:convert';
import 'package:encrypt/encrypt.dart' as enc;
import 'package:huma_life/Common/Util/appConstatns.dart';
import 'package:crypto/crypto.dart';

class decrypt {
  decrypt() {}
  Future<String> decryptInfo(String data) async {
    var encodedKey = AppConstants.APP_SECRET_KRY;
    var decoded = base64.decode(data);
    var payload = json.decode(String.fromCharCodes(decoded));
    String encodedIv = payload["iv"] ?? "";
    String value = payload["value"] ?? "";
    print(decoded);
    print(payload);
    print(encodedIv);
    final key1 = enc.Key.fromBase64(encodedKey);
    final iv = enc.IV.fromBase64(encodedIv);
    final encrypter = enc.Encrypter(enc.AES(key1, mode: enc.AESMode.cbc));
    final decrypted =
        encrypter.decrypt(enc.Encrypted.fromBase64(value), iv: iv);
    return decrypted;
  }

  static String EncryptSHAQr(String data){
    var data1 = data + "Rrkn7hUrbQGJZNOq";
    var bytes1 = utf8.encode(data1); // data being hashed
    var digest1 = sha256.convert(bytes1);
    String result = digest1.toString();
    result.toUpperCase();
    return result;
  }
}
