import 'dart:convert';
import 'package:encrypt/encrypt.dart' as enc;

class EncryptionService {
  // Must match the key on the Python backend
  static final _key = enc.Key.fromUtf8('1234567890123456'); 
  
  static String encryptData(String plainText) {
    final iv = enc.IV.fromLength(16); // Generate random IV
    final encrypter = enc.Encrypter(enc.AES(_key, mode: enc.AESMode.cbc));
    final encrypted = encrypter.encrypt(plainText, iv: iv);
    
    // Combine IV and Ciphertext so backend can decrypt
    return base64.encode(iv.bytes + encrypted.bytes); 
  }
}