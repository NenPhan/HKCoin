import 'package:dartz/dartz.dart';
import 'package:hkcoin/core/err/failures.dart';
import 'package:hkcoin/core/request_handler.dart';
import 'package:hkcoin/data.datasources/news_datasource.dart';
import 'package:hkcoin/data.models/news.dart';

class NewsRepository {
  Future<Either<Failure, List<News>>> getNews() {
    return handleRepositoryCall(
      onRemote: () async {
        return Right(await NewsDatasource().getNews());
      },
    );
  }
}
