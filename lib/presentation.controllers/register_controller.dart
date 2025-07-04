import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hkcoin/core/request_handler.dart';
import 'package:hkcoin/core/toast.dart';
import 'package:hkcoin/data.models/recovery_password.dart';
import 'package:hkcoin/data.models/register_form.dart';
import 'package:hkcoin/data.repositories/customer_repository.dart';

class RegisterController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final TextEditingController fNameController = TextEditingController();
  final TextEditingController lNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController referralCodeController = TextEditingController();
  final RxBool isLoadingSubmit = false.obs;
  @override
  void onInit() {
    if (Get.arguments != null) {
      referralCodeController.text = Get.arguments["refcode"] ?? "";
    }
    super.onInit();
  }

  Future<Map<String, dynamic>> register() async {
    isLoadingSubmit.value=true;
    try{
      if (!formKey.currentState!.validate()) {
        isLoadingSubmit.value=false;
        return {'success': false, 'message': "Validation Error"};
      }
      if (passwordController.text.trim() !=
          confirmPasswordController.text.trim()) {
        isLoadingSubmit.value=false;
        Toast.showErrorToast("Identity.Error.PasswordMismatch");
        return {'success': false, 'message': "Validation Error"};
      }
      final eitherResult = await CustomerRepository().register(
        RegisterForm(
          firstName: fNameController.text.trim(),
          lastName: lNameController.text.trim(),
          email: emailController.text.trim(),
          phone: phoneController.text.trim(),
          password: passwordController.text.trim(),
          referralCode: referralCodeController.text.trim(),
        ),
      );         
      return eitherResult.fold(
        (error) => {'success': false, 'message': error.toString()},
        (response) => {
          'success': true,
          'message': tr("Account.Register.Result.Standard").replaceAll('{0}',emailController.text).replaceAll('{1}', "https://hakacoin.net/vi/customer/info/"),          
        },
      );                
    }catch(e){
      Toast.showErrorToast("Identity.Error.PasswordMismatch");
      return {
        'success': false,
        'message': "Error",
      };
    }finally{
      isLoadingSubmit.value=false;
    }    
  }  
}
