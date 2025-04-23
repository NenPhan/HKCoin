import 'package:dartz/dartz.dart';
import 'package:hkcoin/core/err/failures.dart';
import 'package:hkcoin/data.datasources/auth_datasource.dart';

class AuthRepository {
  Future<Either<Failure, void>> login(String username, String password) async {
    try {
      AuthDatasource().login(username, password);
      return const Right(null);
    } catch (e) {
      return const Left(ServerFailure(message: "Failed AuthRepository"));
    }
  }
}
