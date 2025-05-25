import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hkcoin/core/extensions/extensions.dart';
import 'package:hkcoin/core/request_handler.dart';
import 'package:hkcoin/core/toast.dart';
import 'package:hkcoin/data.models/withdrawals_profit.dart';
import 'package:hkcoin/data.repositories/withdrawals_repository.dart';

class WithdrawalProfitController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final withdrawFeeHintController = TextEditingController();
  final exchangeHKCController = TextEditingController();
  final walletIdController = TextEditingController();
  final customerIdController = TextEditingController();
  final walletTokenAddresController = TextEditingController();
  final amountController = TextEditingController();
  final exchangePriceController = TextEditingController();
  final exchangePriceHiddenController = TextEditingController();
  final exchangeHKCHiddenController = TextEditingController();
  final amountSwapController = TextEditingController();
  final walletController = TextEditingController();
  final commentController = TextEditingController();
  RxBool showPriceWrap = true.obs;
  String? availableProfit;
  bool isSubmitting = false;
  String? errorMessage;
  RxBool isLoading = false.obs;
  WithDrawalsProfit? withDrawalsProfit;
  List<AviableWithDrawalSwaps> aviableWithDrawalSwaps = [];
  AviableWithDrawalSwaps? selectedWithDrawalSwap;
  bool hiddenExchangePrice = false;
  //List<Country> listCountry = [];
  RxBool isLoadingSubmit = false.obs;
  @override
  void onInit() {
    getWithDrawalsProfit();
    super.onInit();
  }

  void getWithDrawalsProfit() async {
    handleEither(await WithDrawalsRepository().getWithDrawalsProfit(), (r) {
      withDrawalsProfit = r;
      withdrawFeeHintController.text = r.withdrawFeeHint!;
      exchangeHKCController.text = "${r.exchangeHKC}";
      walletIdController.text = "${r.walletId}";
      customerIdController.text = "${r.customerId}";
      walletTokenAddresController.text = r.walletTokenAddres;
      amountController.text = "${r.amount}";
      aviableWithDrawalSwaps = r.aviableWithDrawalSwaps!;
      exchangeHKCHiddenController.text = "${r.exchangeHKC}";
      walletController.text = r.walletTokenAddres;
    });
    update(["withdrawal-profit-page"]);
  }

  void submitWithdrawal() async {
    isLoadingSubmit.value = true;
    if (formKey.currentState!.validate()) {
      if (selectedWithDrawalSwap == null || selectedWithDrawalSwap!.id == 0) {
        Toast.showErrorToast(
          "Account.WithDrawalRequest.WithDrawalSwap.Required",
        );
        return;
      }
      var amountToUSD =
          amountController.text.trim().stringToDouble() *
          exchangeHKCController.text.trim().toDouble();
      await handleEitherReturn(
        await WithDrawalsRepository().submitProfit(
          WithDrawalsProfit(
            walletTokenAddres: walletController.text.trim(),
            exchangeHKC: double.tryParse(exchangeHKCController.text.trim()),
            withdrawFee: withdrawFeeHintController.text.trim().stringToDouble(),
            amount: amountController.text.trim().stringToDouble(),
            amountSwap: amountSwapController.text.trim().stringToDouble(),
            amountToUSDT: amountToUSD,
            withDrawalSwapId: selectedWithDrawalSwap!.id,
            customerComments: commentController.text.trim(),
            tokenExchangePrice:
                exchangePriceHiddenController.text.trim().toDouble(),
          ),
        ),
        (r) async {
          Get.back();
        },
      );
    }
    isLoadingSubmit.value = false;
  }

  void onSwapChanged(AviableWithDrawalSwaps? newSwap) async {
    selectedWithDrawalSwap = newSwap;
    if (newSwap != null) {
      isLoading.value = true;
      update(['withdrawal-profit-page']);
      try {
        handleEither(
          await WithDrawalsRepository().getExchangePrice(newSwap.id),
          (r) {
            if (r.price > 0) {
              exchangePriceController.text = "${r.priceString}";
              exchangePriceHiddenController.text = "${r.price}";
              hiddenExchangePrice = true;
            } else {
              exchangePriceController.clear();
              exchangePriceHiddenController.clear();
              hiddenExchangePrice = false;
            }
            if (r.walletTokenAddres?.isNotEmpty ?? false) {
              walletController.text = "${r.walletTokenAddres}";
            } else {
              walletController.clear();
            }

            updateAmountSwap();
          },
        );
      } catch (e) {
        exchangePriceController.clear();
        exchangePriceHiddenController.clear();
        amountSwapController.clear();
      }
      isLoading.value = false;
    } else {
      exchangePriceController.clear();
      exchangePriceHiddenController.clear();
    }
    update(['withdrawal-profit-page']);
  }
/*
USDT BEP20: 10
HKC BEP20: 20
HTX TRC20: 30
BNB BEP20: 40
*/
  void updateAmountSwap() {
    final amountStr = amountController.text;
    final exchangePriceStr = exchangeHKCHiddenController.text;
    showPriceWrap.value=true;
    // Chuyển đổi sang double
    final amount = double.tryParse(amountStr);
    final exchangeHKCPrice = double.tryParse(exchangePriceStr);
    var selectedWithDrawal = selectedWithDrawalSwap;
    if (selectedWithDrawal != null && selectedWithDrawal.id == 10) {
      if (amount != null && exchangeHKCPrice != null && exchangeHKCPrice != 0) {
        final result = amount * exchangeHKCPrice;
        amountSwapController.text = result.toStringAsFixed(
          2,
        ); // Làm tròn 2 chữ số
      } else {
        amountSwapController.clear(); // Xóa nếu không hợp lệ
      }
    } else if (selectedWithDrawal != null && selectedWithDrawal.id != 20) {
      var priceexchangebnbHtx = double.tryParse(
        exchangePriceHiddenController.text,
      );
      if (amount != null &&
          exchangeHKCPrice != null &&
          exchangeHKCPrice != 0 &&
          priceexchangebnbHtx != null &&
          priceexchangebnbHtx > 0) {
        final result = (amount * exchangeHKCPrice) / priceexchangebnbHtx;
        amountSwapController.text = result.toStringAsFixed(
          9,
        ); // Làm tròn 2 chữ số
      } else {
        amountSwapController.clear(); // Xóa nếu không hợp lệ
      }
    } else {
      amountSwapController.clear();    
      showPriceWrap.value=false;  
    }
  }
}
