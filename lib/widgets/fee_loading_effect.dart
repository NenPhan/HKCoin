import 'package:flutter/material.dart';

class FeeLoadingEffect extends StatelessWidget {
  const FeeLoadingEffect({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Dòng 1: Phí mạng
        _buildAnimatedLoadingLine(label: 'Phí mạng'),
        const SizedBox(height: 8),
        
        // Dòng 2: Thời gian ước tính + Phí tối đa
        Row(
          children: [
            Expanded(
              flex: 2,
              child: _buildAnimatedLoadingLine(
                widthFactor: 0.7,
                height: 14,
                color: Colors.green,
              ),
            ),
            const Spacer(),
            Expanded(
              flex: 2,
              child: _buildAnimatedLoadingLine(
                widthFactor: 0.6,
                height: 14,
                color: Colors.grey[400],
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 16),
        const Divider(height: 24, thickness: 1),
        const SizedBox(height: 16),
        
        // Dòng 3: Tổng
        _buildAnimatedLoadingLine(
          label: 'Tổng',
          widthFactor: 0.9,
          height: 20,
          isBold: true,
        ),
      ],
    );
  }

  Widget _buildAnimatedLoadingLine({
    String? label,
    double widthFactor = 0.5,
    double height = 16,
    Color? color,
    bool isBold = false,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: widthFactor),
      duration: Duration(milliseconds: 600 + (300 * widthFactor).toInt()),
      curve: Curves.easeOutQuad,
      builder: (context, value, child) {
        return Row(
          children: [
            if (label != null)
              Text(
                label,
                style: TextStyle(
                  fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            if (label != null) const SizedBox(width: 8),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: value,
                  minHeight: height,
                  backgroundColor: Colors.grey[800],
                  valueColor: AlwaysStoppedAnimation<Color>(
                    color ?? Colors.grey[600]!,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}