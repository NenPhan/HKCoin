import 'package:flutter/material.dart';
import 'package:hkcoin/core/config/app_theme.dart';
import 'package:easy_localization/easy_localization.dart';

// Enum for alert types
enum AlertType {
  error,
  success,
  info,
  warning,
}

// Extension to define default properties for each alert type
extension AlertTypeExtension on AlertType {
  IconData get icon {
    switch (this) {
      case AlertType.error:
        return Icons.error_outline_rounded;
      case AlertType.success:
        return Icons.check_circle_outline_rounded;
      case AlertType.info:
        return Icons.info_outline_rounded;
      case AlertType.warning:
        return Icons.warning_amber_rounded;
    }
  }

  Color get iconBackgroundColor {
    switch (this) {
      case AlertType.error:
        return Colors.red[700]!;
      case AlertType.success:
        return Colors.green[700]!;
      case AlertType.info:
        return Colors.blue[700]!;
      case AlertType.warning:
        return Colors.orange[700]!;
    }
  }

  Color get contentBackgroundColor {
    switch (this) {
      case AlertType.error:
        return Colors.red[50]!;
      case AlertType.success:
        return Colors.green[50]!;
      case AlertType.info:
        return Colors.blue[50]!;
      case AlertType.warning:
        return Colors.orange[50]!;
    }
  }

  Color get textColor {
    switch (this) {
      case AlertType.error:
        return Colors.red[900]!;
      case AlertType.success:
        return Colors.green[900]!;
      case AlertType.info:
        return Colors.blue[900]!;
      case AlertType.warning:
        return Colors.orange[900]!;
    }
  }
}

// Reusable AlertWidget
class AlertWidget extends StatelessWidget {
  final AlertType type;
  final String message;
  final IconData? customIcon;
  final Color? customIconBackgroundColor;
  final Color? customContentBackgroundColor;
  final Color? customTextColor;

  const AlertWidget({
    super.key,
    required this.type,
    required this.message,
    this.customIcon,
    this.customIconBackgroundColor,
    this.customContentBackgroundColor,
    this.customTextColor,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Container(
              width: scrSize(context).width * 0.15,
              color: customIconBackgroundColor ?? type.iconBackgroundColor,
              child: Center(
                child: Icon(
                  customIcon ?? type.icon,
                  color: Colors.white,
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(scrSize(context).width * 0.03),
                color: customContentBackgroundColor ?? type.contentBackgroundColor,
                child: Text(
                  tr(message), // Use translation
                  style: textTheme(context).bodyMedium?.copyWith(
                        color: customTextColor ?? type.textColor,
                      ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}