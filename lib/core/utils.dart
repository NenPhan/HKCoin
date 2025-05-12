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
Future<T?> xPopUpDialog<T>(
  BuildContext context, {
  Widget? child,
  bool useRootNavigator = false,
  bool barrierDismissible = true,
  bool isCenter = true,
  Color? barrierColor,
  String? title,
  String? description,
  EdgeInsets? padding,
  double? width,
  double? height,
  bool showCloseButton = true,
  Color? backgroundColor,
  BorderRadius? borderRadius,
  bool centerTitle = true,
  bool centerDescription = true,
  List<Widget>? footerButtons, // Thêm footer buttons
  MainAxisAlignment footerButtonsAlignment = MainAxisAlignment.end, // Căn chỉnh footer buttons
  EdgeInsets footerButtonsPadding = const EdgeInsets.only(top: 16), // Padding cho footer buttons
}) async {
  final size = MediaQuery.of(context).size;
  final theme = Theme.of(context);

  return await showGeneralDialog<T>(
    useRootNavigator: useRootNavigator,
    barrierColor: barrierColor ?? Colors.black.withOpacity(0.7),
    transitionBuilder: (context, a1, a2, widget) {
      final curvedAnimation = CurvedAnimation(
        parent: a1,
        curve: Curves.easeOutCubic,
      );

      return Transform.scale(
        scale: curvedAnimation.value,
        child: Opacity(
          opacity: curvedAnimation.value,
          child: Dialog(
            backgroundColor: backgroundColor ?? theme.dialogBackgroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: borderRadius ?? BorderRadius.circular(16.0),
            ),
            insetPadding: EdgeInsets.zero,
            child: Container(
              width: width ?? size.width * 0.85,
              height: height,
              padding: padding ?? const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header section
                  if (title != null || showCloseButton) ...[
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        if (title != null)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 32),
                            child: Text(
                              title,
                              textAlign: centerTitle ? TextAlign.center : TextAlign.start,
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        if (showCloseButton)
                          Align(
                            alignment: Alignment.centerRight,
                            child: IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () => Navigator.of(context).pop(),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                  ],

                  // Description
                  if (description != null) ...[
                    Text(
                      description,
                      textAlign: centerDescription ? TextAlign.center : TextAlign.start,
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Main content
                  if (child != null)
                    isCenter
                        ? Center(child: child)
                        : Flexible(child: child),

                  // Footer buttons
                  if (footerButtons != null && footerButtons.isNotEmpty) ...[
                    Padding(
                      padding: footerButtonsPadding,
                      child: Row(
                        mainAxisAlignment: footerButtonsAlignment,
                        children: footerButtons
                            .map((button) => Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 4),
                                  child: button,
                                ))
                            .toList(),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      );
    },
    transitionDuration: const Duration(milliseconds: 250),
    barrierDismissible: barrierDismissible,
    barrierLabel: '',
    context: context,
    pageBuilder: (context, animation1, animation2) => const SizedBox(),
  );
}
String? requiredValidator(value, String alert) =>
    value != "" && value != null ? null : tr(alert);

String dateFormat(DateTime? date, {String format = 'dd/MM/yyyy HH:mm'}) {
  if (date == null) return "";
  return DateFormat(format).format(date);
}
