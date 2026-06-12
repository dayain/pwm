import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart' as enc;

class CryptoUtil {
  static const String _prodKeyAlphabet = "2346789BCDFGHJKMPQRTVWXY";

  static String fastHash(String value) {
    final bytes = utf8.encode(value.trim());
    return sha256.convert(bytes).toString();
  }

  static String generateMasterKey() {
    final rand = Random.secure();
    final buffer = StringBuffer();

    for (int i = 0; i < 25; i++) {
      buffer.write(_prodKeyAlphabet[rand.nextInt(_prodKeyAlphabet.length)]);
      if ((i + 1) % 5 == 0 && i < 24) {
        buffer.write('-');
      }
    }
    return buffer.toString();
  }

  static String encrypt(String plainText) {
    final key = enc.Key.fromSecureRandom(32);
    final iv = enc.IV.fromSecureRandom(16);

    final encrypter = enc.Encrypter(enc.AES(key, mode: enc.AESMode.cbc));
    final encrypted = encrypter.encrypt(plainText, iv: iv);

    final keyBase64 = key.base64;
    final ivBase64 = iv.base64;
    final cypherBase64 = encrypted.base64;

    final keyLengthHex = keyBase64.length.toRadixString(16).padLeft(2, '0');
    final ivLengthHex = ivBase64.length.toRadixString(16).padLeft(2, '0');
    return '$keyLengthHex$ivLengthHex$keyBase64$ivBase64$cypherBase64';
  }

  static String decrypt(String cipherText) {
    try {
      final keyLength = int.parse(cipherText.substring(0, 2), radix: 16);
      final ivLength = int.parse(cipherText.substring(2, 4), radix: 16);

      // calculate prcise slice indexes
      final keyStartIndex = 4;
      final ivStartIndex = keyStartIndex + keyLength;
      final cipherStartIndex = ivStartIndex + ivLength;

      // extract hidden components
      final keyBase64 = cipherText.substring(keyStartIndex, ivStartIndex);
      final ivBase64 = cipherText.substring(ivStartIndex, cipherStartIndex);
      final cipherBase64 = cipherText.substring(cipherStartIndex);

      // reinitialize crypto parameters using the embedded keys
      final key = enc.Key.fromBase64(keyBase64);
      final iv = enc.IV.fromBase64(ivBase64);
      final encrypter = enc.Encrypter(enc.AES(key, mode: enc.AESMode.cbc));

      // decrypt and retun the original string
      return encrypter.decrypt(enc.Encrypted.fromBase64(cipherBase64), iv: iv);
    } catch (e) {
      throw FormatException('failed to decode encrypted data');
    }
  }
}
