import 'package:dartz/dartz.dart';
import 'package:hkcoin/core/err/failures.dart';
import 'package:hkcoin/core/request_handler.dart';
import 'package:hkcoin/data.datasources/wallet_datasource.dart';
import 'package:hkcoin/data.models/blockchange_wallet_info.dart';
import 'package:hkcoin/data.models/blockchange_wallet_token_info.dart';
import 'package:hkcoin/data.models/customer_wallet_token.dart';
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
  Future<Either<Failure, CustomerWalletToken>> createCustomerToken(CustomerWalletToken wallet) {
    return handleRepositoryCall(
      onRemote: () async {
        var result = await WalletDatasource().createCustomerToken(wallet);       
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
    Future<Either<Failure, void>> deleteWallet(int walletId) {
    return handleRepositoryCall(
      onRemote: () async {          
        return Right(await WalletDatasource().deleteWallet(walletId));
      },
    );
  } 
   Future<Either<Failure, BlockchangeWalletInfo?>> getWalletById(int walletId) {
    return handleRepositoryCall(
      onRemote: () async {
        var result = await WalletDatasource().getWalletById(walletId);       
        return Right(result);
      },
    );
  }  
  Future<Either<Failure, BlockchangeWalletTokenInfo?>> getWalletTokenById(int walletId) {
    return handleRepositoryCall(
      onRemote: () async {
        var result = await WalletDatasource().getWalletTokenById(walletId);       
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