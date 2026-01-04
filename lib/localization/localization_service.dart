import 'dart:developer';

import 'package:flutter/material.dart';
import 'app_localizations.dart';
typedef LocaleChangeCallback = Future<void> Function(Locale locale);
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
class LocalizationService {
  LocalizationService._();
  static final LocalizationService instance = LocalizationService._();

  AppLocalizations? _loc;
  Locale? currentLocale;

  Locale? _pendingLocale;
  LocaleChangeCallback? _onLocaleChanged;

  // Gọi từ LocalizationScope
  void update(AppLocalizations loc, Locale locale) {
    _loc = loc;
    currentLocale = locale;
  }

  /// Đăng ký callback 1 LẦN DUY NHẤT
  void registerCallback(LocaleChangeCallback callback) {
    _onLocaleChanged = callback;

    // 🔁 Replay locale nếu có request trước đó
    if (_pendingLocale != null) {
      final locale = _pendingLocale!;
      _pendingLocale = null;

      log("🔁 Replay pending locale: $locale");
      Future.microtask(() => changeLocale(locale));
    }
  }

  /// API đổi locale – gọi ở bất kỳ đâu (Splash OK)
  Future<void> changeLocale(Locale locale) async {
    currentLocale = locale;

    if (_onLocaleChanged == null) {
      log("⏳ Scope not ready, cache locale: $locale");
      _pendingLocale = locale;
      return;
    }

    log("🌐 Apply locale: $locale");
    await _onLocaleChanged!(locale);
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

    if (value == key) {
      log(
        "⚠️ Missing translation [$key] "
        "in locale [${currentLocale?.languageCode}-${currentLocale?.countryCode}]",
      );
    }

    return value;
  }  
  
}


// import 'dart:developer';

// import 'package:flutter/material.dart';
// import 'app_localizations.dart';

// String tr(
//   String key, {
//   List<dynamic>? args,
//   Map<String, dynamic>? namedArgs,
//   String? fallback,
// }) {
//   return LocalizationService.instance.tr(
//     key,
//     args: args,
//     namedArgs: namedArgs,
//     fallback: fallback,
//   );
// }

// typedef LocaleChangeCallback = Future<void> Function(Locale locale);

// class LocalizationService {
//   LocalizationService._();
//   static final LocalizationService instance = LocalizationService._();

//   AppLocalizations? _loc;
//   Locale? currentLocale;

//   /// Callback do LocalizationScope đăng ký
//   LocaleChangeCallback? _onLocaleChanged;

//   /// Gọi từ LocalizationScope
//   void update(AppLocalizations loc, Locale locale) {
//     _loc = loc;
//     currentLocale = locale;
//   }

//   /// ⭐ ĐĂNG KÝ callback từ LocalizationScope
//   void registerCallback(LocaleChangeCallback callback) {
//     _onLocaleChanged = callback;
//   }

//   /// ⭐ HÀM ĐỔI NGÔN NGỮ — Dùng được ở tất cả controllers/services
//   Future<void> changeLocale(Locale locale) async {
//     if (_onLocaleChanged != null) {
//       await _onLocaleChanged!(locale);
//     }
//   }

//   String tr(
//     String key, {
//     List<dynamic>? args,
//     Map<String, dynamic>? namedArgs,
//     String? fallback,
//   }) {
//     if (_loc == null) {
//       log("❗ Localization not initialized. Missing key: $key");
//       return fallback ?? key;
//     }
//     final value = _loc!.tr(
//       key,
//       args: args,
//       namedArgs: namedArgs,
//       fallback: fallback,
//     );
//     // Nếu key không tồn tại → value == key
//     if (value == key) {
//       log("⚠️ Missing translation for [$key] in locale [${currentLocale?.languageCode}-${currentLocale?.countryCode}].");
//     }

//     return value;
//   }
//   Future<void> waitUntilReady({int timeoutMs = 500}) async {
//     final sw = Stopwatch()..start();
//     while (_onLocaleChanged == null) {
//       if (sw.elapsedMilliseconds > timeoutMs) {
//         log("❌ LocalizationScope not ready after $timeoutMs ms");
//         break;
//       }
//       await Future.delayed(const Duration(milliseconds: 10));
//     }
//   }

// }
