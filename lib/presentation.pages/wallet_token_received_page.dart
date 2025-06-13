import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hkcoin/core/time_converter.dart';
import 'package:hkcoin/data.models/blockchange_wallet_token_info.dart';
import 'package:hkcoin/presentation.controllers/wallet_token_detail_controller.dart';
import 'package:hkcoin/widgets/base_app_bar.dart';
import 'package:hkcoin/widgets/qrcode_widget.dart';
import 'package:hkcoin/widgets/token_icon_widget.dart';
import 'package:share_plus/share_plus.dart';

class WalletTokenReceivedPageParam {
  final BlockchangeWalletTokenInfo wallet;

  WalletTokenReceivedPageParam({required this.wallet});
}

class WalletTokenReceivedPage extends StatefulWidget {
  const WalletTokenReceivedPage({super.key});
  static String route = "/wallet-token-received";

  @override
  State<WalletTokenReceivedPage> createState() => _WalletTokenReceivedPageState();
}

class _WalletTokenReceivedPageState extends State<WalletTokenReceivedPage> {
  final WalletTokenDetailController controller = Get.put(WalletTokenDetailController());
  late BlockchangeWalletTokenInfo wallet;
  @override
  void initState() {
    super.initState();
    if (Get.arguments is WalletTokenReceivedPageParam) {
      wallet = (Get.arguments as WalletTokenReceivedPageParam).wallet;     
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WalletTokenDetailController>(
      id: "wallet-token-received-page",
      builder: (controller) {
        return Scaffold(          
          body: SafeArea(
            child: Column(
              children: [
                const BaseAppBar(title: "Account.Wallet.Received", centerTitle: true),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [                         
                        // Header với tên ví
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1B1B1B),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.account_balance_wallet, color: Colors.white70),
                              const SizedBox(width: 8),
                              Text(
                                wallet.walletName!,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ),                      
                        const SizedBox(height: 24),
                        
                        // Box thông tin ví
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1B1B1B),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              // Logo và tên chain
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  TokenIconWidget(
                                    imageUrl: wallet.iconUrl,
                                    width: 24,
                                    height: 24,                  
                                    hasBorder: false,
                                    backgroundColor: Colors.transparent,                                    
                                    placeholder: const CircularProgressIndicator(),
                                    errorWidget: const Icon(Icons.token, size: 80),
                                  ),     
                                  const SizedBox(width: 8),
                                  Text(
                                    wallet.symbol ?? 'BNB Chain',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    "(${wallet.ethereumNetwork!.name})",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              
                              // QR Code và địa chỉ
                              Column(
                                children: [
                                  QRCodeWidget(
                                    data: wallet.walletAddress!,
                                    size: 250,                
                                    backgroundColor: Colors.white,
                                    showShare: true,
                                    showSaveStore: false,
                                  ),
                                  const SizedBox(height: 16),
                                  SelectableText(
                                    wallet.walletAddress ?? '',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontFamily: 'monospace',
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        // 2 button Chia sẻ và Chép
                        Row(
                          children: [
                            // Button Chia sẻ
                            Expanded(
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  side: const BorderSide(color: Colors.blue),
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onPressed: () {
                                  _shareWalletAddress();
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.share, color: Colors.blue),
                                    const SizedBox(width: 8),
                                    Text(tr("Common.Share"), style: const TextStyle(color: Colors.blue)),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            
                            // Button Chép
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue[700],
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onPressed: () {
                                  if (wallet.walletAddress != null) {
                                    Clipboard.setData(ClipboardData(text: wallet.walletAddress!));
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(tr("Common.CopyToClipboard"))),
                                    );
                                  }
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.copy, color: Colors.white),
                                    const SizedBox(width: 8),
                                    Text(tr("Common.Copy"), style: const TextStyle(color: Colors.white)),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        
                        // Cảnh báo
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.orange),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            tr("Account.Wallet.Received.Alert").replaceAll('{0}', wallet.symbol ?? 'BNB')
                            .replaceAll('{1}', wallet.ethereumNetwork!.name),
                            style: const TextStyle(color: Colors.orange),
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        // // Button Nạp tiền
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[700],
                            minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () {
                            Get.back();
                            Get.back();
                          },
                          icon: const Icon(Icons.arrow_downward, color: Colors.white),
                          label: Text(
                            tr("Account.Wallet.Received.Btn.Other"),                            
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }
    );    
  } 
  Future<void> _shareWalletAddress() async {
    if (wallet.walletAddress == null) return;
    
    final shareText = '''
Địa chỉ ví ${wallet.symbol ?? 'của tôi'}:
${wallet.walletAddress}

Chỉ gửi ${wallet.symbol ?? 'BNB'} và BEP20 token đến địa chỉ này.
Gửi các loại tiền khác có thể bị mất vĩnh viễn.
''';
    
    try {
      await SharePlus.instance.share(
      ShareParams(     
        text: shareText,
        subject: 'Địa chỉ ví ${wallet.symbol ?? ''}',
      ),
    );     
    } catch (e) {
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        const SnackBar(content: Text('Lỗi khi chia sẻ')),
      );
    }
  }   
}