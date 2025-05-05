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

  Future<Either<Failure, SetLanguage?>> getLanguage() {
    return handleRepositoryCall(
      onRemote: () async {
        return Right(await LocaleDatasource().getLanguage());
      },
    );
  }

  Future<Either<Failure, void>> setLanguage(int? id) {
    return handleRepositoryCall(
      onRemote: () async {
        await LocaleDatasource().setLanguage(id);
        return const Right(null);
      },
    );
  }

  Future<Either<Failure, List<Language>>> getLanguages() {
    return handleRepositoryCall(
      onRemote: () async {
        return Right(await LocaleDatasource().getLanguages());
      },
    );
  }
}
