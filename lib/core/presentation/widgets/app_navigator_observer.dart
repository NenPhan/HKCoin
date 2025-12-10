import 'package:flutter/material.dart';

class AppNavigatorObserver extends NavigatorObserver {
  static final AppNavigatorObserver _instance = AppNavigatorObserver._();

  factory AppNavigatorObserver() {
    return _instance;
  }
  AppNavigatorObserver._();

  @override
  void didPush(Route route, Route? previousRoute) {
    // log(
    //   "Navigator didPush: ${previousRoute?.settings.name} -> ${route.settings.name}",
    // );
    super.didPush(route, previousRoute);
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    // log(
    //   "Navigator didPop: ${route.settings.name} -> ${previousRoute?.settings.name}",
    // );
    super.didPop(route, previousRoute);
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    // log(
    //   "Navigator didReplace: ${oldRoute?.settings.name} -> ${newRoute?.settings.name}",
    // );
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
  }

  @override
  void didRemove(Route route, Route? previousRoute) {
    // log(
    //   "Navigator didRemove: ${previousRoute?.settings.name} -> ${route.settings.name}",
    // );
    super.didRemove(route, previousRoute);
  }
}
