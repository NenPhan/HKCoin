// lib/core/extensions/base64_extension.dart
import 'dart:convert';
import 'dart:typed_data';

extension Base64ImageX on String {
  Uint8List toImageBytes() {
    final cleaned =
        contains(',')
            ? split(',')
                .last // bỏ data:image/png;base64,
            : this;
    return base64Decode(cleaned);
  }
}
