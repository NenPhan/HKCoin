import 'package:flutter/material.dart';

class ScanLoadingOverlay extends StatelessWidget {
  final String text;

  const ScanLoadingOverlay({super.key, this.text = 'Đang phân tích ảnh…'});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.55),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(color: Colors.white),
            const SizedBox(height: 14),
            Text(
              text,
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
