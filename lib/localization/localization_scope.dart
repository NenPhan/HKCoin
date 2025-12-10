// lib/localization/localization_scope.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_localizations.dart';
import 'http_translation_loader.dart';
import 'localization_service.dart';

class LocalizationScope extends StatefulWidget {
  const LocalizationScope({
    super.key,
    required this.child,
    required this.supportedLocales,
    required this.fallbackLocale,
    required this.remotePath,
  });

  final Widget child;
  final List<Locale> supportedLocales;
  final Locale fallbackLocale;
  final String remotePath;

  static _LocalizationScopeState of(BuildContext context) {
    final state = context.findAncestorStateOfType<_LocalizationScopeState>();
    if (state == null) {
      throw FlutterError(
        "LocalizationScope.of() called before the widget is available.\n"
        "Ensure your widget tree includes LocalizationScope at the root.",
      );
    }
    return state;
  }

  @override
  State<LocalizationScope> createState() => _LocalizationScopeState();
}

class _LocalizationScopeState extends State<LocalizationScope> {
  static const _kLocaleKey = "app_locale";
  static const _kCachePrefix = "translations_";

  Locale? _currentLocale;
  Map<String, dynamic> _jsonData = {};
  late HttpTranslationLoader _loader;
  SharedPreferences? _prefs;

  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _loader = HttpTranslationLoader(widget.remotePath);
    _init();
  }

  Future<void> _init() async {
    _prefs = await SharedPreferences.getInstance();

    final saved = _prefs!.getString(_kLocaleKey);
    _currentLocale =
        saved != null ? _parseLocale(saved) : widget.fallbackLocale;
    //await _prefs!.remove("translations_${_localeKey(_currentLocale!)}");
    await _loadLocale(_currentLocale!, isInitial: true);
  }

  Locale _parseLocale(String code) {
    final p = code.split("-");
    return Locale(p[0], p.length > 1 ? p[1] : "");
  }

  /// ⭐ API CHUẨN — Controllers sẽ gọi hàm này
  Future<void> setLocale(Locale locale) async {
    if (!widget.supportedLocales.contains(locale)) return;

    _currentLocale = locale; // cập nhật sync ngay để UI nhận locale mới
    setState(() {});

    await _loadLocale(locale);
  }

  String _localeKey(Locale locale) =>
      locale.countryCode?.isNotEmpty ?? false
          ? "${locale.languageCode}-${locale.countryCode}"
          : locale.languageCode;

  Future<void> _loadLocale(
    Locale locale, {
    bool isInitial = false,
  }) async {
    final key = _localeKey(locale);

    // 1️⃣ Load cache (Load UI VERY FAST)
    final cached = _prefs!.getString("$_kCachePrefix$key");
    if (cached != null) {
      try {
        _jsonData = jsonDecode(cached);
        _initialized = true;
        if (mounted) setState(() {});
      } catch (_) {}
    }

    if (!_initialized) {
      _jsonData = {};
      _initialized = true;
      if (mounted) setState(() {});
    }

    // 2️⃣ Background load
    try {
      final fresh = await _loader.load(key, forceRefresh: true);

      _currentLocale = locale;
      _jsonData = Map<String, dynamic>.from(fresh);

      await _prefs!.setString("$_kCachePrefix$key", jsonEncode(fresh));
      await _prefs!.setString(_kLocaleKey, key);

      if (mounted) setState(() {});
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) {
      return const MaterialApp(
        home: Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    final loc = AppLocalizations(_currentLocale!, _jsonData);

    // Update global service
    LocalizationService.instance.update(loc, _currentLocale!);

    // Cho phép service yêu cầu đổi locale
    LocalizationService.instance.registerCallback((Locale newLocale) async {
      await setLocale(newLocale);
    });

    return LocalizationInheritedWidget(
      loc: loc,
      locale: _currentLocale!,
      child: widget.child,
    );
  }
}

/// ---------------------------------------------------------------------------
/// INHERITED WIDGET (chuẩn)
/// ---------------------------------------------------------------------------
class LocalizationInheritedWidget extends InheritedWidget {
  final AppLocalizations loc;
  final Locale locale;

  const LocalizationInheritedWidget({
    super.key,
    required super.child,
    required this.loc,
    required this.locale,
  });

  @override
  bool updateShouldNotify(covariant LocalizationInheritedWidget oldWidget) {
    return locale != oldWidget.locale || loc != oldWidget.loc;
  }
}
