import 'package:dartz/dartz.dart';
import 'package:hkcoin/core/err/failures.dart';
import 'package:hkcoin/core/request_handler.dart';
import 'package:hkcoin/data.datasources/util_datasource.dart';
import 'package:hkcoin/data.models/country.dart';
import 'package:hkcoin/data.models/province.dart';

class UtilRepository {
  Future<Either<Failure, List<Province>>> getProvinces() {
    return handleRepositoryCall(
      onRemote: () async {
        var result = await UtilDatasource().getProvinces();
        return Right(result);
      },
    );
  }

  Future<Either<Failure, List<Country>>> getCountries() {
    return handleRepositoryCall(
      onRemote: () async {
        var result = await UtilDatasource().getCountries();
        return Right(result);
      },
    );
  }
}
