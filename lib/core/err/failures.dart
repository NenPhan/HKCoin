import 'package:equatable/equatable.dart';

abstract class Failures extends Equatable {
  final String? message;
  const Failures(this.message);
  @override
  List<Object> get props => [];
}

class DataInputFailure extends Failures {
  const DataInputFailure({String? message}) : super(message);
}

class ServerFailure extends Failures {
  const ServerFailure({String? message}) : super(message);
}

class NetworkFailure extends Failures {
  const NetworkFailure({String? message}) : super(message);
}

class UnexpectedFailure extends Failures {
  const UnexpectedFailure(String message) : super(message);
}

class CacheFailure extends Failures {
  const CacheFailure([String message = 'Cache Failure']) : super(message);
}

abstract class Failure {
  final String message;
  final int? statusCode;
  final List<String>? errors;

  const Failure({required this.message, this.statusCode, this.errors});
}

class ServerFailures extends Failure {
  const ServerFailures({
    required super.message,
    super.statusCode,
    super.errors,
  });
}

class NetworkFailures extends Failure {
  const NetworkFailures({required super.message});
}
