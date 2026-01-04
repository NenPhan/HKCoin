import 'dart:convert';
import 'dart:developer';

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

  // ignore: library_private_types_in_public_api
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
  late final HttpTranslationLoader _loader;
  late final SharedPreferences _prefs;

  bool _initialized = false;

  // ---------------------------------------------------------------------------
  // INIT
  // ---------------------------------------------------------------------------
  @override
  void initState() {
    super.initState();

    _loader = HttpTranslationLoader(widget.remotePath);

    // ⭐ Register callback 1 LẦN DUY NHẤT
    LocalizationService.instance.registerCallback(setLocale);

    _init();
  }

  Future<void> _init() async {
    _prefs = await SharedPreferences.getInstance();

    final saved = _prefs.getString(_kLocaleKey);
    _currentLocale =
        saved != null ? _parseLocale(saved) : widget.fallbackLocale;

    log("🌐 Initial locale: $_currentLocale");

    await _loadLocale(_currentLocale!, isInitial: true);
  }

  // ---------------------------------------------------------------------------
  // LOCALE HELPERS
  // ---------------------------------------------------------------------------
  Locale _parseLocale(String code) {
    final p = code.split("-");
    return Locale(p[0], p.length > 1 ? p[1] : null);
  }

  String _localeKey(Locale locale) =>
      locale.countryCode?.isNotEmpty == true
          ? "${locale.languageCode}-${locale.countryCode}"
          : locale.languageCode;

  // ---------------------------------------------------------------------------
  // PUBLIC API – ĐƯỢC GỌI TỪ LocalizationService
  // ---------------------------------------------------------------------------
  Future<void> setLocale(Locale locale) async {
    if (!widget.supportedLocales.contains(locale)) {
      log("⚠️ Unsupported locale: $locale");
      return;
    }

    if (_currentLocale == locale) return;

    log("🌐 setLocale: $locale");

    _currentLocale = locale;
    if (mounted) setState(() {});

    await _loadLocale(locale);
  }

  // ---------------------------------------------------------------------------
  // LOAD TRANSLATIONS
  // ---------------------------------------------------------------------------
  Future<void> _loadLocale(
    Locale locale, {
    bool isInitial = false,
  }) async {
    final key = _localeKey(locale);

    // 1️⃣ LOAD CACHE (FAST)
    final cached = _prefs.getString("$_kCachePrefix$key");
    if (cached != null) {
      try {
        _jsonData = jsonDecode(cached);
        _initialized = true;
        if (mounted) setState(() {});
      } catch (e) {
        log("❌ Cache parse error: $e");
      }
    }

    if (!_initialized) {
      _jsonData = {};
      _initialized = true;
      if (mounted) setState(() {});
    }

    // 2️⃣ LOAD REMOTE (BACKGROUND)
    try {
      final fresh = await _loader.load(key, forceRefresh: true);

      _jsonData = Map<String, dynamic>.from(fresh);
      _currentLocale = locale;

      await _prefs.setString("$_kCachePrefix$key", jsonEncode(fresh));
      await _prefs.setString(_kLocaleKey, key);

      if (mounted) setState(() {});
    } catch (e) {
      log("❌ Load locale [$key] failed: $e");
    }
  }

  // ---------------------------------------------------------------------------
  // BUILD
  // ---------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    if (!_initialized || _currentLocale == null) {
      return const MaterialApp(
        home: Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    final loc = AppLocalizations(_currentLocale!, _jsonData);

    // ⭐ Update global localization service
    LocalizationService.instance.update(loc, _currentLocale!);

    return LocalizationInheritedWidget(
      loc: loc,
      locale: _currentLocale!,
      child: widget.child,
    );
  }
}

/// ---------------------------------------------------------------------------
/// INHERITED WIDGET
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
