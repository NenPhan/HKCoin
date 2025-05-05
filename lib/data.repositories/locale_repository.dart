import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter/widgets.dart';
import 'package:hkcoin/core/err/failures.dart';
import 'package:hkcoin/core/request_handler.dart';
import 'package:hkcoin/data.datasources/locale_datasource.dart';
import 'package:hkcoin/data.models/language.dart';

class LocaleRepository {
  Future<Either<Failure, File>> getTranslationFile(Locale locale) {
    return handleRepositoryCall(
      onRemote: () async {
        return Right(await LocaleDatasource().getTranslationFile(locale));
      },
    );
  }

  Future<Either<Failure, Language>> getLanguage() {
    return handleRepositoryCall(
      onRemote: () async {
        return Right(await LocaleDatasource().getLanguage());
      },
    );
  }
}
