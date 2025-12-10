import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hkcoin/core/enums.dart';
import 'package:hkcoin/core/presentation/widgets/spacing.dart';
import 'package:hkcoin/data.models/checkout_data.dart';
import 'package:hkcoin/localization/localization_service.dart';
import 'package:hkcoin/presentation.controllers/wallet_token_payment_controller.dart';
import 'package:hkcoin/presentation.pages/qr_scan_page.dart';
import 'package:hkcoin/widgets/base_app_bar.dart';
import 'package:hkcoin/widgets/fee_loading_effect.dart';
import 'package:hkcoin/widgets/formated_number_widget.dart';
import 'package:hkcoin/widgets/main_button.dart';
import 'package:hkcoin/widgets/screen_popup_widget.dart';
import 'package:hkcoin/widgets/token_icon_widget.dart';

class WalletPaymmentOrderParam {
  final CheckoutCompleteData order;
  WalletPaymmentOrderParam({required this.order}); 
}

class WalletPaymmentOrderPage extends StatefulWidget {
  const WalletPaymmentOrderPage({super.key});
  static String route = "/wallet-payment-order";

  @override
  State<WalletPaymmentOrderPage> createState() => _WalletPaymmentOrderPageState();
}

class _WalletPaymmentOrderPageState extends State<WalletPaymmentOrderPage> {
  final WalletPaymmentOrderController controller = Get.put(WalletPaymmentOrderController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WalletPaymmentOrderController>(
      id: "wallet-payment-order-page",
      builder: (controller) {
        return Scaffold(         
           bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildSubmitButton(context, controller),
          ), 
          body: SafeArea(
            child: Column(
              children: [
                BaseAppBar(title: tr("Checkout.Payment.Order.AppBar").replaceAll('{0}',controller.orderInfo.order.coinExtension!),    
                isBackEnabled: false,            
                 actionWidget: IconButton(
                  icon: const Icon(Icons.settings),
                  onPressed: () {
                    ScreenPopup(
                      title: "Account.wallet.Network.Selected",
                      isDismissible: false,
                      backgroundColor: const Color(0xFF1B1B1B),
                      heightFactor: .75,
                      //onShow: () =>controller.getNetworks(),
                      child: Obx(
                        () => Column(
                          children: [
                            const SizedBox(height: 10),
                            TextField(
                              controller:
                                  controller.searchNetworkController,
                              decoration: const InputDecoration(
                                hintText:
                                    'Account.wallet.Network.Filter',
                                prefixIcon: Icon(Icons.search),
                                border: OutlineInputBorder(),
                                filled: true,
                                fillColor: Colors.white10,
                              ),
                              onChanged: (value) {
                                //controller.filterNetworks(value);
                              },
                            ),
                            const SizedBox(height: 10),
                            SizedBox(
                              height:
                                  MediaQuery.of(
                                    context,
                                  ).size.height *
                                  0.55,
                              child: ListView.builder(
                                padding: EdgeInsets.zero,
                                itemCount:
                                    controller
                                        .listNetwork
                                        .length, // Fix null list
                                itemBuilder: (ctx, index) {
                                  final network =
                                      controller
                                          .listNetwork[index];
                                  final isSelected =
                                      controller
                                          .selectedNetwork
                                          .value
                                          ?.id ==
                                      network
                                          .id; // Fix null selected
                                  return Card(
                                    margin:
                                        const EdgeInsets.symmetric(
                                          horizontal: 4,
                                          vertical: 4,
                                        ),
                                    color:
                                        isSelected
                                            ? const Color(
                                              0xFF353434,
                                            )
                                            : null,
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(
                                            4,
                                          ),
                                    ),
                                    child: Stack(
                                      children: [
                                        if (isSelected)
                                          Positioned(
                                            left: 0,
                                            top: 0,
                                            bottom: 0,
                                            child: Container(
                                              width: 4,
                                              height: 15,
                                              decoration: const BoxDecoration(
                                                color:
                                                    Colors.blue,
                                                borderRadius:
                                                    BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(
                                                            4,
                                                          ),
                                                      bottomLeft:
                                                          Radius.circular(
                                                            4,
                                                          ),
                                                    ),
                                              ),
                                            ),
                                          ),
                                        ListTile(
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                horizontal: 8,
                                                vertical: 4,
                                              ),
                                          leading: const Icon(
                                            Icons.wifi,
                                            color: Colors.white70,
                                            size: 24,
                                          ),
                                          title: Text(
                                            network.name ??
                                                "Unnamed Wallet",
                                            style:
                                                const TextStyle(
                                                  color:
                                                      Colors
                                                          .white,
                                                ),
                                          ),
                                          trailing: const Icon(
                                            Icons.more_vert,
                                            color: Colors.white70,
                                          ),
                                          onTap: () {
                                            controller
                                                .selectedNetwork(
                                                  network,
                                                );
                                            Navigator.pop(
                                              context,
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ).show(context);
                  })
                ),                
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [  
                        _buildOrderInfoCard(controller),                      
                        const SizedBox(height: 24),
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
                                                controller.walletInfo?.name??"",
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
                                              controller.walletInfo?.walletAddressFormat??"",                                             
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
                                        imageUrl: controller.walletsInfo?.iconUrl??"",
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
                                              controller.walletsInfo?.chain!.name??"",
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              controller.walletsInfo?.ethereumNetwork!.name??"",
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      FormattedNumber(value: controller.walletsInfo?.totalBalance ,decimalDigits:controller.walletsInfo?.chain==Chain.BNB? 5:2,
                                                          style: const TextStyle(fontSize: 20),
                                                          suffix: controller.walletsInfo?.chain!.name,),                               
                                    ],
                                  ),
                                ),     
                                const SizedBox(height: 16),  
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.orange),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    tr("Checkout.Payment.Order.Alert").replaceAll('{0}', controller.walletsInfo?.symbol ?? 'BNB')
                                    .replaceAll('{1}', controller.walletsInfo?.ethereumNetwork!.name??""),
                                    style: const TextStyle(color: Colors.orange),
                                  ),
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
                                    }else{
                                      return Column(
                                          children: [
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
                                                Text((controller.orderInfo.order.orderWalletTotal ??0) >0
                                                ? controller.orderInfo.order.orderWalletTotalStr ?? ""
                                                : controller.orderInfo.order.orderTotal ?? ""),
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
                                                              (controller.orderInfo.order.orderWalletTotal ??0) >0
                                                              ? controller.orderInfo.order.orderWalletTotalStr ?? ""
                                                              : controller.orderInfo.order.orderTotal ?? "",
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
                                    },
                                  )
                                )
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
  // Thêm hàm mới để hiển thị thông tin đơn hàng
  Widget _buildOrderInfoCard(WalletPaymmentOrderController controller) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1B1B1B),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.amber[900]!.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tiêu đề
          Text(
            tr("Checkout.OrderTotals.Information"),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.amber[900],
            ),
          ),
          
          const SizedBox(height: 12),
          
          // Thông tin đơn hàng
          _buildOrderInfoRow(
            tr("Order.Order"),
            controller.orderInfo.order.orderNumber ?? "-",
            Icons.receipt,
          ),
          
          const Divider(color: Colors.grey, height: 24),
          
          _buildOrderInfoRow(
            tr("Order.OrderTotal"),
            (controller.orderInfo.order.orderWalletTotal ??0) >0
              ? controller.orderInfo.order.orderWalletTotalStr ?? ""
              : controller.orderInfo.order.orderTotal ?? "",
            Icons.monetization_on,
            isAmount: true,
          ),                              
        ],
      ),
    );
  }

  // Widget helper để hiển thị từng dòng thông tin
  Widget _buildOrderInfoRow(String label, String value, IconData icon, {
    bool isAmount = false, 
    bool isTotal = false,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: isTotal ? Colors.amber[900] : Colors.grey[400],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: isTotal ? Colors.amber[900] : Colors.grey[400],
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isAmount ? 16 : 14,
            fontWeight: isAmount ? FontWeight.bold : FontWeight.normal,
            color: isTotal ? Colors.amber[900] : Colors.white,
          ),
        ),
      ],
    );
  }
  Widget _buildSubmitButton(BuildContext context, WalletPaymmentOrderController controller) {
    return Obx(
      () => MainButton(
        isLoading: controller.isLoadingSubmit.value,
        enable: controller.isInitializationComplete,
        width: double.infinity,
        text: "Account.Wallet.Send",
        onTap: () async {
          controller.isLoadingSubmit.value = true;   
          if (!controller.formKey.currentState!.validate()) {
            return;
          }
          final validationResult = await controller.validateBalances();
          if (!validationResult['success']) {
            Get.snackbar(
              tr("Admin.Common.Errors"),
              validationResult['message'],
              backgroundColor: Colors.red,
              colorText: Colors.white,
            );        
            controller.isLoadingSubmit.value = false;    
            return;
          }       
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
  Future<bool> _showConfirmationPopup(BuildContext context, WalletPaymmentOrderController controller) async {
  return await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      title: Text(tr("Checkout.ConfirmOrder")),
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

Widget _buildTransactionSummary(WalletPaymmentOrderController controller) {
  return Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: const Color(0xFF1B1B1B),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Column(
      children: [
     
        _buildSummaryRow(
          tr("Order.OrderTotal"),
           (controller.orderInfo.order.orderWalletTotal ??0) >0
              ? controller.orderInfo.order.orderWalletTotalStr ?? ""
              : controller.orderInfo.order.orderTotal ?? ""
        ),
        const SizedBox(height: 8),
        _buildSummaryRow(
          tr("Account.wallet.SendPage.Network.Fee"),
          '${controller.gasFee.value.toStringAsFixed(8)} ${controller.maxGasFeeChain.value}'
        ),
        const Divider(height: 16),
        // _buildSummaryRow(
        //   tr("Account.wallet.SendPage.Total"),
        //   '${double.parse(controller.walletAmountController.text)} ${controller.walletsInfo!.symbol}',
        //   isBold: true
        // ),
        //  _buildSummaryRow(
        //   tr("Account.wallet.SendPage.Network.Fee"),
        //   '${controller.gasFee.value.toStringAsFixed(8)} ${controller.maxGasFeeChain.value}'
        // ),
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

Future<Map<String, dynamic>> _performTransaction(WalletPaymmentOrderController controller) async {
  try {
    return await controller.sendBNBAndToken();
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
  void _navigateToQRScanPage(WalletPaymmentOrderController controller, BuildContext context) {
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