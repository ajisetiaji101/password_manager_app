import 'dart:convert';
import 'dart:typed_data';
import 'package:crypto/crypto.dart'; // Import crypto untuk hashing
import 'package:encrypt/encrypt.dart' as encrypt;

class EncryptionHelper {

  static encrypt.Key _generateKeyFromUsername(String username) {
    final keyBytes = utf8.encode(username);
    final sha256Hash = sha256.convert(keyBytes);
    final key = sha256Hash.bytes.sublist(0, 16);
    return encrypt.Key(Uint8List.fromList(key));
  }

  // Inisialisasi AES cipher
  static encrypt.IV iv = encrypt.IV.fromLength(16); // Inisialisasi dengan IV kosong

  // AES dengan kunci dari username
  static String encryptPassword(String password, String username) {
    final key = _generateKeyFromUsername(username);
    final encrypter = encrypt.Encrypter(encrypt.AES(key));

    // password dan mengembalikannya dalam format base64
    final encrypted = encrypter.encrypt(password, iv: iv);
    return encrypted.base64;
  }

  static String decryptPassword(String encryptedPassword, String username) {
    final key = _generateKeyFromUsername(username);
    final encrypter = encrypt.Encrypter(encrypt.AES(key));

    final decrypted = encrypter.decrypt64(encryptedPassword, iv: iv);
    return decrypted;
  }
}
