Map<String, dynamic> normalizeSettingKeys(
  Map<String, dynamic> raw,
) {
  final Map<String, dynamic> normalized = {};

  raw.forEach((key, value) {
    final normalizedKey = key
        .toLowerCase()
        .split('.')        // 👈 tách theo dấu .
        .last;             // 👈 lấy phần sau cùng

    normalized[normalizedKey] = value;
  });

  return normalized;
}
