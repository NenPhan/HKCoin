extension StringExtensions on String {
  double toDouble({double defaultValue = 0.0}) {
    return double.tryParse(this) ?? defaultValue;
  }

  double stringToDouble({double defaultValue = 0.0}) {
    return double.tryParse(trim()) ?? defaultValue; // Áp dụng trim()
  }
}