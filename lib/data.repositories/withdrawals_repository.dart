import 'package:dartz/dartz.dart';
import 'package:hkcoin/core/err/failures.dart';
import 'package:hkcoin/core/request_handler.dart';
import 'package:hkcoin/data.datasources/withdrawals_datasource.dart';
import 'package:hkcoin/data.models/withdrawals_exchangeprice.dart';
import 'package:hkcoin/data.models/withdrawals_histories.dart';
import 'package:hkcoin/data.models/withdrawals_profit.dart';

class WithDrawalsRepository {   
  Future<Either<Failure, WithDrawalsProfit>> getWithDrawalsProfit() {
    return handleRepositoryCall(
      onRemote: () async {
        var result = await WithDrawalsDatasource().getWithDrawalsProfit();       
        return Right(result);
      },
    );
  }

  Future<Either<Failure, WithDrawalHistoriesPagination>> getWithDrawalHistoriesData({
    int page = 1,
    int limit = 10,
  }) {
    return handleRepositoryCall(
      onRemote: () async {
        return Right(
          await WithDrawalsDatasource().getWithDrawalHistoriesData(page: page, limit: limit),
        );
      },
    );
  }
  Future<Either<Failure, ExchangePrice>> getExchangePrice(int tokenType) {
    return handleRepositoryCall(
      onRemote: () async {
        var result = await WithDrawalsDatasource().getExchangePrice(tokenType);       
        return Right(result);
      },
    );
  }
}
