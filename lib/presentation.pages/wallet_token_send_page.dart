import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hkcoin/core/enums.dart';
import 'package:hkcoin/core/presentation/widgets/spacing.dart';
import 'package:hkcoin/data.models/blockchange_wallet_token_info.dart';
import 'package:hkcoin/presentation.controllers/wallet_token_send_controller.dart';
import 'package:hkcoin/presentation.pages/qr_scan_page.dart';
import 'package:hkcoin/widgets/base_app_bar.dart';
import 'package:hkcoin/widgets/formated_number_widget.dart';
import 'package:hkcoin/widgets/main_button.dart';
import 'package:hkcoin/widgets/main_text_field.dart';
import 'package:hkcoin/widgets/token_icon_widget.dart';

class WalletTokenSendingPageParam {
  final BlockchangeWalletTokenInfo wallet;

  WalletTokenSendingPageParam({required this.wallet});  
}

class WalletTokenSendingPage extends StatefulWidget {
  const WalletTokenSendingPage({super.key});
  static String route = "/wallet-token-send";

  @override
  State<WalletTokenSendingPage> createState() => _WalletTokenSendingPageState();
}

class _WalletTokenSendingPageState extends State<WalletTokenSendingPage> {
  final WalletTokenSendingController controller = Get.put(WalletTokenSendingController());
  late BlockchangeWalletTokenInfo wallet;
  @override
  void initState() {
    super.initState();
    if (Get.arguments is WalletTokenSendingPageParam) {
      wallet = (Get.arguments as WalletTokenSendingPageParam).wallet;     
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WalletTokenSendingController>(
      id: "wallet-token-sending-page",
      builder: (controller) {
        return Scaffold(         
           bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildSubmitButton(context, controller),
          ), 
          body: SafeArea(
            child: Column(
              children: [
                const BaseAppBar(title: "Account.Wallet.Send", centerTitle: true),
                
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [  
                        Form(
                          key: controller.formKey,
                          child: SpacingColumn(
                            spacing: 0,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(0),                        
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 6,
                                        child: Container(
                                          height: 42, // Chiều cao cố định
                                          margin: const EdgeInsets.only(right: 5), // Khoảng cách phải 5px (tổng 2 bên là 10px)
                                          padding: const EdgeInsets.only(left: 10),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF1B1B1B),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Row(
                                            children: [
                                              const Icon(Icons.account_balance_wallet, size: 24),
                                              const SizedBox(width: 8),
                                              Text(
                                                wallet.walletName!,
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),                                                                
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      Expanded(
                                        flex: 4,
                                        child:Container(
                                          height: 42, // Chiều cao cố định                                  
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF1B1B1B),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Center( 
                                            child: Text(
                                              '${wallet.walletAddress!.substring(0, 5)}...${wallet.walletAddress!.substring(wallet.walletAddress!.length - 4)}',    
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey[600],
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.center,
                                            ),
                                          ),                                  
                                        )                                
                                      ),
                                    ],
                                  ),
                                ),                                                                                                          
                                const SizedBox(height: 24),
                                Container(
                                  padding: EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF1B1B1B),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    children: [
                                      TokenIconWidget(
                                        imageUrl: wallet.iconUrl,
                                        width: 32,
                                        height: 32,                  
                                        hasBorder: false,
                                        backgroundColor: Colors.transparent,                                    
                                        placeholder: const CircularProgressIndicator(),
                                        errorWidget: const Icon(Icons.token, size: 32),
                                        padding: const EdgeInsets.all(2),
                                      ),    
                                      // Logo bên trái                              
                                      SizedBox(width: 12),                              
                                      // Chain và Network ở giữa
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              wallet.chain!.name,
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              wallet.ethereumNetwork!.name,
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      FormattedNumber(value: wallet.totalBalance ,decimalDigits:wallet.chain==Chain.BNB? 5:2,
                                                          style: const TextStyle(fontSize: 20),
                                                          suffix: wallet.chain!.name,),                               
                                    ],
                                  ),
                                ),                                                                        
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    const Text(
                                      'Đến',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const Spacer(),
                                    IconButton(
                                      icon: const Icon(Icons.qr_code_scanner),
                                      onPressed: () => _navigateToQRScanPage(controller, context),
                                    ),
                                  ],
                                ),
                                MainTextField(
                                  controller: controller.walletAddressController,                                                                  
                                  hintText:  tr(
                                    "Nhập địa chỉ ví",
                                  ),              
                                  isRequired: true,                     
                                  obscureText: true,
                                  suffixWidget: GestureDetector(
                                    onTap: () async {
                                      final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
                                      final clipboardText = clipboardData?.text?.trim() ?? '';   
                                      if (clipboardText.isNotEmpty) {
                                        controller.walletAddressController.text = clipboardText;                                
                                      }                       
                                    },
                                    child: Text(
                                      tr("Common.Paste"),    
                                      style: const TextStyle(color: Colors.blue),                          
                                    ),   
                                  ),   
                                  onChanged: (p0) {                      
                                    controller.walletAmountController.clear();              
                                    controller.update(["wallet-token-sending-page"]);
                                  },                                                                                               
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
                                MainTextField(
                                  controller: controller.walletAmountController,                                        
                                  label: tr(
                                    "Nhập số lượng",
                                  ),                   
                                  isRequired: true,                                                            
                                  obscureText: true,
                                  suffixWidget: Text(
                                    wallet.chain!.name
                                  ),
                                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                ),     
                                const SizedBox(height: 16),
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF1B1B1B),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: Colors.grey[700]!),
                                  ),
                                  child: Column(
                                    children: [
                                      // Phí mạng
                                      Row(
                                        children: [
                                          GestureDetector(
                                            onTap: _showGasFeeInfo,
                                            child: Row(
                                              children: [
                                                const Text('Phí mạng'),
                                                const SizedBox(width: 4),
                                                Container(
                                                  padding: const EdgeInsets.all(4),
                                                  decoration: const BoxDecoration(
                                                    color: Color(0xFF575757),
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: const Icon(Icons.info_outline, size: 14),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const Spacer(),
                                          const Text('200 BNB'),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          const Text(
                                            'Có khả năng trong <5,222 giây',
                                            style: TextStyle(
                                              color: Colors.green,
                                              fontSize: 12,
                                            ),
                                          ),
                                          const Spacer(),
                                          Text(
                                            'Phí tối đa 0.0006BNB',
                                            style: TextStyle(
                                              color: Colors.grey[400],
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),        
                                      const SizedBox(height: 16),                                                                                   
                                      const Divider(height: 24, thickness: 1), 
                                      const SizedBox(height: 16),                             
                                      // Tổng số tiền
                                      const Row(
                                        children: [
                                          Text(
                                            'Tổng',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18
                                            ),
                                          ),
                                          Spacer(),
                                          Text(
                                            '200HKC + 0.00006 BNB',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ]                                                                
                          )
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
  Widget _buildSubmitButton(BuildContext context, WalletTokenSendingController controller) {
    return Obx(
      () => MainButton(
        isLoading: controller.isLoadingSubmit.value,
        width: double.infinity,
        text: "Account.Wallet.Send",
        onTap: () async {
         // if (controller.formKey.currentState!.validate()) {
            // Đảm bảo loading hiển thị ngay lập tức
            controller.isLoadingSubmit.value = true;
            await Future.delayed(Duration.zero);                      
            //controller.submitForm();
         // }
        },
      ),
    );
  }
  void _showGasFeeInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Thông tin phí mạng"),
        content: Text("Phí gas là khoản phí cần trả để xử lý giao dịch trên mạng blockchain. Phí này thay đổi tùy thuộc vào tình trạng mạng."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Đóng"),
          ),
        ],
      ),
    );
  }
  void _navigateToQRScanPage(WalletTokenSendingController controller, BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => QRScanPage(
          showDialogOnScan: false,                  
          onScanResult: (result) {
            controller.walletAddressController.text = result;
            //controller.updateContractInfomation();     
            controller.update([
              'add-wallet-contract-page',
            ]);                    
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }
}