import 'package:dartz/dartz.dart';
import 'package:hkcoin/core/err/failures.dart';
import 'package:hkcoin/core/presentation/storage.dart';
import 'package:hkcoin/core/request_handler.dart';
import 'package:hkcoin/data.datasources/customer_datasource.dart';
import 'package:hkcoin/data.models/add_wallet_token.dart';
import 'package:hkcoin/data.models/customer_downlines.dart';
import 'package:hkcoin/data.models/params/change_password_param.dart';
import 'package:hkcoin/data.models/customer_info.dart';
import 'package:hkcoin/data.models/register_form.dart';
import 'package:hkcoin/data.models/wallet_histories.dart';
import 'package:hkcoin/data.models/wallet_info.dart';
import 'package:hkcoin/data.models/wallet_token.dart';
// import 'package:device_info_plus/device_info_plus.dart';

// DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
// AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
// print('Running on ${androidInfo.model}');  // e.g. "Moto G (4)"

// IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
// print('Running on ${iosInfo.utsname.machine}');  // e.g. "iPod7,1"

// WebBrowserInfo webBrowserInfo = await deviceInfo.webBrowserInfo;
// print('Running on ${webBrowserInfo.userAgent}');  // e.g. "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:61.0) Gecko/20100101 Firefox/61.0"
class CustomerRepository {
  Future<Either<Failure, void>> login(String username, String password) {
    return handleRepositoryCall(
      onRemote: () async {
        await CustomerDatasource().login(username, password);
        return const Right(null);
      },
    );
  }

  Future<Either<Failure, void>> updateDeviceToken(String? token) {
    return handleRepositoryCall(
      onRemote: () async {
        await CustomerDatasource().updateDeviceToken(token);
        return const Right(null);
      },
    );
  }

  Future<Either<Failure, void>> register(RegisterForm form) {
    return handleRepositoryCall(
      onRemote: () async {
        await CustomerDatasource().register(form);
        return const Right(null);
      },
    );
  }

  Future<Either<Failure, CustomerInfo>> getCustomerInfo() {
    return handleRepositoryCall(
      onRemote: () async {
        var result = await CustomerDatasource().getCustomerInfo();
        Storage().saveCustomer(result);
        return Right(result);
      },
    );
  }

  Future<Either<Failure, void>> updateCustomerInfo(CustomerInfo customerInfo) {
    return handleRepositoryCall(
      onRemote: () async {
        var result = await CustomerDatasource().updateCustomerInfo(
          customerInfo,
        );
        Storage().saveCustomer(result);
        return const Right(null);
      },
    );
  }

  Future<Either<Failure, void>> changePassword(ChangePasswordParam param) {
    return handleRepositoryCall(
      onRemote: () async {
        await CustomerDatasource().changePassword(param);
        return const Right(null);
      },
    );
  }

  Future<Either<Failure, CustomerDownlines>> getCustomerDownlinesData({
    int parentId = 0,
    int page = 1,
    int limit = 10,
  }) {
    return handleRepositoryCall(
      onRemote: () async {
        return Right(
          await CustomerDatasource().getCustomerDownlinesData(
            parentId: parentId,
            page: page,
            limit: limit,
          ),
        );
      },
    );
  }

  Future<Either<Failure, WalletInfo>> getWalletInfo() {
    return handleRepositoryCall(
      onRemote: () async {
        var result = await CustomerDatasource().getWalletInfo();
        return Right(result);
      },
    );
  }

  Future<Either<Failure, List<WalletToken>>> getWalletTokens() {
    return handleRepositoryCall(
      onRemote: () async {
        var result = await CustomerDatasource().getWalletTokens();
        return Right(result);
      },
    );
  }
  Future<Either<Failure, AddWalletToken>> addWalletToken() {
    return handleRepositoryCall(
      onRemote: () async {
        var result = await CustomerDatasource().addWalletToken();       
        return Right(result);
      },
    );
  }
   Future<Either<Failure, AddWalletToken>> submitWalletToken(AddWalletToken form) {
    return handleRepositoryCall(
      onRemote: () async {
        var result = await CustomerDatasource().submitWalletToken(form);       
        return Right(result);
      },
    );
  } 

  Future<Either<Failure, WalletHistoriesPagination>> getWalletHistories({
    int page = 1,
    int limit = 10,
  }) {
    return handleRepositoryCall(
      onRemote: () async {
        return Right(
          await CustomerDatasource().getWalletHistoresData(
            page: page,
            limit: limit,
          ),
        );
      },
    );
  }

  Future<Either<Failure, void>> logout() {
    return handleRepositoryCall(
      onRemote: () async {
        await CustomerDatasource().logout();
        return const Right(null);
      },
    );
  }
}
