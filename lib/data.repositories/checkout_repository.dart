import 'package:dartz/dartz.dart';
import 'package:hkcoin/core/err/failures.dart';
import 'package:hkcoin/core/request_handler.dart';
import 'package:hkcoin/data.datasources/checkout_datasource.dart';
import 'package:hkcoin/data.models/address.dart';
import 'package:hkcoin/data.models/cart.dart';
import 'package:hkcoin/data.models/province.dart';

class CheckoutRepository {
  Future<Either<Failure, Cart>> getCart() {
    return handleRepositoryCall(
      onRemote: () async {
        var info = await CheckoutDatasource().getCart();
        return Right(info);
      },
    );
  }

  Future<Either<Failure, void>> addToCart(int productId, int price) {
    return handleRepositoryCall(
      onRemote: () async {
        await CheckoutDatasource().addToCart(productId, price);
        return const Right(null);
      },
    );
  }

  Future<Either<Failure, void>> updateCartItem(int productId, int price) {
    return handleRepositoryCall(
      onRemote: () async {
        await CheckoutDatasource().updateCartItem(productId, price);
        return const Right(null);
      },
    );
  }

  Future<Either<Failure, void>> deleteCart() {
    return handleRepositoryCall(
      onRemote: () async {
        await CheckoutDatasource().deleteCart();
        return const Right(null);
      },
    );
  }

  Future<Either<Failure, List<Address>>> getAddresses() {
    return handleRepositoryCall(
      onRemote: () async {
        var info = await CheckoutDatasource().getAddresses();
        return Right(info);
      },
    );
  }

  Future<Either<Failure, List<Province>>> getProvinces() {
    return handleRepositoryCall(
      onRemote: () async {
        var info = await CheckoutDatasource().getProvinces();
        return Right(info);
      },
    );
  }
}
