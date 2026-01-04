import 'package:hkcoin/data.models/menu/menu_action.dart';

class HomeService {
  final String id;
  final String title;
  final String icon; // key icon
  final MenuAction? action; // route
  final bool enabled;
  final int order;

  HomeService({
    required this.id,
    required this.title,
    required this.icon,
    required this.action,
    required this.enabled,
    required this.order,
  });
}
