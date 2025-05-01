import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

oCcy({String? format}) => NumberFormat(format ?? "#,##0.000", "en_US");

Future showPopUpDialog(
  BuildContext context,
  Widget child, {
  bool? useRootNavigator = false,
  bool barrierDismissible = true,
  bool isCenter = true,
  Color? barrierColor,
}) async {
  var size = MediaQuery.of(context).size;
  return await showGeneralDialog(
    useRootNavigator: useRootNavigator!,
    barrierColor: barrierColor ?? Colors.black.withValues(alpha: 0.9),
    transitionBuilder: (context, a1, a2, widget) {
      return Transform.scale(
        scale: a1.value < size.width * 0.95 ? a1.value : size.width * 0.95,
        child: Opacity(
          opacity: a1.value,
          child:
              isCenter
                  ? Center(child: child)
                  : SafeArea(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [child],
                    ),
                  ),
        ),
      );
    },
    transitionDuration: const Duration(milliseconds: 200),
    barrierDismissible: barrierDismissible,
    barrierLabel: '',
    context: context,
    pageBuilder: (context, animation1, animation2) {
      return const SizedBox();
    },
  );
}

String? requiredValidator(value, String alert) =>
    value != "" && value != null ? null : tr(alert);
