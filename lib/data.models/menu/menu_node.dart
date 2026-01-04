class MenuNode {
  final String id;
  final int menuItemId;
  final int menuId;

  final String text;
  final String? subTitle;

  final String? icon;
  final String? imageUrl;

  final String? url;
  final String? routeName;

  final bool visible;
  final bool enabled;

  final List<MenuNode> children;

  MenuNode({
    required this.id,
    required this.menuItemId,
    required this.menuId,
    required this.text,
    this.subTitle,
    this.icon,
    this.imageUrl,
    this.url,
    this.routeName,
    required this.visible,
    required this.enabled,
    required this.children,
  });
  factory MenuNode.fromJson(Map<String, dynamic> json) => MenuNode(
     id: json['Id'],
      menuItemId: json['MenuItemId'] ?? 0,
      menuId: json['MenuId'] ?? 0,
      text: json['Text'] ?? '',
      subTitle: json['SubTitle'],
      icon: json['Icon'],
      imageUrl: json['ImageUrl'],
      url: json['Url'],
      routeName: json['RouteName'],
      visible: json['Visible'] ?? true,
      enabled: json['Enabled'] ?? true,
      children: (json['Children'] as List? ?? [])
          .map((e) => MenuNode.fromJson(e))
          .toList(),
  );  
}
