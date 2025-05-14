// Example controller methods needed:
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:hkcoin/core/request_handler.dart';
import 'package:hkcoin/data.models/withdrawals_profit.dart';
import 'package:hkcoin/data.repositories/withdrawals_repository.dart';

class WithdrawalProfitController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final TextEditingController withdrawFeeHintController = TextEditingController();
  final TextEditingController exchangeHKCController = TextEditingController();
  final TextEditingController walletIdController = TextEditingController();
  final TextEditingController customerIdController = TextEditingController();
  final TextEditingController walletTokenAddresController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  String? availableProfit;
  bool isSubmitting = false;
  String? errorMessage;
  WithDrawalsProfit? withDrawalsProfit;
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
}