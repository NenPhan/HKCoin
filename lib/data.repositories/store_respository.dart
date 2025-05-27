
import 'package:dartz/dartz.dart';
import 'package:hkcoin/core/err/failures.dart';
import 'package:hkcoin/core/request_handler.dart';
import 'package:hkcoin/data.datasources/store_datasource.dart';
import 'package:hkcoin/data.models/store.dart';

class StoreRepository {
  Future<Either<Failure, Store>> getCurrentStore() {
    return handleRepositoryCall(
      onRemote: () async {
        var result = await StoreDatasource().getCurrentStore();
        return Right(result);
      },
    );
  }
}