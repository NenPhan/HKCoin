import 'package:get/get.dart';
import 'package:hkcoin/core/request_handler.dart';
import 'package:hkcoin/data.models/news_detail.dart';
import 'package:hkcoin/data.repositories/news_repository.dart';

class NewsDetailController extends GetxController {
  NewsDetail? data;
  RxBool isLoading = false.obs;

  @override
  onInit() {    
    if (Get.arguments is int) {
      getNewsDetailData(Get.arguments as int);
    } else {
      isLoading.value = false;      
    }
    super.onInit();
  }

  getNewsDetailData(int id) async {
    isLoading.value = true;
    await handleEither(await NewsRepository().getNewsDetail(id), (news) {
      data = news;
    });
    isLoading.value = false;
  }
}
