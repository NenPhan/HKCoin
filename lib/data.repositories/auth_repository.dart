import 'package:dartz/dartz.dart';
import 'package:hkcoin/core/err/failures.dart';
import 'package:hkcoin/core/request_handler.dart';
import 'package:hkcoin/data.datasources/auth_datasource.dart';

class AuthRepository {
  Future<Either<Failure, void>> login(String username, String password) {
    return handleRepositoryCall(
      onRemote: () async {
        await AuthDatasource().login(username, password);
        return const Right(null);
      },
    );
  }
}
