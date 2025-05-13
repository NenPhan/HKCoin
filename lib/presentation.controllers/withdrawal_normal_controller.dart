// withdrawal_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class WithdrawalNormalController extends GetxController {
  bool isLoading = false;
  String? errorMessage;
  String availableBalance = '0';
  List<WithdrawalItem> recentWithdrawals = [];
  bool canWithdraw = false;
  TextEditingController amountController = TextEditingController();
  TextEditingController bankAccountController = TextEditingController();

  get withdrawalItems => null;

  Future<void> loadData() async {
    // Similar loading pattern
  }

  Future<void> submitWithdrawal() async {
    // Form submission logic
  }
}

class WithdrawalItem {
  get status => null;

  get amount => null;

  get date => null;

  get bankAccount => null;
}