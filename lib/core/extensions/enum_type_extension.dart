import 'package:flutter/widgets.dart';
import 'package:hkcoin/core/enums.dart';
import 'package:hkcoin/localization/localization_context_extension.dart';

extension GenderTypeX on GenderType {
  String display(BuildContext context) {
    switch (this) {
      case GenderType.nam:
        return context.tr("Enums.Gender.Nam"); // "Nam"
      case GenderType.nu:
        return context.tr("Enums.Gender.Nu"); // "Nữ"
      case GenderType.khac:
        return context.tr("Enums.Gender.Khac"); // "Khác"
      default:
        return context.tr("Enums.Gender.Unknown"); // "Không xác định"
    }
  }

  static GenderType mapGenderFromInt(int? value) {
    switch (value) {
      case 1:
        return GenderType.nam;
      case 0:
        return GenderType.nu;
      case 2:
        return GenderType.khac;
      default:
        return GenderType.defaultValue;
    }
  }

  int toApiValue() {
    switch (this) {
      case GenderType.nam:
        return 1;
      case GenderType.nu:
        return 0;
      case GenderType.khac:
        return 2;
      default:
        return -1;
    }
  }
}
