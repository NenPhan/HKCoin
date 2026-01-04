import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hkcoin/localization/localization_scope.dart';
import 'package:hkcoin/presentation.controllers/locale_controller.dart';

/// Cầu nối giữa LocaleController và LocalizationScope
class LocalizationBridge {
  LocalizationBridge._();

  static final instance = LocalizationBridge._();

  /// Update toàn bộ hệ thống:
  /// - đổi locale
  /// - reload translations
  /// - update UI realtime
  Future<void> changeLocale(BuildContext context, Locale newLocale) async {
    final localeController = Get.find<LocaleController>();

    // 1. cập nhật vào controller (backend or storage)
    await localeController.setLanguage(
      localeController.currentLanguage.id,
      newLocale,
    );

    // 2. cập nhật UI bằng LocalizationScope
    // ignore: use_build_context_synchronously
    await LocalizationScope.of(context).setLocale(newLocale);

    // 3. cập nhật GetX UI
    await Get.updateLocale(newLocale);
  }
}
