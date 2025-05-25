import 'package:get/get.dart';
import 'package:hkcoin/core/request_handler.dart';
import 'package:hkcoin/data.models/wallet_token.dart';
import 'package:hkcoin/data.repositories/customer_repository.dart';

class WalletTokenController extends GetxController {
  List<WalletToken> walletTokens = [];
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    getWalletTokens();
    super.onInit();
  }

  getWalletTokens() async {
    isLoading.value = true;
    await handleEitherReturn(await CustomerRepository().getWalletTokens(), (
      r,
    ) async {
      walletTokens = r;
    });
    isLoading.value = false;
  }
}
