import 'package:dartz/dartz.dart';
import 'package:hkcoin/core/err/failures.dart';
import 'package:hkcoin/core/request_handler.dart';
import 'package:hkcoin/data.datasources/cart_datasource.dart';
import 'package:hkcoin/data.models/cart.dart';

class CartRepository {
  Future<Either<Failure, Cart>> getCart() {
    return handleRepositoryCall(
      onRemote: () async {
        var info = await CartDatasource().getCart();
        return Right(info);
      },
      shoudleHandleError: false,
    );
  }

  Future<Either<Failure, void>> addToCart(int productId, int price) {
    return handleRepositoryCall(
      onRemote: () async {
        await CartDatasource().addToCart(productId, price);
        return const Right(null);
      },
    );
  }

  Future<Either<Failure, void>> updateCartItem(int productId, int price) {
    return handleRepositoryCall(
      onRemote: () async {
        await CartDatasource().updateCartItem(productId, price);
        return const Right(null);
      },
    );
  }

  Future<Either<Failure, void>> deleteCart() {
    return handleRepositoryCall(
      onRemote: () async {
        await CartDatasource().deleteCart();
        return const Right(null);
      },
    );
  }
}
