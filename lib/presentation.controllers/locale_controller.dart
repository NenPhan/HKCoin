import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hkcoin/core/presentation/storage.dart';
import 'package:hkcoin/core/request_handler.dart';
import 'package:hkcoin/data.models/language.dart';
import 'package:hkcoin/data.repositories/locale_repository.dart';

class LocaleController extends GetxController {
  File? translationFile;
  List<Language> listLanguage = [];
  List<Locale> get listLocal =>
      listLanguage.map((e) => e.isoCode!.toLocaleFromIsoCode()).toList();
  Locale locale = const Locale("en", "US");
  String get localeIsoCode =>
      "${locale.languageCode}-${locale.countryCode ?? ""}";

  Future initLocale() async {
    await getLanguages();
    SetLanguage? language = await getLanguage();
    if (language != null && language.languageCulture != null) {
      locale = language.languageCulture!.toLocaleFromIsoCode();
    } else {
      if (listLanguage.isNotEmpty) {
        locale =
            listLanguage
                .where((e) => e.isDefault ?? false)
                .first
                .isoCode!
                .toLocaleFromIsoCode();
      }
    }
  }

  Future<SetLanguage?> getLanguage() async {
    if (Storage().getToken != null) {
      return await handleEitherReturn(await LocaleRepository().getLanguage(), (
        r,
      ) async {
        return r;
      });
    } else {
      return null;
    }
  }

  Future setLanguage(int? id, Locale nLocale) async {
    locale = nLocale;
    await handleEitherReturn(
      await LocaleRepository().setLanguage(id),
      (r) async {},
    );
  }

  Future getLanguages() async {
    await handleEitherReturn(await LocaleRepository().getLanguages(), (
      r,
    ) async {
      listLanguage = r;
    });
  }
}

extension LocaleExt on String {
  Locale toLocaleFromString() {
    final String languageCode = split("_").first;
    final String countryCode = split("_").last;
    return Locale(languageCode, countryCode);
  }

  Locale toLocaleFromIsoCode() {
    final String languageCode = split("-").first;
    final String countryCode = split("-").last;
    return Locale(languageCode, countryCode);
  }
}
