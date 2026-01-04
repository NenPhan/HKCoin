import 'dart:developer';
import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;
  final Map<String, dynamic> _map;

  /// Để tránh log spam, mỗi key missing chỉ ghi log một lần
  static final Set<String> _loggedMissingKeys = {};

  AppLocalizations(this.locale, this._map);

  String tr(
    String key, {
    List<dynamic>? args,
    Map<String, dynamic>? namedArgs,
    String? fallback,
  }) {
    final raw = _map[key];

    // ❌ Không có key hoặc không phải string → log missing + trả về fallback/key
    if (raw == null || raw is! String) {
      if (!_loggedMissingKeys.contains(key)) {
        log("⚠ Missing translation: $key");
        _loggedMissingKeys.add(key);
      }
      return fallback ?? key;
    }

    String value = raw;

    // Handle positional args: {0}, {1}, ...
    if (args != null) {
      for (int i = 0; i < args.length; i++) {
        value = value.replaceAll('{$i}', args[i].toString());
      }
    }

    // Handle named args: {name}
    if (namedArgs != null) {
      namedArgs.forEach((name, val) {
        value = value.replaceAll('{$name}', val.toString());
      });
    }

    return value;
  }
}
