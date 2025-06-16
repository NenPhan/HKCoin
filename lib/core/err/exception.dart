import 'package:easy_localization/easy_localization.dart';
import 'package:get/get.dart';
import 'package:hkcoin/core/err/failures.dart';

///One Exception can be many failures
class ServerException {
  final String? message;
  ServerException({this.message});

  @override
  String toString() {
    return "ServerException message: $message";
  }
}

class NetWorkException {
  final NetworkFailure failure;
  NetWorkException(this.failure);
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
    "Email or password is incorrect": Get.context?.tr(
      'email_or_pass_incorrect',
    ),
    "Token expired": Get.context?.tr('token_expired'),
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
      return defaultError ?? Get.context?.tr('an_error_has_occured');
    }
    return errors.containsKey(error) ? errors[error] : error;
  }
}
