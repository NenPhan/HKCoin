import 'package:dartz/dartz.dart';
import 'package:hkcoin/core/err/failures.dart';
import 'package:hkcoin/core/request_handler.dart';
import 'package:hkcoin/data.datasources/product_datasource.dart';
import 'package:hkcoin/data.models/product.dart';

class ProductRepository {
  Future<Either<Failure, List<Product>>> getProducts() {
    return handleRepositoryCall(
      onRemote: () async {
        return Right(await ProductDatasource().getProducts());
      },
    );
  }
}
