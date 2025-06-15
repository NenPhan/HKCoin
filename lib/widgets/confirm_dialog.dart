import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Controller to manage loading state
class ConfirmDialogController extends GetxController {
  var isLoading = false.obs;
}

class ConfirmDialog extends StatelessWidget {
  final String title;
  final String content;
  final String okText;
  final String cancelText;
  final Color okButtonColor;
  final VoidCallback? onOkPressed;
  final VoidCallback? onCancelPressed;
  final IconData? icon; // New parameter for icon
  final Color iconBorderColor; // New parameter for icon border color
  final bool showBorder;
  final double iconSize;

  const ConfirmDialog({
    Key? key,
    required this.title,
    required this.content,
    this.okText = 'OK',
    this.cancelText = 'Cancel',
    this.okButtonColor = Colors.blue,
    this.onOkPressed,
    this.onCancelPressed,
    this.icon, // Optional icon
    this.iconBorderColor = Colors.blue, // Default border color
    this.showBorder = false,
    this.iconSize = 32.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Initialize controller for this dialog instance
    final dialogController = Get.put(
      ConfirmDialogController(),
      tag: UniqueKey().toString(),
    );

    return AlertDialog(
      title: Column(
        children: [
          if (icon != null) ...[
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border:
                    showBorder
                        ? Border.all(color: iconBorderColor, width: 3)
                        : null,
              ),
              child: Icon(
                icon,
                size: iconSize,
                color:
                    iconBorderColor, // Match icon color with border for consistency
              ),
            ),
            const SizedBox(height: 12), // Space between icon and title
          ],
          Text(
            context.tr(title),
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
      content: Text(context.tr(content), style: const TextStyle(fontSize: 16)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      actions: [
        TextButton(
          onPressed: onCancelPressed ?? () => Navigator.of(context).pop(),
          child: Text(
            context.tr(cancelText),
            style: const TextStyle(color: Colors.grey, fontSize: 16),
          ),
        ),
        Obx(
          () => ElevatedButton(
            onPressed:
                dialogController.isLoading.value
                    ? null // Disable button when loading
                    : () async {
                      dialogController.isLoading.value = true;
                      onOkPressed?.call();
                      dialogController.isLoading.value = false;
                    },
            style: ElevatedButton.styleFrom(
              backgroundColor: okButtonColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child:
                dialogController.isLoading.value
                    ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                    : Text(
                      context.tr(okText),
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
          ),
        ),
      ],
    );
  }

  static Future<void> show({
    required BuildContext context,
    required String title,
    required String content,
    String okText = 'OK',
    String cancelText = 'Cancel',
    Color okButtonColor = Colors.blue,
    VoidCallback? onOkPressed,
    VoidCallback? onCancelPressed,
    IconData? icon, // New parameter for icon
    Color iconBorderColor = Colors.blue,
    final bool showBorder = false,
    final double iconSize = 32, // New parameter for icon border color
  }) {
    return showDialog(
      context: context,
      builder:
          (context) => ConfirmDialog(
            title: title,
            content: content,
            okText: okText,
            cancelText: cancelText,
            okButtonColor: okButtonColor,
            onOkPressed: onOkPressed,
            onCancelPressed: onCancelPressed,
            icon: icon,
            iconBorderColor: iconBorderColor,
            showBorder: showBorder,
            iconSize: iconSize,
          ),
    );
  }
}
