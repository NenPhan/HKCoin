import 'package:dartz/dartz.dart';
import 'package:hkcoin/core/err/failures.dart';
import 'package:hkcoin/core/request_handler.dart';
import 'package:hkcoin/data.datasources/product_datasource.dart';
import 'package:hkcoin/data.models/order.dart';
import 'package:hkcoin/data.models/product.dart';
import 'package:hkcoin/data.models/product_detail.dart';

class ProductRepository {
  Future<Either<Failure, List<Product>>> getProducts() {
    return handleRepositoryCall(
      onRemote: () async {
        return Right(await ProductDatasource().getProducts());
      },
    );
  }
   Future<Either<Failure, ProductDetail>> getProductsById(int id) {
    return handleRepositoryCall(
      onRemote: () async {
        var result = await ProductDatasource().getProductsById(id);
        return Right(result);
      },
    );
  }
  Future<Either<Failure, OrderPagination>> getOrders({
    int page = 1,
    int limit = 10,
  }) {
    return handleRepositoryCall(
      onRemote: () async {
        return Right(
          await ProductDatasource().getOrders(page: page, limit: limit),
        );
      },
    );
  }
}
