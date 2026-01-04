import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OverlayToast {
  static OverlayEntry? _entry;

  static void show(String message) {
    _entry?.remove();

    final overlay =
        Get.overlayContext != null ? Overlay.of(Get.overlayContext!) : null;

    if (overlay == null) return;

    _entry = OverlayEntry(
      builder:
          (_) => Positioned(
            left: 20,
            right: 20,
            bottom: 80,
            child: Material(
              color: Colors.transparent,
              child: _ToastBody(message),
            ),
          ),
    );

    overlay.insert(_entry!);

    Future.delayed(const Duration(seconds: 2), () {
      _entry?.remove();
      _entry = null;
    });
  }
}

class _ToastBody extends StatelessWidget {
  final String text;
  const _ToastBody(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white),
        textAlign: TextAlign.center,
      ),
    );
  }
}
