import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FormattedNumber extends StatelessWidget {
  final double? value;
  final int decimalDigits;
  final TextStyle? style;
  final String? prefix;
  final String? suffix;

  const FormattedNumber({
    Key? key,
    this.value,
    this.decimalDigits = 2,
    this.style,
    this.prefix,
    this.suffix,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;

    // Xử lý khi value là null
    if (value == null) {
      return Text(
        '${prefix ?? ''}--${suffix ?? ''}',
        style: style,
      );
    }

    final formattedValue = _formatNumber(value!, locale, decimalDigits);
    return Text(
      '${prefix ?? ''}$formattedValue${suffix ?? ''}',
      style: style,
    );
  }

  String _formatNumber(double number, String locale, int decimalDigits) {
    final format = NumberFormat.decimalPattern(locale);
    format.minimumFractionDigits = decimalDigits;
    format.maximumFractionDigits = decimalDigits;
    return format.format(number);
  }
}