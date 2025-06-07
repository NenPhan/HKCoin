import 'package:dartz/dartz.dart';
import 'package:hkcoin/core/err/failures.dart';
import 'package:hkcoin/core/request_handler.dart';
import 'package:hkcoin/data.datasources/WalletDatasource.dart';
import 'package:hkcoin/data.models/blockchange_wallet_info.dart';
import 'package:hkcoin/data.models/network.dart';
import 'package:hkcoin/data.models/wallet.dart';

class WalletRepository {
  Future<Either<Failure, List<Network>>> getNetworks() {
    return handleRepositoryCall(
      onRemote: () async {
        return Right(await WalletDatasource().getNetworks());
      },
    );
  }
  Future<Either<Failure, BlockchangeWallet>> createWallet(BlockchangeWallet wallet) {
    return handleRepositoryCall(
      onRemote: () async {
        var result = await WalletDatasource().createWallet(wallet);       
        return Right(result);
      },
    );
  }  
   Future<Either<Failure, bool>> selectedWallet(BlockchangeWallet wallet) {
    return handleRepositoryCall(
      onRemote: () async {          
        return Right(await WalletDatasource().selectedWallet(wallet));
      },
    );
  } 
  Future<Either<Failure, BlockchangeWalletInfo?>> getWalletInfo() {
    return handleRepositoryCall(
      onRemote: () async {
        var result = await WalletDatasource().getWalletInfo();       
        return Right(result);
      },
    );
  }  
  Future<Either<Failure, List<BlockchangeWallet>>> getWallets() {
    return handleRepositoryCall(
      onRemote: () async {
        var result = await WalletDatasource().getWallets();       
        return Right(result);
      },
    );
  }  
}