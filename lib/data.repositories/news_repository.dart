import 'package:dartz/dartz.dart';
import 'package:hkcoin/core/err/failures.dart';
import 'package:hkcoin/core/request_handler.dart';
import 'package:hkcoin/data.datasources/news_datasource.dart';
import 'package:hkcoin/data.models/news.dart';
import 'package:hkcoin/data.models/news_detail.dart';
import 'package:hkcoin/data.models/newscatergory.dart';
import 'package:hkcoin/data.models/slide.dart';

class NewsRepository {
  Future<Either<Failure, List<NewsCategory>>> getNewsCategory() {
    return handleRepositoryCall(
      onRemote: () async {
        return Right(await NewsDatasource().getNewsCategory());
      },
    );
  }
   Future<Either<Failure, NewsPagination>> getNewsByCategories({
    required int catergoryId,
    int page = 1,
    int limit = 10,
  }) {
    return handleRepositoryCall(
      onRemote: () async {
        return Right(
          await NewsDatasource().getNewsByCategoryData(
            newsCatergoryId: catergoryId,
            page: page,
            limit: limit,
          ),
        );
      },
    );
  }
  Future<Either<Failure, NewsCategory>> getNewsCategoryDetail(int id) {
    return handleRepositoryCall(
      onRemote: () async {
        var result = await NewsDatasource().getCategoryNewsDetail(id);
        return Right(result);
      },
    );
  }
  Future<Either<Failure, List<News>>> getNews() {
    return handleRepositoryCall(
      onRemote: () async {
        return Right(await NewsDatasource().getNews());
      },
    );
  }
  
 Future<Either<Failure, NewsDetail>> getNewsDetail(int id) {
    return handleRepositoryCall(
      onRemote: () async {
        var result = await NewsDatasource().getNewsDetail(id);
        return Right(result);
      },
    );
  }
  Future<Either<Failure, List<Slide>>> getSlides() {
    return handleRepositoryCall(
      onRemote: () async {
        return Right(await NewsDatasource().getSlides());
      },
    );
  }
}
