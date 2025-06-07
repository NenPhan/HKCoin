import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:hkcoin/core/config/app_config.dart';
import 'package:hkcoin/core/constants/endpoint.dart';
import 'package:hkcoin/core/dio_client.dart';
import 'package:hkcoin/core/enums.dart';
import 'package:hkcoin/core/request_handler.dart';
import 'package:hkcoin/data.models/blockchange_wallet_info.dart';
import 'package:hkcoin/data.models/customer_wallet_token.dart';
import 'package:hkcoin/data.models/network.dart';
import 'package:hkcoin/data.models/wallet.dart';
import 'package:hkcoin/presentation.controllers/locale_controller.dart';

class WalletDatasource {
  final dioClient = DioClient(dio: Dio(), appConfig: AppConfig());
  Future<List<Network>> getNetworks() async {
    return await handleRemoteRequest(() async {
      var response = await dioClient.call(
        DioParams(
          HttpMethod.GET,
          endpoint: Endpoints.getNetWork,      
           headers: {
            "Accept-Language": Get.find<LocaleController>().localeIsoCode,
          },    
        ),
      );      
      return (response["Data"] as List)
          .map((e) => Network.fromJson(e))
          .toList();
    });
  }
  Future<BlockchangeWallet> createWallet(BlockchangeWallet wallet) async {
    return await handleRemoteRequest(() async {      
      var response = await dioClient.call(
        DioParams(
          HttpMethod.POST,
          endpoint: Endpoints.addWallet,
           headers: {
            "Accept-Language": Get.find<LocaleController>().localeIsoCode,
          },
          needAccessToken: true,
          body: wallet.toJson(),
        ),
        contentType: "application/json",
      );
      return BlockchangeWallet.fromJson(response["Data"]);
    });    
  }
  Future<CustomerWalletToken> createCustomerToken(CustomerWalletToken wallet) async {
    return await handleRemoteRequest(() async {      
      var response = await dioClient.call(
        DioParams(
          HttpMethod.POST,
          endpoint: Endpoints.addCustomerWalletToken,
           headers: {
            "Accept-Language": Get.find<LocaleController>().localeIsoCode,
          },
          needAccessToken: true,
          body: wallet.toJson(),
        ),
        contentType: "application/json",
      );
      return CustomerWalletToken.fromJson(response["Data"]);
    });    
  }
  Future<bool> selectedWallet(BlockchangeWallet wallet) async {
    return await handleRemoteRequest(() async {      
      var response = await dioClient.call(
        DioParams(
          HttpMethod.POST,
          endpoint: Endpoints.selectedWallet,
           headers: {
            "Accept-Language": Get.find<LocaleController>().localeIsoCode,
          },
          needAccessToken: true,
          body: wallet.toJson(),
        ),
        contentType: "application/json",
      );    
      return true;  
    });    
  }
  Future<BlockchangeWalletInfo?> getWalletInfo() async {
    return await handleRemoteRequest(() async {      
      var response = await dioClient.call(
        DioParams(
          HttpMethod.GET,
          endpoint: Endpoints.getBlockchainWalletInfo,
           headers: {
            "Accept-Language": Get.find<LocaleController>().localeIsoCode,
          },
          needAccessToken: true,          
        ),
        contentType: "application/json",
      );            
      if(response !=null && response["Data"] !=null) {
        return BlockchangeWalletInfo.fromJson(response["Data"]);
      } else{
        return null;
      }        
    });    
  }
  Future<List<BlockchangeWallet>> getWallets() async {
    return await handleRemoteRequest(() async {      
      var response = await dioClient.call(
        DioParams(
          HttpMethod.GET,
          endpoint: Endpoints.getBlockchainWallet,
           headers: {
            "Accept-Language": Get.find<LocaleController>().localeIsoCode,
          },
          needAccessToken: true,          
        ),
        contentType: "application/json",
      );
       return (response["Data"] as List)
          .map((e) => BlockchangeWallet.fromJson(e))
          .toList();     
    });    
  }
}