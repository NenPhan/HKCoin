import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'localization_scope.dart';
import 'app_localizations.dart';

extension LocalizationX on BuildContext {
  LocalizationInheritedWidget? get _inherited =>
      dependOnInheritedWidgetOfExactType<LocalizationInheritedWidget>();

  AppLocalizations? get loc => _inherited?.loc;

  Locale? get locale => _inherited?.locale;

  /// TR() — dịch với key
  String tr(
    String key, {
    List<dynamic>? args,
    Map<String, dynamic>? namedArgs,
    String? fallback,
  }) {
    return loc?.tr(
          key,
          args: args,
          namedArgs: namedArgs,
          fallback: fallback,
        ) ??
        fallback ??
        key;
  }

  /// ⭐ NEW: context.setLocale(Locale)
  Future<void> setLocale(Locale locale) async {
    final state = LocalizationScope.of(this);

    // Đổi ngôn ngữ ở scope
    await state.setLocale(locale);

    // Đồng bộ với UI của GetX
    await Get.updateLocale(locale);
  }
}
