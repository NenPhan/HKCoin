// Example controller methods needed:
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:hkcoin/core/request_handler.dart';
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
  final amountSwapController =TextEditingController();
  final walletController =TextEditingController();
  String? availableProfit;
  bool isSubmitting = false;
  String? errorMessage;
  RxBool isLoading = false.obs;
  WithDrawalsProfit? withDrawalsProfit;
  List<AviableWithDrawalSwaps> aviableWithDrawalSwaps = [];
  AviableWithDrawalSwaps? selectedWithDrawalSwap;
  bool hiddenExchangePrice = false;
  //List<Country> listCountry = [];
  @override
  void onInit() {
    getWithDrawalsProfit();
    super.onInit();
  }
  void getWithDrawalsProfit() async {
    handleEither(await WithDrawalsRepository().getWithDrawalsProfit(), (r) {
      withDrawalsProfit=r;
      withdrawFeeHintController.text = r.withdrawFeeHint;
      exchangeHKCController.text = "${r.exchangeHKC}";
      walletIdController.text = "${r.walletId}";
      customerIdController.text = "${r.customerId}";
      walletTokenAddresController.text = r.walletTokenAddres;
      amountController.text= "${r.amount}";
      aviableWithDrawalSwaps = r.aviableWithDrawalSwaps;
      exchangeHKCHiddenController.text="${r.exchangeHKC}";
      walletController.text=r.walletTokenAddres;
    });    
    update(["withdrawals_profit-page"]);
  }

  Future<void> submitWithdrawal({
    required String amount,
    required String walletAddress,
  }) async {
    isSubmitting = true;
    errorMessage = null;
   // update(['profit-withdrawal']);
    
    try {
      // API call to submit withdrawal
      // Update recentWithdrawals list
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isSubmitting = false;
      //update(['profit-withdrawal']);
    }
  }
  void onSwapChanged(AviableWithDrawalSwaps? newSwap) async {
    selectedWithDrawalSwap = newSwap;
    if (newSwap != null) {
      isLoading.value = true;
      update(['withdrawal-profit-page']);
      try {
         handleEither(await WithDrawalsRepository().getExchangePrice(newSwap.id), (r) {                    
          if(r.price>0){          
            exchangePriceController.text = "${r.priceString}";
            exchangePriceHiddenController.text= "${r.price}";  
            hiddenExchangePrice=true;
          }    
          else{
            exchangePriceController.clear();
            exchangePriceHiddenController.clear(); 
          }      
          if(r.walletTokenAddres?.isNotEmpty??false){
            walletController.text= "${r.walletTokenAddres}";
          }else{
            walletController.clear();
          }
          
          updateAmountSwap();
        });       
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
  void updateAmountSwap() {
    final amountStr = amountController.text;
    final exchangePriceStr = exchangeHKCHiddenController.text;

    // Chuyển đổi sang double
    final amount = double.tryParse(amountStr);
    final exchangeHKCPrice = double.tryParse(exchangePriceStr);
    var selectedWithDrawal = selectedWithDrawalSwap;
    if(selectedWithDrawal !=null && selectedWithDrawal.id==10){
      if (amount != null && exchangeHKCPrice != null && exchangeHKCPrice != 0) {
        final result = amount * exchangeHKCPrice;
        amountSwapController.text = result.toStringAsFixed(2); // Làm tròn 2 chữ số
      } else {
        amountSwapController.clear(); // Xóa nếu không hợp lệ
      }
    }else if(selectedWithDrawal !=null && selectedWithDrawal.id != 20){
      var priceexchangebnbHtx = double.tryParse(exchangePriceHiddenController.text);    
      if (amount != null && exchangeHKCPrice != null && exchangeHKCPrice != 0 && priceexchangebnbHtx != null && priceexchangebnbHtx>0) {
        final result = (amount*exchangeHKCPrice)/priceexchangebnbHtx;
        amountSwapController.text = result.toStringAsFixed(9); // Làm tròn 2 chữ số
      } else {
        amountSwapController.clear(); // Xóa nếu không hợp lệ
      }
    }else{
      amountSwapController.clear();
    }
  }
}