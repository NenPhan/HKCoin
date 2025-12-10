import 'dart:developer';

import 'package:flutter/material.dart';
import 'app_localizations.dart';

String tr(
  String key, {
  List<dynamic>? args,
  Map<String, dynamic>? namedArgs,
  String? fallback,
}) {
  return LocalizationService.instance.tr(
    key,
    args: args,
    namedArgs: namedArgs,
    fallback: fallback,
  );
}

typedef LocaleChangeCallback = Future<void> Function(Locale locale);

class LocalizationService {
  LocalizationService._();
  static final LocalizationService instance = LocalizationService._();

  AppLocalizations? _loc;
  Locale? currentLocale;

  /// Callback do LocalizationScope đăng ký
  LocaleChangeCallback? _onLocaleChanged;

  /// Gọi từ LocalizationScope
  void update(AppLocalizations loc, Locale locale) {
    _loc = loc;
    currentLocale = locale;
  }

  /// ⭐ ĐĂNG KÝ callback từ LocalizationScope
  void registerCallback(LocaleChangeCallback callback) {
    _onLocaleChanged = callback;
  }

  /// ⭐ HÀM ĐỔI NGÔN NGỮ — Dùng được ở tất cả controllers/services
  Future<void> changeLocale(Locale locale) async {
    if (_onLocaleChanged != null) {
      await _onLocaleChanged!(locale);
    }
  }

  String tr(
    String key, {
    List<dynamic>? args,
    Map<String, dynamic>? namedArgs,
    String? fallback,
  }) {
    if (_loc == null) {
      log("❗ Localization not initialized. Missing key: $key");
      return fallback ?? key;
    }
    final value = _loc!.tr(
      key,
      args: args,
      namedArgs: namedArgs,
      fallback: fallback,
    );
    // Nếu key không tồn tại → value == key
    if (value == key) {
      log("⚠️ Missing translation for [$key] in locale [${currentLocale?.languageCode}-${currentLocale?.countryCode}].");
    }

    return value;
  }
}
