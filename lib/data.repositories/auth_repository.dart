import 'package:dartz/dartz.dart';
import 'package:hkcoin/core/err/failures.dart';
import 'package:hkcoin/core/presentation/storage.dart';
import 'package:hkcoin/core/request_handler.dart';
import 'package:hkcoin/data.datasources/auth_datasource.dart';
import 'package:hkcoin/data.models/customer_info.dart';
import 'package:hkcoin/data.models/register_form.dart';
import 'package:hkcoin/data.models/wallet_info.dart';

class AuthRepository {
  Future<Either<Failure, void>> login(String username, String password) {
    return handleRepositoryCall(
      onRemote: () async {
        await AuthDatasource().login(username, password);
        return const Right(null);
      },
    );
  }

  Future<Either<Failure, void>> register(RegisterForm form) {
    return handleRepositoryCall(
      onRemote: () async {
        await AuthDatasource().register(form);
        return const Right(null);
      },
    );
  }

  Future<Either<Failure, CustomerInfo>> getCustomerInfo() {
    return handleRepositoryCall(
      onRemote: () async {
        var info = await AuthDatasource().getCustomerInfo();
        Storage().saveCustomer(info);
        return Right(info);
      },
    );
  }

  Future<Either<Failure, WalletInfo>> getWalletInfo() {
    return handleRepositoryCall(
      onRemote: () async {
        var info = await AuthDatasource().getWalletInfo();
        return Right(info);
      },
    );
  }

  Future<Either<Failure, void>> logout() {
    return handleRepositoryCall(
      onRemote: () async {
        await AuthDatasource().logout();
        return const Right(null);
      },
    );
  }
}
