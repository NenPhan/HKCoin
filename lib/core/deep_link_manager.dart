// ignore_for_file: empty_catches

import 'dart:async';
import 'dart:developer';

import 'package:app_links/app_links.dart';
import 'package:get/get.dart';
import 'package:hkcoin/presentation.pages/checkout_complete_page.dart';
import 'package:hkcoin/presentation.pages/register_page.dart';

class DeeplinkManager {
  static DeeplinkManager? _instance;
  DeeplinkManager._();
  static late AppLinks _appLinks;
  factory DeeplinkManager() {
    if (_instance == null) {
      initDeepLinks();
    }
    return _instance!;
  }

  static Future<void> initDeepLinks() async {
    _instance = DeeplinkManager._();
    _appLinks = AppLinks();

    _appLinks.uriLinkStream.listen((uri) {
      checkDeeplink(uri);
    });
  }

  static Future<Uri?> checkInitLink() async {
    // Check initial link if app was in cold state (terminated)
    final appLink = await _appLinks.getInitialLink();
    if (appLink != null) {
      checkDeeplink(appLink);
    }
    return appLink;
  }

  static void checkDeeplink(Uri uri) {
    String? destinationPath;
    var query = '';

    switch (uri.scheme) {
      //https://api.hakacoin.net/vi/register?refcode=123456
      case "https":
        if (uri.path.contains("register")) {
          destinationPath = "register";
        }else if(uri.path.contains("ipay")){
          destinationPath = "ipay";
        }
        query = uri.query;
        break;

      //vn.app.hkc://register?refcode=123456
      case "vn.app.hkc":
        destinationPath = uri.host + uri.path;
        query = uri.query;
      default:
        break;
    }

    if (destinationPath != null) {
      log(destinationPath);
      try {
        handleLink(destinationPath, query);
      } catch (e) {}
    }
  }

  static void handleLink(String destinationPath, String query) {
    switch (destinationPath) {
      case "register":
        Get.toNamed(RegisterPage.route, arguments: toQueryMap(query));
        break;
      case "ipay":      
       var queryMap = toQueryMap(query);       
        final orderguid = queryMap['orderguid'] ?? ''; 
        Get.toNamed(CheckoutCompletePage.route, arguments: orderguid);
        break;
      default:
    }
  }

  static Map<String, dynamic> toQueryMap(String query) {
    Map<String, dynamic> map = {};
    List<String> items = query.split("&");
    for (var i = 0; i < items.length; i++) {
      String key = items[i].split("=").first;
      String value = items[i].split("=").last;
      map.addEntries({key: value}.entries);
    }
    return map;
  }
}
