import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

class Toast {
  void showSuccessToast(String message) {
    toastification.show(
      title: Text(
        message,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
      ),
      autoCloseDuration: const Duration(seconds: 5),
      type: ToastificationType.success,
      alignment: Alignment.bottomCenter,
    );
  }

  void showErrorToast(String message) {
    toastification.show(
      title: Text(
        message,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
      ),
      autoCloseDuration: const Duration(seconds: 5),
      type: ToastificationType.error,
      alignment: Alignment.bottomCenter,
    );
  }
}
