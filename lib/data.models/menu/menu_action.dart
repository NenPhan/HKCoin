class MenuAction {
  final String module;     // DatLichKhamBenh, departments, ncategory...
  final String? id;        // 1, 23, 45...
  final String? url;       // external url

  MenuAction({
    required this.module,
    this.id,
    this.url,
  });

  bool get isExternal => url != null && url!.startsWith("http");
}
