import 'package:get/get.dart';
import 'package:hkcoin/core/request_handler.dart';
import 'package:hkcoin/data.models/news.dart';
import 'package:hkcoin/data.models/newscatergory.dart';
import 'package:hkcoin/data.repositories/news_repository.dart';

class NewsController extends GetxController {
  NewsPagination? newsPagination;
  List<News> news = [];
  final RxList<NewsCategory> categories = <NewsCategory>[].obs;
  final isLoadingCategories = false.obs;
  RxBool isLoadingNews = false.obs;
  final RxBool isInitialLoading = true.obs;
  final RxBool isLoadingMore = false.obs;
  final RxBool isLoading = false.obs;
  @override  
  void onInit() {
    getNewsData();    
    loadCategories();
    super.onInit();
  }
   void getNewsData() async {
    isLoadingNews.value = true;
    await handleEither(await NewsRepository().getNews(), (r) {
      news = r;
    });
    isLoadingNews.value = false;
    update(["news-page"]);
  }
  //load list newsgroup
   Future<void> loadCategories() async {
    isLoadingCategories.value = true;
    try {
       await handleEither(await NewsRepository().getNewsCategory(), (r) {
        categories.value = r;
      });      
    } finally {
      isLoadingCategories.value = false;
      update(["news-page"]);
    }
  }
  Future getNewsByCategories({required int catergoryId, int page = 1, bool isLoadMore = false, int limit = 15}) async {
    if (!isLoadMore) {
      isInitialLoading.value = true;
    } else {
      isLoadingMore.value = true;
    }
    try{                     
        await handleEither(
          await NewsRepository().getNewsByCategories(catergoryId: catergoryId, page: page, limit: limit),
          (r) {
            if (isLoadMore) {
              newsPagination?.news?.addAll(r.news ?? []);
              // Update pagination info
              newsPagination?.pageNumber = r.pageNumber;//currentPage
              newsPagination?.hasNextPage = r.hasNextPage;          
              newsPagination?.totalPages = r.totalPages;
            }else{
              newsPagination = r;
            }          
          },
        );
       // isLoading.value = false;
        update(["news-list-$catergoryId"]);

        if (page == 1) {
          update(["news-pagination"]);
        }
    }catch(e){
      rethrow;
    }
    finally {
      isInitialLoading.value = false;
      isLoadingMore.value = false;
    }
   
  }
}