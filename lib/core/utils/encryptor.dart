import 'dart:convert';
import 'dart:typed_data';
import 'package:encrypt/encrypt.dart';

String encryptText(String plainText, [String? encryptionKey]) {
  if (plainText.isEmpty) return plainText;
    encryptionKey = (encryptionKey == null || encryptionKey.isEmpty)
      ? "7588648618713039"
      : encryptionKey;
  // Key: 16 ký tự đầu tiên
  final keyStr = encryptionKey.substring(0, 16);
  final key = Key.fromUtf8(keyStr); // AES key 128-bit

  // IV: từ vị trí 8 đến 15 (8 ký tự)
  final ivStr = encryptionKey.substring(8, 16);
  final ivBytes = utf8.encode(ivStr);
  final iv = IV(Uint8List.fromList([...ivBytes, ...List.filled(8, 0)]));

  // Plain text được mã hóa theo UTF-16LE (giống Encoding.Unicode trong C#)
  final plainData = utf16le.encode(plainText);

  final encrypter = Encrypter(AES(key, mode: AESMode.cbc, padding: 'PKCS7'));
  final encrypted = encrypter.encryptBytes(plainData, iv: iv);

  return base64.encode(encrypted.bytes);
}
String decryptText(String cipherBase64, String? encryptionKey) {
  if (cipherBase64.isEmpty) return cipherBase64;
  if(encryptionKey!.isEmpty) {
    encryptionKey ="7588648618713039";
  }
  // Key: 16 ký tự đầu tiên
  final keyStr = encryptionKey.substring(0, 16);
  final key = Key.fromUtf8(keyStr); // 16 bytes = AES-128

  // IV: từ ký tự 8 đến 15 → 8 bytes
  final ivStr = encryptionKey.substring(8, 16);
  final ivBytes = utf8.encode(ivStr);
  final iv = IV(Uint8List.fromList([...ivBytes, ...List.filled(8, 0)]));

  // Giải mã base64
  final encryptedBytes = base64.decode(cipherBase64);

  final encrypter = Encrypter(AES(key, mode: AESMode.cbc, padding: 'PKCS7'));
  final decrypted = encrypter.decryptBytes(Encrypted(encryptedBytes), iv: iv);

  // Giải mã theo UTF-16LE
  return utf16le.decode(decrypted);
}
class utf16le {
  static Uint8List encode(String input) {
    final codeUnits = input.codeUnits; // List<int> - UTF-16 code units
    final bytes = <int>[];

    for (var unit in codeUnits) {
      bytes.add(unit & 0xFF);      // low byte
      bytes.add((unit >> 8) & 0xFF); // high byte
    }

    return Uint8List.fromList(bytes);
  }
  static String decode(List<int> bytes) {
    if (bytes.length % 2 != 0) {
      throw ArgumentError('Byte array must have an even length for UTF-16LE decoding.');
    }

    final codeUnits = <int>[];
    for (int i = 0; i < bytes.length; i += 2) {
      final unit = bytes[i] | (bytes[i + 1] << 8); // little-endian: low byte + high byte
      codeUnits.add(unit);
    }

    return String.fromCharCodes(codeUnits).trim();
  }
}
