import 'package:dartz/dartz.dart';
import 'package:hkcoin/core/err/failures.dart';
import 'package:hkcoin/core/request_handler.dart';
import 'package:hkcoin/data.datasources/checkout_datasource.dart';
import 'package:hkcoin/data.models/address.dart';
import 'package:hkcoin/data.models/cart.dart';
import 'package:hkcoin/data.models/checkout_data.dart';
import 'package:hkcoin/data.models/order_total.dart';
import 'package:hkcoin/data.models/params/add_address_param.dart';

class CheckoutRepository {
  Future<Either<Failure, Cart>> getCart() {
    return handleRepositoryCall(
      onRemote: () async {
        var result = await CheckoutDatasource().getCart();
        return Right(result);
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
        var result = await CheckoutDatasource().getAddresses();
        return Right(result);
      },
    );
  }

  Future<Either<Failure, void>> addAddress(AddAddressParam param) {
    return handleRepositoryCall(
      onRemote: () async {
        await CheckoutDatasource().addAddress(param);
        return const Right(null);
      },
    );
  }

  Future<Either<Failure, void>> selectAddress(int? id) {
    return handleRepositoryCall(
      onRemote: () async {
        await CheckoutDatasource().selectAddress(id);
        return const Right(null);
      },
    );
  }

  Future<Either<Failure, CheckoutData>> getCheckoutData() {
    return handleRepositoryCall(
      onRemote: () async {
        var result = await CheckoutDatasource().getCheckoutData();
        return Right(result);
      },
    );
  }

  Future<Either<Failure, void>> selectPaymmentMethod(String? methodName) {
    return handleRepositoryCall(
      onRemote: () async {
        await CheckoutDatasource().selectPaymentMethod(methodName);
        return const Right(null);
      },
    );
  }

  Future<Either<Failure, int?>> checkout(
    int? addressId,
    String? paymentMethodName,
  ) {
    return handleRepositoryCall(
      onRemote: () async {
        int? id = await CheckoutDatasource().checkout(
          addressId,
          paymentMethodName,
        );
        return Right(id);
      },
    );
  }

  Future<Either<Failure, CheckoutCompleteData>> checkoutComplete(int id) {
    return handleRepositoryCall(
      onRemote: () async {
        var result = await CheckoutDatasource().checkoutComplete(id);
        return Right(result);
      },
    );
  }

  Future<Either<Failure, OrderTotal>> getOrderTotal() {
    return handleRepositoryCall(
      onRemote: () async {
        var result = await CheckoutDatasource().getOrderTotal();
        return Right(result);
      },
    );
  }
}
