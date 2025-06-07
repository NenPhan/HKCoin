import 'package:flutter/material.dart';

class QRScannerOverlay extends StatelessWidget {
  final Color borderColor;
  final double borderWidth;
  final double cutoutSize;

  const QRScannerOverlay({
    Key? key,
    this.borderColor = Colors.red,
    this.borderWidth = 4.0,
    this.cutoutSize = 250,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ColorFiltered(
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.5),
            BlendMode.srcOut,
          ),
          child: Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                  backgroundBlendMode: BlendMode.dstOut,
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: cutoutSize,
                    height: cutoutSize,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned.fill(
          child: CustomPaint(
            painter: _ScannerOverlayPainter(
              borderColor: borderColor,
              borderWidth: borderWidth,
              cutoutSize: cutoutSize,
            ),
          ),
        ),
      ],
    );
  }
}

class _ScannerOverlayPainter extends CustomPainter {
  final Color borderColor;
  final double borderWidth;
  final double cutoutSize;

  _ScannerOverlayPainter({
    required this.borderColor,
    required this.borderWidth,
    required this.cutoutSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;

    final center = Offset(size.width / 2, size.height / 2);
    final rect = Rect.fromCenter(
      center: center,
      width: cutoutSize,
      height: cutoutSize,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(16)),
      paint,
    );

    // Vẽ góc khung
    const cornerSize = 20.0;

    final cornerPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.fill;

    // Góc trên trái
    canvas.drawPath(
      Path()
        ..moveTo(rect.left, rect.top + cornerSize)
        ..lineTo(rect.left, rect.top)
        ..lineTo(rect.left + cornerSize, rect.top),
      cornerPaint,
    );

    // Góc trên phải
    canvas.drawPath(
      Path()
        ..moveTo(rect.right - cornerSize, rect.top)
        ..lineTo(rect.right, rect.top)
        ..lineTo(rect.right, rect.top + cornerSize),
      cornerPaint,
    );

    // Góc dưới trái
    canvas.drawPath(
      Path()
        ..moveTo(rect.left, rect.bottom - cornerSize)
        ..lineTo(rect.left, rect.bottom)
        ..lineTo(rect.left + cornerSize, rect.bottom),
      cornerPaint,
    );

    // Góc dưới phải
    canvas.drawPath(
      Path()
        ..moveTo(rect.right - cornerSize, rect.bottom)
        ..lineTo(rect.right, rect.bottom)
        ..lineTo(rect.right, rect.bottom - cornerSize),
      cornerPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}