import 'package:hkcoin/core/err/failures.dart';
import 'package:hkcoin/localization/localization_service.dart';

///One Exception can be many failures
class ServerExceptions {
  final String? message;
  ServerExceptions({this.message});

  @override
  String toString() {
    return "ServerException message: $message";
  }
}

class ServerException implements Exception {
  final int? statusCode;
  final String message;
  final List<String>? errors;

  ServerException({this.statusCode, required this.message, this.errors});
  @override
  String toString() => 'ServerException($statusCode): $message ${errors ?? ''}';
}

class NetWorkException {
  final NetworkFailure failure;
  NetWorkException(this.failure);
}

class NetWorkExceptions {
  final NetworkFailures failured;
  NetWorkExceptions(this.failured);
}

class CacheException {
  final String message;
  CacheException(this.message);

  @override
  String toString() {
    return "CacheException message: $message";
  }
}

class ErrorHandler {
  ///map err from server to correct

  static final errors = {
    "Email or password is incorrect": tr('email_or_pass_incorrect'),
    "Token expired": tr('token_expired'),
  };

  static String? parse(
    String error, {
    bool shouldUseDefaultError = true,
    String? defaultError,
  }) {
    ///remove some text in err to show correct err
    if (error.indexOf("E_NGW001") == 0) {
      return error.replaceAll("E_NGW001", "");
    }
    if (error.indexOf("E_ACC002") == 0) {
      return error.replaceAll("E_ACC002", "");
    }
    if (error.indexOf("E_ACC004") == 0) {
      return error.replaceAll("E_ACC004", "");
    }
    if (error.indexOf("E_SEN001") == 0) {
      return error.replaceAll("E_SEN001", "");
    }
    if (defaultError != null || shouldUseDefaultError) {
      return defaultError ?? tr('an_error_has_occured');
    }
    return errors.containsKey(error) ? errors[error] : error;
  }
}
