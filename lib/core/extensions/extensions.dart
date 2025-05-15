import 'package:flutter/material.dart';

extension StringExtensions on String {
  double toDouble({double defaultValue = 0.0}) {
    return double.tryParse(this) ?? defaultValue;
  }

  double stringToDouble({double defaultValue = 0.0}) {
    return double.tryParse(trim()) ?? defaultValue; // Áp dụng trim()
  }
}
extension TextEditingControllerExtensions on TextEditingController {
  void selectAll() {
    if (text.isNotEmpty) {
      selection = TextSelection(baseOffset: 0, extentOffset: text.length);
    }
  }
}