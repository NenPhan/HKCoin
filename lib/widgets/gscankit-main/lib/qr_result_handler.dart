import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hkcoin/core/helper/overlay_toast.dart';
import 'package:hkcoin/localization/localization_service.dart';
import 'package:hkcoin/presentation.pages/checkout_complete_page.dart';
import 'package:hkcoin/presentation.pages/register_page.dart';
import 'package:hkcoin/widgets/gscankit-main/lib/src/widgets/scan_toast_bus.dart';
import 'package:url_launcher/url_launcher.dart';

enum ScanPurpose {
  /// Scan QR chung (deeplink, URL…)
  generic,

  /// Scan CCCD để nhập form
  cccdInput,
}

enum ScanResultAction {
  /// Đóng màn hình scan
  closeScanner,

  /// Giữ màn hình scan (ví dụ: show dialog)
  keepScanner,
}

abstract class ScanResultHandler {
  Future<ScanResultAction> handle(BuildContext context, String value);
}

class UniversalQrHandler implements ScanResultHandler {
  final ScanPurpose purpose;

  /// callback tuỳ chọn (CCCD, custom...)
  final void Function(String value)? onResult;

  UniversalQrHandler({required this.purpose, this.onResult});

  @override
  Future<ScanResultAction> handle(BuildContext context, String value) async {
    switch (purpose) {
      case ScanPurpose.cccdInput:
        onResult?.call(value);
        return ScanResultAction.closeScanner;

      case ScanPurpose.generic:
      default:
        final handler = QrResultHandler();
        return handler.handle(context, value);
    }
  }
}

class QrResultHandler {
  Future<ScanResultAction> handle(BuildContext context, String result) async {
    // 1. Deeplink nội bộ
    if (_isDeeplink(result)) {
      await _handleDeeplink(result);
      return ScanResultAction.closeScanner;
    }

    // 2. URL ngoài
    if (_isValidUrl(result)) {
      await _handleExternalUrl(context, result);
      return ScanResultAction.closeScanner;
    }

    // 3. Fallback: show raw QR
    _showResultDialog(context, result);
    return ScanResultAction.keepScanner;
  }

  // ================= DEEPLINK =================
  static bool _isDeeplink(String value) {
    try {
      final uri = Uri.parse(value);
      return uri.path.contains('register') || uri.path.contains('ipay');
    } catch (_) {
      return false;
    }
  }

  Future<void> _handleDeeplink(String value) async {
    final uri = Uri.parse(value);
    final query = uri.query;
    final params = _toQueryMap(query);

    if (uri.path.contains('register')) {
      Get.toNamed(RegisterPage.route, arguments: params);
      return;
    }

    if (uri.path.contains('ipay')) {
      final orderId = params['orderid'] ?? '';
      Get.toNamed(CheckoutCompletePage.route, arguments: orderId);
    }
  }

  // ================= EXTERNAL URL =================
  Future<void> _handleExternalUrl(BuildContext context, String url) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        _showResultDialog(context, 'Không thể mở URL: $url');
      }
    } catch (e) {
      _showResultDialog(context, 'Lỗi mở URL: $e');
    }
  }

  // ================= HELPERS =================
  static bool _isValidUrl(String value) {
    try {
      final uri = Uri.parse(value);
      return uri.scheme == 'http' || uri.scheme == 'https';
    } catch (_) {
      return false;
    }
  }

  static Map<String, dynamic> _toQueryMap(String query) {
    final map = <String, dynamic>{};

    if (query.isEmpty) return map;

    for (final pair in query.split('&')) {
      final parts = pair.split('=');
      if (parts.length == 2) {
        map[parts[0]] = parts[1];
      }
    }
    return map;
  }

  void _showResultDialog(BuildContext context, String result) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(tr("Common.Dialog.ScanResult")),
          content: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(6),
              onDoubleTap: () {
                // ✅ COPY
                Clipboard.setData(ClipboardData(text: result));
                HapticFeedback.lightImpact();

                // ✅ ĐÓNG DIALOG
                Navigator.of(dialogContext).pop();
                ScanToastBus.show(
                  title: tr("Common.Success"),
                  content: tr("Common.CopyToClipboard"),
                  position: ScanToastPosition.top,
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(6),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nội dung QR
                    SelectableText(result, style: const TextStyle(height: 1.4)),

                    const SizedBox(height: 10),

                    // HINT
                    Row(
                      children: [
                        Icon(
                          Icons.touch_app,
                          size: 16,
                          color: Colors.grey.shade600,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          tr(
                            "Common.DoubleTapToCopy",
                          ), // "Chạm đúp để sao chép"
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(tr("Common.Close")),
            ),
          ],
        );
      },
    );
  }
}
