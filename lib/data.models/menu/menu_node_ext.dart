import 'package:hkcoin/data.models/menu/menu_action.dart';
import 'package:hkcoin/data.models/menu/menu_node.dart';
import 'package:hkcoin/data.models/services/home_service.dart';
import 'package:hkcoin/data.models/slide.dart';

extension MenuNodeExt on MenuNode {
  bool get hasChildren => children.isNotEmpty;

  List<MenuNode> get visibleChildren =>
      children.where((e) => e.visible && e.enabled).toList();

  bool get isClickable =>
      (routeName != null && routeName!.isNotEmpty) ||
      (url != null && url!.isNotEmpty);

  /// Flatten toàn bộ cây menu
  List<MenuNode> flatten() {
    final result = <MenuNode>[this];
    for (final child in children) {
      result.addAll(child.flatten());
    }
    return result;
  }

  /// Tìm menu theo route
  MenuNode? findByRoute(String route) {
    if (routeName == route) return this;
    for (final child in children) {
      final found = child.findByRoute(route);
      if (found != null) return found;
    }
    return null;
  }

  MenuAction? parseAction() {
    // RouteName ưu tiên cao nhất
    if (routeName != null && routeName!.isNotEmpty) {
      return MenuAction(module: routeName!);
    }

    // Url: departments:1 | ncategory:23 | http...
    if (url != null && url!.isNotEmpty) {
      if (url!.startsWith("http")) {
        return MenuAction(module: "external", url: url);
      }

      final parts = url!.split(":");
      return MenuAction(
        module: parts[0],
        id: parts.length > 1 ? parts[1] : null,
      );
    }

    return null;
  }

  MenuAction parseMenuAction({String? routeName, String? url}) {
    // RouteName
    if (routeName != null && routeName.isNotEmpty) {
      return MenuAction(module: routeName);
    }

    // Url: departments:1 | ncategory:23 | http...
    if (url != null && url.isNotEmpty) {
      if (url.startsWith("http")) {
        return MenuAction(module: "external", url: url);
      }

      final parts = url.split(":");
      return MenuAction(
        module: parts[0],
        id: parts.length > 1 ? parts[1] : null,
      );
    }

    throw Exception("Invalid menu action");
  }

  HomeService toHomeService({required int order}) {
    return HomeService(
      id: id,
      title: text,
      icon: icon ?? "",
      action: parseAction(),
      enabled: enabled && visible,
      order: order,
    );
  }
}

extension SlideActionMapper on Slide {
  MenuAction? toMenuAction() {
    // 1️⃣ Có Route (ưu tiên cao nhất)
    if (route != null && route!.routeName != null) {
      return MenuAction(
        module: route!.routeName!,
        id: route!.routeId?.toString(),
      );
    }

    // 2️⃣ Có SlideUrl
    if (slideUrl.isNotEmpty) {
      return MenuAction(module: "external", url: slideUrl);
    }

    return null;
  }
}
