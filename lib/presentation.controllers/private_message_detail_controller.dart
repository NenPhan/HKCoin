import 'package:get/get.dart';
import 'package:hkcoin/core/request_handler.dart';
import 'package:hkcoin/data.models/private_message.dart';
import 'package:hkcoin/data.repositories/message_repository.dart';

class PrivateMessageDetailController extends GetxController {
  PrivateMessage? data;
  RxBool isLoading = false.obs;

  @override
  onInit() {    
    if (Get.arguments is int) {
      getPrivateMessageDetailData(Get.arguments as int);
    } else {
      isLoading.value = false;      
    }
    super.onInit();
  }

  getPrivateMessageDetailData(int id) async {
    isLoading.value = true;
    await handleEither(await MessageRepository().getPrivateMessageDetail(id), (d) {
      data = d;
    });
    isLoading.value = false;
  }
  
}
