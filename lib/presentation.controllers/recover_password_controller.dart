import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hkcoin/data.models/recovery_password.dart';
import 'package:hkcoin/data.repositories/customer_repository.dart';

class RecoverPasswordController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final RxBool isLoadingSubmit = false.obs;
 
  Future<Map<String, dynamic>> recoveryPassword() async {
    try{
      isLoadingSubmit.value=true;
      if (!formKey.currentState!.validate()) {
        return {'success': false, 'message': "Validation Error"};
      }
      final eitherResult = await CustomerRepository().recoveryPassword(
        RecoveryPassword(email: emailController.text.trim()),
      );         
      return eitherResult.fold(
        (error) => {'success': false, 'message': error.toString()},
        (response) => {
          'success': true,
          'message': response.resultMessage,
          // Include any other response data you need
        },
      );             
    }catch(e){
      return {
        'success': false,
        'message': "Error: $e",
      };
    }finally{
      isLoadingSubmit.value=false;
      emailController.text="";
    }
    
  }
}
