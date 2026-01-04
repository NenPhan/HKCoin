import 'dart:convert';
import 'dart:typed_data';

class Base64ImageCache {
  static final Map<String, Uint8List> _cache = {};

  static Uint8List? decode(String? base64) {
    if (base64 == null || base64.trim().isEmpty) return null;

    return _cache.putIfAbsent(base64, () {
      try {
        final cleaned = base64.contains(',') ? base64.split(',').last : base64;
        return base64Decode(cleaned);
      } catch (_) {
        return Uint8List(0);
      }
    });
  }

  static void clear() => _cache.clear();
}
