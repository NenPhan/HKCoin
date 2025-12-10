import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hkcoin/core/request_handler.dart';
import 'package:hkcoin/core/presentation/storage.dart';
import 'package:hkcoin/data.models/language.dart';
import 'package:hkcoin/data.repositories/locale_repository.dart';

class LocaleController extends GetxController {
  File? translationFile;

  /// Danh sách ngôn ngữ từ API
  List<Language> listLanguage = [];

  /// Locale hiện tại của app
  Locale locale = const Locale("en", "US");

  /// ISO dạng chuẩn — ví dụ: en-US
  String get localeIsoCode =>
      normalizeIso("${locale.languageCode}-${locale.countryCode}");

  /// Danh sách Locale convert
  List<Locale> get listLocal =>
      listLanguage.map((e) => normalizeIso(e.isoCode!).toLocaleFromIsoCode()).toList();

  /// Ngôn ngữ đang được dùng (object từ API)
  Language get currentLanguage {
    final iso = localeIsoCode;

    return listLanguage.firstWhere(
      (e) => normalizeIso(e.isoCode!) == iso,
      orElse: () => listLanguage.isNotEmpty
          ? listLanguage.first
          : Language(id: 0, name: "Unknown", isoCode: "en-US"),
    );
  }

  /// =============================================================
  ///  Chuẩn hóa ISO (xử lý mọi kiểu: vi, vi-vn, vi_VN → vi-VN)
  /// =============================================================
  String normalizeIso(String iso) {
    final parts = iso.split(RegExp(r"[-_]"));

    final lang = parts.first.toLowerCase();
    final country = (parts.length > 1 && parts.last.isNotEmpty)
        ? parts.last.toUpperCase()
        : lang.toUpperCase();

    return "$lang-$country";
  }

  /// =============================================================
  ///  INIT LOCALE — gọi khi APP START hoặc LOGIN xong
  /// =============================================================
  Future<void> initLocale() async {
    // 1️⃣ Luôn load danh sách ngôn ngữ trước
    await getLanguages();

    // 2️⃣ Nếu user đã login → ưu tiên ngôn ngữ backend
    if (Storage().getToken != null) {
      final SetLanguage? userLang = await getLanguage();

      if (userLang != null && userLang.languageCulture != null) {
        final iso = normalizeIso(userLang.languageCulture!);
        locale = iso.toLocaleFromIsoCode();
        return;
      }
    }

    // 3️⃣ Nếu user chưa login → lấy ngôn ngữ đã lưu local
    final savedIso = Storage().getLocalLanguage;
    if (savedIso != null) {
      locale = normalizeIso(savedIso).toLocaleFromIsoCode();
      return;
    }

    // 4️⃣ Fallback → lấy ngôn ngữ mặc định từ API
    if (listLanguage.isNotEmpty) {
      Language defaultLang = listLanguage.firstWhere(
        (e) => e.isDefault == true,
        orElse: () => listLanguage.first,
      );

      final iso = normalizeIso(defaultLang.isoCode!);
      locale = iso.toLocaleFromIsoCode();
    }
  }

  /// =============================================================
  ///  API: lấy ngôn ngữ user đang dùng (backend)
  /// =============================================================
  Future<SetLanguage?> getLanguage() async {
    if (Storage().getToken == null) return null;

    return await handleEitherReturn(
      await LocaleRepository().getLanguage(),
      (r) async => r,
    );
  }

  /// =============================================================
  ///  Đổi ngôn ngữ — tùy theo trạng thái login
  /// =============================================================
  Future<void> setLanguage(int? id, Locale newLocale) async {
    locale = newLocale;

    final iso = normalizeIso("${newLocale.languageCode}-${newLocale.countryCode}");

    if (Storage().getToken != null) {
      /// User login → thay đổi ngôn ngữ server
      await handleEitherReturn(
        await LocaleRepository().setLanguage(id),
        (r) async {},
      );
    } else {
      /// User chưa login → lưu local để dùng cho lần sau
      await Storage().saveLocalLanguage(iso);
    }
  }

  /// =============================================================
  ///  API: lấy danh sách tất cả ngôn ngữ
  /// =============================================================
  Future<void> getLanguages() async {
    await handleEitherReturn(
      await LocaleRepository().getLanguages(),
      (r) async {
        listLanguage = r;
      },
    );
  }
}

////////////////////////////////////////////////////////////////////
/// EXTENSION CHUẨN ISO → LOCALE
////////////////////////////////////////////////////////////////////
extension LocaleExt on String {
  Locale toLocaleFromIsoCode() {
    final parts = split("-");
    final lang = parts.first;
    final country = (parts.length > 1 ? parts.last : lang.toUpperCase());
    return Locale(lang, country);
  }
}
