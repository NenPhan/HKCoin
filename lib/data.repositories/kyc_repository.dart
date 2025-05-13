import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:hkcoin/core/err/failures.dart';
import 'package:hkcoin/core/request_handler.dart';
import 'package:hkcoin/data.datasources/kyc_datasource.dart';
import 'package:hkcoin/data.models/kyc_info.dart';
import 'package:hkcoin/data.models/kyc_status.dart';
import 'package:hkcoin/data.models/params/update_kyc_param.dart';

class KycRepository {
  Future<Either<Failure, KycInfo>> getKycInfo() {
    return handleRepositoryCall(
      onRemote: () async {
        var result = await KycDatasource().getKycInfo();
        return Right(result);
      },
    );
  }

  Future<Either<Failure, KycStatus>> getKycStatus() {
    return handleRepositoryCall(
      onRemote: () async {
        var result = await KycDatasource().getKycStatus();
        return Right(result);
      },
    );
  }

  Future<Either<Failure, void>> updateKycInfo(UpdateKycParam param) {
    return handleRepositoryCall(
      onRemote: () async {
        await KycDatasource().updateKycInfo(param);
        return const Right(null);
      },
    );
  }

  Future<Either<Failure, void>> kycValidate({
    required String name,
    required File file,
  }) {
    return handleRepositoryCall(
      onRemote: () async {
        await KycDatasource().kycValidate(name, file);
        return const Right(null);
      },
    );
  }
}
