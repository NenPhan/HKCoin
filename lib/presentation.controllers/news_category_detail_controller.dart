import 'package:get/get.dart';
import 'package:hkcoin/core/request_handler.dart';
import 'package:hkcoin/data.models/newscatergory.dart';
import 'package:hkcoin/data.repositories/news_repository.dart';

class NewsCategoryDetailController extends GetxController {
  NewsCategory? data;
  RxBool isLoading = false.obs;

  @override
  onInit() {    
    if (Get.arguments is int) {
      getNewsCategoryDetailData(Get.arguments as int);
    } else {
      isLoading.value = false;      
    }
    super.onInit();
  }

  getNewsCategoryDetailData(int id) async {
    isLoading.value = true;
    await handleEither(await NewsRepository().getNewsCategoryDetail(id), (news) {
      data = news;
    });
    isLoading.value = false;
  }
}
