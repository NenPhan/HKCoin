import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hkcoin/core/enums.dart';
import 'package:hkcoin/core/presentation/widgets/spacing.dart';
import 'package:hkcoin/data.models/blockchange_wallet_token_info.dart';
import 'package:hkcoin/presentation.controllers/wallet_token_send_controller.dart';
import 'package:hkcoin/presentation.pages/qr_scan_page.dart';
import 'package:hkcoin/widgets/base_app_bar.dart';
import 'package:hkcoin/widgets/fee_loading_effect.dart';
import 'package:hkcoin/widgets/formated_number_widget.dart';
import 'package:hkcoin/widgets/main_button.dart';
import 'package:hkcoin/widgets/main_text_field.dart';
import 'package:hkcoin/widgets/screen_popup_widget.dart';
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
  //late BlockchangeWalletTokenInfo wallet;
  @override
  void initState() {
    super.initState();
    // final params = Get.arguments is WalletTokenSendingPageParam 
    //   ? Get.arguments as WalletTokenSendingPageParam 
    //   : null;
    // controller.initialize(params);
    // if (Get.arguments is WalletTokenSendingPageParam) {
    //   wallet = (Get.arguments as WalletTokenSendingPageParam).wallet;     
    // }
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
                                                controller.walletsInfo!.walletName!,
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
                                              '${controller.walletsInfo!.walletAddress!.substring(0, 5)}...${controller.walletsInfo!.walletAddress!.substring(controller.walletsInfo!.walletAddress!.length - 4)}',    
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
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF1B1B1B),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    children: [
                                      TokenIconWidget(
                                        imageUrl: controller.walletsInfo!.iconUrl,
                                        width: 32,
                                        height: 32,                  
                                        hasBorder: false,
                                        backgroundColor: Colors.transparent,                                    
                                        placeholder: const CircularProgressIndicator(),
                                        errorWidget: const Icon(Icons.token, size: 32),
                                        padding: const EdgeInsets.all(2),
                                      ),    
                                      // Logo bên trái                              
                                      const SizedBox(width: 12),                              
                                      // Chain và Network ở giữa
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              controller.walletsInfo!.chain!.name,
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              controller.walletsInfo!.ethereumNetwork!.name,
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      FormattedNumber(value: controller.walletsInfo!.totalBalance ,decimalDigits:controller.walletsInfo!.chain==Chain.BNB? 5:2,
                                                          style: const TextStyle(fontSize: 20),
                                                          suffix: controller.walletsInfo!.chain!.name,),                               
                                    ],
                                  ),
                                ),                                                                        
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    Text(
                                      tr("Account.wallet.SendPage.To"),
                                      style: const TextStyle(
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
                                  controller: controller.walletRecipientController,                                                                  
                                  hintText:  tr(
                                    "Account.wallet.SendPage.Address",
                                  ),              
                                  isRequired: true,                     
                                  obscureText: true,
                                  suffixWidget: GestureDetector(
                                    onTap: () async {
                                      final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
                                      final clipboardText = clipboardData?.text?.trim() ?? '';   
                                      if (clipboardText.isNotEmpty) {
                                        controller.walletRecipientController.text = clipboardText;                                
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
                                    tr("Account.Wallet.Received.Alert").replaceAll('{0}', controller.walletsInfo!.symbol ?? 'BNB')
                                    .replaceAll('{1}', controller.walletsInfo!.ethereumNetwork!.name),
                                    style: const TextStyle(color: Colors.orange),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                MainTextField(
                                  controller: controller.walletAmountController,                                        
                                  label: tr("Account.wallet.SendPage.Amount"),                   
                                  isRequired: true,                                                            
                                  obscureText: true,
                                  suffixWidget: Text(
                                    controller.walletsInfo!.chain!.name
                                  ),
                                  keyboardType: const TextInputType.numberWithOptions(decimal: true),     
                                  onChanged: controller.onAmountChanged,                                                                  
                                  onEditingComplete: () {
                                    // Khi bấm nút Done trên bàn phím
                                    if (controller.walletAmountController.text.isNotEmpty) {
                                      final amount = double.tryParse(controller.walletAmountController.text) ?? 0.0;
                                      controller.calculateFee(amount);
                                    }                                    
                                  },
                                ),     
                                const SizedBox(height: 16),
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF1B1B1B),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: Colors.grey[700]!),
                                  ),
                                  child: Obx(() {
                                    if (controller.isFeeLoading.value) {
                                      return const FeeLoadingEffect();
                                    } else {
                                      return Column(
                                        children: [
                                          // Phí mạng
                                          Row(
                                            children: [
                                              GestureDetector(
                                                onTap: _showGasFeeInfo,
                                                child: Row(
                                                  children: [
                                                    Text(tr("Account.wallet.SendPage.Network.Fee")),
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
                                              Text('${controller.walletAmountController.text} ${controller.walletsInfo!.chain!.name}'),
                                            ],
                                          ),
                                          const SizedBox(height: 4),
                                          Row(
                                            children: [
                                              Flexible(
                                                child: Text(
                                                  tr("Account.wallet.SendPage.Estimated.Time").replaceAll('{0}', controller.estimatedTime.value),
                                                  style: const TextStyle(
                                                    color: Colors.green,
                                                    fontSize: 12,
                                                  ),
                                                  maxLines: 2, // Cho phép tối đa 2 dòng
                                                  overflow: TextOverflow.ellipsis, // Hiển thị dấu ba chấm (...) nếu văn bản quá dài
                                                  textAlign: TextAlign.right, // Căn chỉnh văn bản sang phải
                                                ),
                                              ),         
                                              const Spacer(),                                                                                 
                                              Flexible(
                                                child: Text(
                                                  tr("Account.wallet.SendPage.MaximumFee")
                                                      .replaceAll('{0}', controller.maxGasFee.value.toStringAsFixed(8))
                                                      .replaceAll('{1}', controller.maxGasFeeChain.value),
                                                  style: TextStyle(
                                                    color: Colors.grey[400],
                                                    fontSize: 12,
                                                  ),
                                                  maxLines: null, // Cho phép tối đa 2 dòng
                                                 // overflow: TextOverflow.ellipsis, // Hiển thị dấu ba chấm (...) nếu văn bản quá dài
                                                  textAlign: TextAlign.right, // Căn chỉnh văn bản sang phải
                                                ),
                                              ),
                                            ],
                                          ),     
                                          const SizedBox(height: 5),                                                                                   
                                          const Divider(height: 24, thickness: 1), 
                                          const SizedBox(height: 5),                             
                                          // Tổng số tiền
                                          Row(
                                            children: [
                                              Text(
                                                tr("Account.wallet.SendPage.Total"),
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18,
                                                ),
                                              ),                                              
                                              Flexible(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.end, // Căn chỉnh sang phải
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.end, // Căn chỉnh số lượng sang phải
                                                      children: [
                                                        Flexible(
                                                          child: Text(
                                                            '${controller.walletAmountController.text}${controller.walletsInfo!.symbol ?? ''}',
                                                            style: const TextStyle(
                                                              fontWeight: FontWeight.bold,
                                                              fontSize: 18,
                                                            ),
                                                            textAlign: TextAlign.right, // Căn chỉnh sang phải
                                                            maxLines: 1, // Giới hạn ở 1 dòng
                                                            overflow: TextOverflow.ellipsis, // Dấu ba chấm nếu quá dài
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Text(
                                                      '+ ${controller.gasFee.value.toStringAsFixed(8)} ${controller.maxGasFeeChain.value}',
                                                      style: TextStyle(
                                                        fontWeight: FontWeight.normal,
                                                        fontSize: 12,
                                                        color: Colors.grey[400], // Màu nhạt hơn để phân biệt
                                                      ),
                                                      textAlign: TextAlign.right, // Căn chỉnh sang phải
                                                      overflow: TextOverflow.ellipsis, 
                                                      maxLines: 1, // Cho phép ngắt dòng nếu quá dài
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),                                          
                                        ],
                                      );
                                    }
                                  }),
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
          if (!controller.formKey.currentState!.validate()) {
            return;
          }
         // if (controller.formKey.currentState!.validate()) {
            // Đảm bảo loading hiển thị ngay lập tức
            controller.isLoadingSubmit.value = true;
            final shouldContinue = await _showConfirmationPopup(context, controller);
            if (!shouldContinue) {
              controller.isLoadingSubmit.value = false;
              return;
            }
            await Future.delayed(Duration.zero);         
              // Thực hiện giao dịch
            final result = await _performTransaction(controller);
            
            // Xử lý kết quả
            // ignore: use_build_context_synchronously
            _handleTransactionResult(context, result);
            
            controller.isLoadingSubmit.value = false;                 
            //controller.submitForm();
         // }
        },
      ),
    );
  }
  Future<bool> _showConfirmationPopup(BuildContext context, WalletTokenSendingController controller) async {
  return await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      title: Text(tr("Account.PrivateMessage")),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(tr("Account.wallet.SendPage.Continute")),
          const SizedBox(height: 20),
          _buildTransactionSummary(controller),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(tr("Common.Cancel")),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(tr("Common.Confirm")),
        ),
      ],
    ),
  ) ?? false;
}

Widget _buildTransactionSummary(WalletTokenSendingController controller) {
  return Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: const Color(0xFF1B1B1B),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Column(
      children: [
        _buildSummaryRow(
          tr("Account.wallet.SendPage.Amount"),
          '${controller.walletAmountController.text} ${controller.walletsInfo!.symbol}'
        ),
        const SizedBox(height: 8),
        _buildSummaryRow(
          tr("Account.wallet.SendPage.Network.Fee"),
          '${controller.gasFee.value.toStringAsFixed(8)} ${controller.maxGasFeeChain.value}'
        ),
        const Divider(height: 16),
        _buildSummaryRow(
          tr("Account.wallet.SendPage.Total"),
          '${double.parse(controller.walletAmountController.text)} ${controller.walletsInfo!.symbol}',
          isBold: true
        ),
         _buildSummaryRow(
          tr("Account.wallet.SendPage.Network.Fee"),
          '${controller.gasFee.value.toStringAsFixed(8)} ${controller.maxGasFeeChain.value}'
        ),
      ],
    ),
  );
}

Widget _buildSummaryRow(String label, String value, {bool isBold = false}) {
  return Row(
    children: [
      Text(label, style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
      const Spacer(),
      Text(value, style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
    ],
  );
}

Future<Map<String, dynamic>> _performTransaction(WalletTokenSendingController controller) async {
  try {
    final amount = double.parse(controller.walletAmountController.text);
    final recipient = controller.walletRecipientController.text;
    
    return await controller.sendBNBAndToken(recipient, amount);
  } catch (e) {
    return {
      'success': false,
      'error': e.toString()
    };
  }
}

void _handleTransactionResult(BuildContext context, Map<String, dynamic> result) {
  if (result['success']) {
    Get.back(); // Quay lại màn hình trước đó
    Get.back();
    Get.snackbar(
      tr("Common.Success"),
      tr("Account.wallet.SendPage.TransactionSuccess"),
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
    
    // Hiển thị thông tin chi tiết giao dịch nếu cần
    _showTransactionDetails(context, result['txHash']);
  } else {
    Get.snackbar(
      tr("Common.Error"),
      result['error'] ?? tr("Account.wallet.SendPage.TransactionFailed"),
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }
}

void _showTransactionDetails(BuildContext context, String txHash) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(tr("Account.wallet.SendPage.TransactionDetails")),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(tr("Account.wallet.SendPage.TransactionHash")),
            const SizedBox(height: 8),
            SelectableText(
              txHash,
              style: const TextStyle(fontSize: 12),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Mở trình duyệt để xem chi tiết giao dịch trên blockchain explorer
                // _openBlockchainExplorer(txHash);
                Navigator.of(context).pop();
              },
              child: Text(tr("Account.wallet.SendPage.ViewOnExplorer")),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(tr("Common.Close")),
          ),
        ],
      ),
    );
  }
  void _showGasFeeInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(tr("Account.wallet.SendPage.AlertDialog.Title")),
        content: Text(tr("Account.wallet.SendPage.AlertDialog.Content")),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(tr("Common.Close")),
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
            controller.walletRecipientController.text = result;
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