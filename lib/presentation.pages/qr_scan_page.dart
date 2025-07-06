import 'package:flutter/material.dart';
import 'package:hkcoin/presentation.controllers/qr_scan_controller.dart';
import 'package:hkcoin/widgets/qr_scan_widget.dart';

class QRScanPage extends StatefulWidget {
  final Function(String)? onScanResult;
  final bool showDialogOnScan;
  const QRScanPage({Key? key, this.onScanResult, this.showDialogOnScan = true})
    : super(key: key);

  @override
  State<QRScanPage> createState() => _QRScanPageState();
}

class _QRScanPageState extends State<QRScanPage> {
  late final QRScannerController controller;

  @override
  void initState() {
    controller = QRScannerController(showDialogOnScan: widget.showDialogOnScan);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return QRScannerWidget(
      controller: controller,
      onScanResult: (result) {
        // Gọi callback để xử lý kết quả
        if (widget.onScanResult != null) {
          widget.onScanResult!(result);
          // controller.handleScannedResult(context, result);
        } else {
          // Hiển thị SnackBar mặc định nếu không có callback
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('QR Code Result: $result')));
        }
      },
    );
  }
}
