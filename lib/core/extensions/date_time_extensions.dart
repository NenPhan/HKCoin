import 'package:intl/intl.dart';

extension BirthDateExtension on String {
  DateTime? toDate() {
    try {
      return DateFormat("dd/MM/yyyy").parseStrict(this);
    } catch (_) {
      return null;
    }
  }

  bool get isValidBirthDate {
    final date = toDate();
    if (date == null) return false;
    return date.isBefore(DateTime.now());
  }

  int get age {
    final date = toDate();
    if (date == null) return 0;

    final now = DateTime.now();
    int age = now.year - date.year;
    if (now.month < date.month ||
        (now.month == date.month && now.day < date.day)) {
      age--;
    }
    return age;
  }
}

extension StringDateExtensions on String? {
  /// Parse chuỗi dạng ddMMyyyy (vd: 20051951) -> DateTime?
  DateTime? toDateFromDdMmYyyy() {
    if (this == null || this!.isEmpty) return null;

    final value = this!;
    if (value.length != 8) return null;

    try {
      final day = int.parse(value.substring(0, 2));
      final month = int.parse(value.substring(2, 4));
      final year = int.parse(value.substring(4, 8));

      return DateTime(year, month, day);
    } catch (_) {
      return null;
    }
  }

  /// Parse và format sang dd/MM/yyyy
  String? toDdMmYyyySlash() {
    final date = toDateFromDdMmYyyy();
    if (date == null) return null;

    final d = date.day.toString().padLeft(2, '0');
    final m = date.month.toString().padLeft(2, '0');
    final y = date.year.toString();

    return '$d/$m/$y';
  }
}
