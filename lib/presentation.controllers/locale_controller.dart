import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hkcoin/core/request_handler.dart';
import 'package:hkcoin/data.models/language.dart';
import 'package:hkcoin/data.repositories/locale_repository.dart';

class LocaleController extends GetxController {
  File? translationFile;
  late Locale locale;
  String get localeString =>
      "${locale.languageCode}-${locale.countryCode ?? ""}";

  Future initLocale() async {
    Language language = await getLanguage();
    final String? languageCode = language.languageCulture?.split("-").first;
    final String? countryCode = language.languageCulture?.split("-").last;
    if (languageCode != null && countryCode != null) {
      locale = Locale(languageCode, countryCode);
      // await setAppLanguage(newLocale: locale);
    } else {
      locale = const Locale("en", "US");
      // await setAppLanguage(newLocale: locale);
    }
  }

  Future<Language> getLanguage() async {
    return await handleEitherReturn(await LocaleRepository().getLanguage(), (
      r,
    ) {
      return r;
    });
  }

  Future setAppLanguage({Locale? newLocale}) async {
    final String defaultLocale = Platform.localeName;
    final String languageCode = defaultLocale.split("_").first;
    final String countryCode = defaultLocale.split("_").last;
    locale = newLocale ?? Locale(languageCode, countryCode);

    await handleEither(
      await LocaleRepository().getTranslationFile(newLocale ?? locale),
      (r) {
        translationFile = r;
        update(["app"]);
      },
    );
  }
}
