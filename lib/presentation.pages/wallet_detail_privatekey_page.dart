import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:hkcoin/core/config/app_theme.dart';
import 'package:hkcoin/core/presentation/widgets/spacing.dart';
import 'package:hkcoin/core/utils/encryptor.dart';
import 'package:hkcoin/data.models/blockchange_wallet_info.dart';
import 'package:hkcoin/widgets/alert_widget.dart';
import 'package:hkcoin/widgets/base_app_bar.dart';
import 'package:hkcoin/widgets/main_button.dart';
import 'package:hkcoin/widgets/main_text_field.dart';
import 'package:hkcoin/widgets/qrcode_widget.dart';
import 'package:flutter/services.dart'; // For clipboard

class ExportPrivateKeyPageParam {
  final BlockchangeWalletInfo wallet;

  ExportPrivateKeyPageParam({required this.wallet});
}

class WalletExportPrivateKeyPage extends StatefulWidget {
  const WalletExportPrivateKeyPage({super.key});
  static String route = "/wallet-export-privatekey";

  @override
  State<WalletExportPrivateKeyPage> createState() => _WalletExportPrivateKeyPageState();
}

class _WalletExportPrivateKeyPageState extends State<WalletExportPrivateKeyPage> {
  late BlockchangeWalletInfo wallet;
  late TextEditingController privateKeyController = TextEditingController();
  bool _showQrCode = false; // State to toggle QR code visibility

  @override
  void initState() {
    super.initState();
    _disableScreenshots();
    if (Get.arguments is ExportPrivateKeyPageParam) {
      wallet = (Get.arguments as ExportPrivateKeyPageParam).wallet;
      if (wallet.privateKey?.isNotEmpty ?? false) {
        try {
          privateKeyController.text = decryptText(wallet.privateKey!, '');
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to decrypt private key: $e')),
          );
        }
      }
    }
  }
  Future<void> _disableScreenshots() async {
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }

  @override
  void dispose() {
    privateKeyController.dispose();
    FlutterWindowManager.clearFlags(FlutterWindowManager.FLAG_SECURE);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _buildSubmitButton(context),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(scrSize(context).width * 0.03),
            child: SpacingColumn(
              spacing: 20,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                const BaseAppBar(title: "Account.Wallet.Detail.Export.PrivateKey"),
                const AlertWidget(
                  type: AlertType.warning,
                  message: "Account.Wallet.Detail.Confirm.Content",
                ),
                // QR Code Box
                _buildQrCodeBox(context),
                // Text Field
                MainTextField(
                  controller: privateKeyController,
                  readOnly: true,
                ),
                // Copy Button
                Align(
                  alignment: Alignment.center,
                  child: IconButton(
                    icon: const Icon(Icons.copy, color: Colors.blue),                    
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: privateKeyController.text));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(tr("Account.Wallet.Detail.Export.PrivateKey.Copied"))),
                      );
                    },
                    tooltip: 'Copy Private Key',
                  ),
                ),                              
                Row(
                  children: [
                    const Icon(Icons.cancel, color: Colors.red, size: 14),
                    const SizedBox(width: 8),
                    Text(
                      tr("Account.Wallet.Detail.Backup.Mnemonic.Avoid"),          
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Html(
                  data: tr("Account.Wallet.Detail.Export.PrivateKey.Alert"),
                  style: {
                    "body": Style(
                      fontSize: FontSize(14),
                      color: textTheme(context).bodyLarge?.color,
                      fontFamily: textTheme(context).bodyLarge?.fontFamily,
                      margin: Margins.zero,
                    ),
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQrCodeBox(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _showQrCode = !_showQrCode;
        });
      },
      child: Container(
        width: double.infinity,                
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (_showQrCode && privateKeyController.text.isNotEmpty)
              QRCodeWidget(
                data: privateKeyController.text,
                size: 180,                
                backgroundColor: Colors.white,
                showShare: false,
                showSaveStore: false,
              )
            else
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.visibility_off,
                    size: 40,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    tr("Account.Wallet.Detail.Export.PrivateKey.TapShow"),
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    return MainButton(
      width: double.infinity,
      text: tr("Common.Ok"),
      onTap: () {
        Get.back();
      },
    );
  }
}