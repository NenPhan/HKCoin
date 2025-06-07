import 'dart:convert';
import 'dart:developer';

import 'package:hkcoin/data.models/customer_info.dart';
import 'package:hkcoin/data.models/network.dart';
import 'package:shared_preferences/shared_preferences.dart';

class KeyStorage {
  final tokenKey = "/token_key";
  final customerKey = "/customer_key";
  final notiKey = "/noti_key";
  final networkKey = "/network_key";
}

class Storage {
  static Storage? _instance;
  static bool hadInited = false;
  Storage._(this.preferences);
  SharedPreferences? preferences;

  final KeyStorage _key = KeyStorage();

  factory Storage() {
    if (_instance == null) {
      log('Storage need to call init!!');
    }
    return _instance!;
  }

  static Future init({SharedPreferences? pres}) async {
    hadInited = true;
    if (_instance != null) {
      throw 'Storage had inited';
    }
    _instance = Storage._(pres ?? await SharedPreferences.getInstance());
    return _instance;
  }

  getInstance() {
    return _instance;
  }

  Future<void> dispose() async {
    await preferences?.remove(_key.tokenKey);
    await preferences?.remove(_key.customerKey);
  }
}

extension TokenStorage on Storage {
  Future<void> saveToken(String value) async {
    await preferences!.setString(_key.tokenKey, value);
  }

  Future<void> deleteToken() async {
    await preferences!.remove(_key.tokenKey);
  }

  String? get getToken => preferences!.getString(_key.tokenKey);
}

extension CustomerStorage on Storage {
  Future<void> saveCustomer(CustomerInfo value) async {
    await preferences!.setString(_key.customerKey, jsonEncode(value.toJson()));
  }

  Future<CustomerInfo?> getCustomer() async {
    var savedString = preferences!.getString(_key.customerKey);
    if (savedString == null) return null;
    return CustomerInfo.fromJson(jsonDecode(savedString));
  }

  Future deleteCustomer() async {
    await preferences!.remove(_key.customerKey);
  }
}

extension NotiStorage on Storage {
  Future<void> saveNotiPayload(String payload) async {
    await preferences!.setString(_key.notiKey, payload);
  }

  Future<String?> getNotiPayload() async {
    var savedString = preferences!.getString(_key.notiKey);
    return savedString;
  }

  Future deleteNotiPayload() async {
    await preferences!.remove(_key.notiKey);
  }
}
extension NetworkStorage on Storage {
  Future<void> saveNetWork(Network network) async {    
    await preferences!.setString(_key.networkKey, jsonEncode(network.toJson()));
  }

  Future<Network?> getNetWork() async {
    var savedString = preferences!.getString(_key.networkKey);     
    if (savedString == null) return null;
    return Network.fromJson(jsonDecode(savedString));    
  }

  Future deleteNetWork() async {
    await preferences!.remove(_key.networkKey);
  }
}
