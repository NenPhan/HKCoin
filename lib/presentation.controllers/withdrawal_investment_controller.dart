import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hkcoin/core/extensions/extensions.dart';
import 'package:hkcoin/core/request_handler.dart';
import 'package:hkcoin/core/toast.dart';
import 'package:hkcoin/data.models/withdrawals_investment.dart';
import 'package:hkcoin/data.repositories/withdrawals_repository.dart';

class WithdrawalInvestmentController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final amountSwapToHKCController = TextEditingController();
  final exchangeHKCController = TextEditingController();
  final withdrawFeeHintController = TextEditingController();
  final withdrawFeeController = TextEditingController();
  final withdrawFeeStrController = TextEditingController();
  final walletTokenAddresController = TextEditingController();
  final commentController = TextEditingController();

  String? availableProfit;
  bool isSubmitting = false;
  String? errorMessage;
  RxBool isLoading = false.obs;
  WithDrawalsInvestment? withDrawalsInvestment;
  List<AviablePackages> aviablePackages = [];
  AviablePackages? selectedPackage;
  bool hiddenExchangePrice = false;  
  @override
  void onInit() {
    getWithDrawalsInvestment();
    super.onInit();
  }

  void getWithDrawalsInvestment() async {
    handleEither(await WithDrawalsRepository().getWithDrawalsInvestment(), (r) {
      withDrawalsInvestment = r;
      withdrawFeeHintController.text = r.withdrawFeeHint!;
      exchangeHKCController.text = "${r.exchangeHKC}";
      withdrawFeeController.text = "${r.withdrawFee}";
      withdrawFeeStrController.text = "${r.withdrawFeeStr}";
      walletTokenAddresController.text = r.walletTokenAddres;  
      aviablePackages = r.aviablePackages!;    
    });
    update(["withdrawal-investment-page"]);
  }

  void submitWithdrawal() async {
    if (formKey.currentState!.validate()) {
      if (selectedPackage == null || selectedPackage!.id == 0) {
        Toast.showErrorToast(
          "Account.WithDrawalRequest.WithDrawalSwap.Required",
        );
        return;
      }
      var amountSwapToHKC = amountSwapToHKCController.text.trim().toDouble();          
      handleEither(
        await WithDrawalsRepository().submitInvestment(
          WithDrawalsInvestment(
            walletTokenAddres: walletTokenAddresController.text.trim(),
            exchangeHKC: exchangeHKCController.text.trim().toDouble(),
            withdrawFee: withdrawFeeController.text.trim().toDouble(),
            packageId: selectedPackage!.id,
            amountSwapToHKC: amountSwapToHKC,         
            customerComments: commentController.text.trim()            
          ),
        ),
        (r) {
          Get.back();
        },
      );
    }
  }

  void onSwapChanged(AviablePackages? newPachage) async {
    selectedPackage = newPachage;
    if (newPachage != null) {
      isLoading.value = true;
      update(['withdrawal-investment-page']);
      try {
        handleEither(
          await WithDrawalsRepository().getExchangePackage(newPachage.id),
          (r) {
            if (r > 0) {              
              amountSwapToHKCController.text = "${r/exchangeHKCController.text.trim().toDouble()}";              
              hiddenExchangePrice = true;
            } else {
              amountSwapToHKCController.clear();              
            }            
          },
        );
      } catch (e) {
        amountSwapToHKCController.clear();        
      }
      isLoading.value = false;
    } else {
      amountSwapToHKCController.clear();      
    }
    update(['withdrawal-investment-page']);
  }  
}
