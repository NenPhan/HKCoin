import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

class Toast {
  static void showSuccessToast(String message) {
    toastification.show(
      title: Text(message, maxLines: 3, overflow: TextOverflow.ellipsis),
      autoCloseDuration: const Duration(seconds: 3),
      type: ToastificationType.success,
      alignment: Alignment.topRight,
    );
  }

  static void showErrorToast(String message) {
    toastification.show(
      title: Text(message, maxLines: 3, overflow: TextOverflow.ellipsis),
      autoCloseDuration: const Duration(seconds: 3),
      type: ToastificationType.error,
      alignment: Alignment.topRight,
    );
  }
}
