// ignore_for_file: dead_code

import 'dart:developer';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:hkcoin/core/err/error_notifier.dart';
import 'package:hkcoin/core/err/exception.dart';
import 'package:hkcoin/core/err/failures.dart';
import 'package:hkcoin/core/toast.dart';
import 'package:hkcoin/localization/localization_context_extension.dart';
import 'package:hkcoin/localization/localization_service.dart';

// -------------------------------
// HANDLE REMOTE REQUEST
// -------------------------------
Future<T> handleRemoteRequest<T>(
  Future<T> Function() onRequest, {
  bool shoudleHandleError = true,
}) async {
  // ⭐ Không dùng Get.context?.tr nữa — dùng global tr()
  String defaultErr = tr("Identity.Error.DefaultError");

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
    return await onRequest();
  }
}

// -------------------------------
// HANDLE REPOSITORY CALL
// -------------------------------
Future<Either<Failure, T>> handleRepositoryCalls<T>({
  required Future<Either<Failure, T>> Function() onRemote,
  bool shoudleHandleError = true,
}) async {
  if (!shoudleHandleError) {
    return await onRemote();
  }

  try {
    return await onRemote();
  } on NetWorkExceptions catch (e) {
    return Left(NetworkFailures(message: e.failured.message));
  } on ServerException catch (e) {
    return Left(ServerFailures(message: e.message));
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
  } on NetWorkExceptions catch (e) {
    return Left(NetworkFailures(message: e.failured.message));
  } on ServerException catch (e) {
    return Left(
      ServerFailures(
        message: e.message,
        statusCode: e.statusCode,
        errors: e.errors,
      ),
    );
  } catch (e) {
    // ⭐ BẮT BUỘC
    return const Left(
      ServerFailures(message: "Có lỗi xảy ra, vui lòng thử lại"),
    );
  }
}

// -------------------------------
// HANDLE EITHER (Sync)
// -------------------------------
handleEither<B, T extends Failure, S>(
  Either<T, S> either,
  B Function(S r) onResult, {
  bool shouldHandleError = true,
  Function(String message)? onError,
  String? defaultError,
}) async {
  either.fold((l) {
    String message = defaultError ?? l.message ?? "";

    if (onError != null) {
      onError(message);
      log(message);
    }

    if (shouldHandleError) {
      handleError(
        message,
        shouldUseDefaultError: defaultError != null || l is NetworkFailure,
      );
    }
  }, onResult);
}

// -------------------------------
// HANDLE EITHER (Async Return)
// -------------------------------
handleEitherReturn<Result, Left extends Failure, Right>(
  Either<Left, Right> either,
  Future<Result> Function(Right r) onResult, {
  Future<Result> Function(String message)? onError,
  bool shouldHandleError = true,
  String? defaultError,
}) {
  return either.fold((l) {
    String message = defaultError ?? l.message ?? "";

    if (shouldHandleError) {
      handleError(
        message,
        shouldUseDefaultError: defaultError != null || l is NetworkFailure,
      );
    }

    if (onError != null) {
      onError(message);
    }
  }, onResult);
}

Future<Result?> handleEitherReturns<Result, L extends Failure, R>(
  Either<L, R> either,
  Future<Result> Function(R r) onResult, {
  Future<Result?> Function(L failure)? onError,
  bool autoNotify = true, // ⭐ FLAG
}) async {
  return either.fold((failure) async {
    if (autoNotify) {
      ErrorNotifier.notify(failure); // 🔥 DUY NHẤT
    }
    if (onError != null) {
      return await onError(failure);
    }

    // Toast.showErrorToast(resolveFailureMessage(failure));
    return null;
  }, (r) async => await onResult(r));
}

// -------------------------------
// HANDLE ERROR
// -------------------------------
Future handleError(String message, {bool shouldUseDefaultError = true}) async {
  try {
    Toast.showErrorToast(message);
    log(message);
  } catch (e) {
    return;
  }
}
