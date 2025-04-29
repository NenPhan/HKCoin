import 'dart:developer';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hkcoin/core/err/exception.dart';
import 'package:hkcoin/core/err/failures.dart';
import 'package:hkcoin/core/toast.dart';

Future<T> handleRemoteRequest<T>(
  Future<T> Function() onRequest, {
  bool shoudleHandleError = true,
}) async {
  String defaultErr = 'Identity.Error.DefaultError'.tr();
  if (shoudleHandleError) {
    try {
      var value = await onRequest();
      return value;
    } on ServerException {
      rethrow;
    } on DioError {
      throw ServerException(message: defaultErr);
    } catch (e) {
      throw ServerException(message: e.toString());
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
  bool? shouldUseDefaultError,
  String? defaultError,
}) {
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

handleEitherReturn<B, T extends Failure, S>(
  Either<T, S> either,
  B Function(S r) onResult, {
  Function()? onError,
}) {
  return either.fold((l) {
    handleError(l.message ?? "");
    if (onError != null) {
      onError();
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
