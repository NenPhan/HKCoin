import 'package:flutter/material.dart';

class DateMaskController {
  TextEditingController? _controller;
  bool _isFormatting = false;

  void attach(TextEditingController controller) {
    _controller = controller;
    controller.addListener(_onTextChanged);
  }

  void detach() {
    _controller?.removeListener(_onTextChanged);
  }

  void _onTextChanged() {
    if (_isFormatting) return;
    final controller = _controller;
    if (controller == null) return;

    _isFormatting = true;

    final raw = controller.text.replaceAll(RegExp(r'[^0-9]'), '');

    String day = '';
    String month = '';
    String year = '';

    if (raw.length >= 2) {
      day = raw.substring(0, 2);
      if (int.tryParse(day)! > 31) {
        day = '31';
      }
    } else {
      day = raw;
    }

    if (raw.length >= 4) {
      month = raw.substring(2, 4);
      final m = int.tryParse(month) ?? 0;
      if (m > 12) {
        month = '12';
      } else if (m == 0 && raw.length >= 4) {
        month = '01';
      }
    } else if (raw.length > 2) {
      month = raw.substring(2);
    }

    if (raw.length > 4) {
      year = raw.substring(4, raw.length.clamp(4, 8));
    }

    final buffer = StringBuffer();
    buffer.write(day);
    if (month.isNotEmpty) {
      buffer.write('/');
      buffer.write(month);
    }
    if (year.isNotEmpty) {
      buffer.write('/');
      buffer.write(year);
    }

    final formatted = buffer.toString();

    controller.value = TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );

    _isFormatting = false;
  }
}
