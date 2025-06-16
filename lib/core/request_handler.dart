// ignore_for_file: dead_code

import 'dart:developer';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:get/get.dart';
import 'package:hkcoin/core/err/exception.dart';
import 'package:hkcoin/core/err/failures.dart';
import 'package:hkcoin/core/toast.dart';

Future<T> handleRemoteRequest<T>(
  Future<T> Function() onRequest, {
  bool shoudleHandleError = true,
}) async {
  String defaultErr = Get.context?.tr('Identity.Error.DefaultError') ?? "";
  if (shoudleHandleError) {
    try {
      var value = await onRequest();
      return value;
    } on ServerException {
      rethrow;
    } on DioError {
      throw ServerException(message: defaultErr);
    } catch (e) {
      bool debug = true;
      throw ServerException(message: debug ? e.toString() : defaultErr);
    }
  } else {
    var value = await onRequest();
    return value;
  }
}

Future<Either<Failure, T>> handleRepositoryCall<T>({
  required Future<Either<Failure, T>> Function() onRemote,
  bool shoudleHandleError = true,
}) async {
  if (!shoudleHandleError) {
    return await onRemote();
  }
  try {
    return await onRemote();
  } on NetWorkException catch (e) {
    return Left(NetworkFailure(message: e.failure.message));
  } on ServerException catch (e) {
    return Left(ServerFailure(message: e.message));
  }
}

handleEither<B, T extends Failure, S>(
  Either<T, S> either,
  B Function(S r) onResult, {
  bool shouldHandleError = true,
  Function(String message)? onError,
  String? defaultError,
}) async {
  either.fold((l) {
    if (onError != null) {
      onError(l.message ?? "");
      log(defaultError ?? l.message ?? "");
    }
    if (shouldHandleError) {
      handleError(
        defaultError ?? l.message ?? "",
        shouldUseDefaultError: defaultError != null || l is NetworkFailure,
      );
    }
  }, onResult);
}

handleEitherReturn<Result, Left extends Failure, Right>(
  Either<Left, Right> either,
  Future<Result> Function(Right r) onResult, {
  Future<Result> Function(String message)? onError,
  bool shouldHandleError = true,
  String? defaultError,
}) {
  return either.fold((l) {
    if (shouldHandleError) {
      handleError(
        defaultError ?? l.message ?? "",
        shouldUseDefaultError: defaultError != null || l is NetworkFailure,
      );
    }
    if (onError != null) {
      onError(l.message ?? "");
    }
  }, onResult);
}

Future handleError(String message, {bool shouldUseDefaultError = true}) async {
  try {
    // because test getit dont init so Thinking to much about injection this AppMessage to all bloc ?
    Toast.showErrorToast(message);
    log(message);
  } catch (e) {
    return;
  }
}
