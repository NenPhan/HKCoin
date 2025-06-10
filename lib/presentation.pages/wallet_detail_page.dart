import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hkcoin/core/config/app_theme.dart';
import 'package:hkcoin/core/enums.dart';
import 'package:hkcoin/core/presentation/widgets/spacing.dart';
import 'package:hkcoin/core/toast.dart';
import 'package:hkcoin/core/utils.dart';
import 'package:hkcoin/data.models/network.dart';
import 'package:hkcoin/presentation.controllers/create_wallet_contract_controller.dart';
import 'package:hkcoin/presentation.controllers/wallet_detail_controller.dart';
import 'package:hkcoin/presentation.pages/qr_scan_page.dart';
import 'package:hkcoin/presentation.pages/wallet_detail_backup_page.dart';
import 'package:hkcoin/presentation.pages/wallet_detail_privatekey_page.dart';
import 'package:hkcoin/widgets/base_app_bar.dart';
import 'package:hkcoin/widgets/confirm_dialog.dart';
import 'package:hkcoin/widgets/dropdown_popup.dart';
import 'package:hkcoin/widgets/main_button.dart';
import 'package:hkcoin/widgets/main_text_field.dart';
import 'package:hkcoin/widgets/screen_popup_widget.dart';

class WalletDetailPage extends StatefulWidget {
  const WalletDetailPage({super.key});
  static String route = "/wallet-detail";

  @override
  State<WalletDetailPage> createState() => _WalletDetailPageState();
}

class _WalletDetailPageState extends State<WalletDetailPage> {
  final WalletDetailController controller = Get.put(WalletDetailController());
  @override
  Widget build(BuildContext context) {
    return GetBuilder<WalletDetailController>(
      id: "wallet-detail-page",
      builder: (controller) {
        return Scaffold(
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildSubmitButton(context, controller),
          ),
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const BaseAppBar(title: "Account.Wallet.Detail"),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: scrSize(context).width * 0.03,
                      ),
                      child: Column(
                        children: [
                          Form(
                            key: controller.formKey,
                            child: SpacingColumn(
                              children: [
                                const SizedBox(height: 20),
                                Container(                                  
                                  height: 80,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF1B1B1B),
                                    shape: BoxShape.circle,
                                    
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.all(16.0), // Điều chỉnh giá trị này để thay đổi khoảng cách
                                    child: Icon(
                                      Icons.account_balance_wallet,
                                      size: 30,
                                      color: Color.fromARGB(255, 255, 255, 255),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),                                
                                // Wallet name
                                Text(
                                   controller.walletsInfo?.name ??"",
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 30),                                
                                // First gray rounded container
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF1B1B1B),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(tr("Account.Wallet.Detail.CreateBy")),
                                          Text(
                                           controller.walletsInfo?.createWalletType?? "",
                                            style: textTheme(context).titleMedium?.copyWith(
                                              color: Colors.grey.shade500
                                            ),
                                          ),                                         
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      const Divider(height: 1, color: Colors.grey),
                                      const SizedBox(height: 8),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(tr('Common.CreatedOn')),
                                          Text(
                                           dateFormat(controller.walletsInfo?.createdOnUtc),
                                            style: textTheme(context).labelMedium?.copyWith(
                                              color: Colors.grey.shade500
                                            ),
                                          ),                                         
                                        ],
                                      ),                                 
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 20),
                                
                                // Second gray rounded container
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF1B1B1B),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Column(
                                    children: [
                                      // Backup row
                                      GestureDetector(
                                        onTap: () {
                                          if(controller.walletsInfo?.createWalletTypeId==CreateWalletType.Mnemonic.index){
                                            Get.toNamed(
                                              WalletDetailBackupPage.route,
                                              arguments: WalletDetailPageParam(wallet: controller.walletsInfo!),
                                            );
                                          }else if(controller.walletsInfo?.createWalletTypeId==CreateWalletType.PrivateKey.index){
                                            ConfirmDialog.show(
                                              context: context,
                                              title: 'Common.Warning',
                                              content: 'Account.Wallet.Detail.Confirm.Content',
                                              okText: 'Common.OK',
                                              cancelText: 'Common.Cancel',
                                              icon: Icons.info_outline, // Add icon
                                              iconBorderColor: Colors.red,
                                              iconSize:64,                                            
                                              onOkPressed: () async {
                                                try{                                                                                             
                                                await Get.toNamed(
                                                    WalletExportPrivateKeyPage.route,
                                                    arguments: ExportPrivateKeyPageParam(wallet: controller.walletsInfo!),
                                                  );
                                                }catch (e) {
                                                  // ignore: use_build_context_synchronously
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    SnackBar(content: Text('Failed to create wallet: $e')),
                                                  );
                                                } finally {
                                                  // ignore: use_build_context_synchronously
                                                  Navigator.of(context).pop();
                                                }                                        
                                              },
                                              onCancelPressed: () {                                        
                                                Navigator.of(context).pop();
                                              },
                                            );
                                          }                                            
                                        },
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(tr("Account.Wallet.Detail.Backup")),
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                              decoration: BoxDecoration(
                                                color: Colors.amber[900],
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              child: const Row(
                                                children: [
                                                  Text('Không sao lưu'),
                                                  SizedBox(width: 4),
                                                  Icon(Icons.arrow_forward_ios, size: 16),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      const Divider(height: 1, color: Colors.grey),
                                      const SizedBox(height: 8),
                                      GestureDetector(                                        
                                        onTap: () {
                                          ScreenPopup(title: "Account.Wallet.Detail.CopyPublicKey",                                            
                                            backgroundColor: const Color(0xFF1B1B1B),
                                            heightFactor: .5,                                                                                                                                 
                                            child: Column(
                                              children: [
                                                MainTextField(
                                                  controller: controller.searchController,                                                  
                                                  maxLines: 8,
                                                  minLines: 6,
                                                  readOnly: true,
                                                ),                    
                                                const SizedBox(height: 8),
                                                MainButton(
                                                  isLoading: controller.isLoadingSubmit.value,
                                                  width: double.infinity,
                                                  text: "Admin.Common.Copy",
                                                  onTap: () async {
                                                    try {
                                                      if (controller.searchController.text.isNotEmpty) {
                                                        Clipboard.setData(
                                                          ClipboardData(text: controller.searchController.text),
                                                        );
                                                      }
                                                      Toast.showSuccessToast("Common.CopyToClipboard.Succeeded");
                                                    } catch (e) {
                                                      Toast.showErrorToast("Common.CopyToClipboard.Failded");
                                                    }
                                                  },
                                                ),
                                              ],
                                            )
                                            )
                                          .show(context);  
                                        },
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,                                        
                                          children: [
                                              Row(
                                              children: [
                                                Text(tr("Account.Wallet.Detail.Export.PublicKey")),
                                                const SizedBox(width: 4),
                                                GestureDetector(
                                                  onTap: () {
                                                    // Show note information
                                                    showDialog(
                                                      context: context,
                                                      builder: (context) => AlertDialog(                                                      
                                                        content: Text(tr("Account.Wallet.Detail.Alert.Content")),
                                                        actions: [
                                                          TextButton(
                                                            onPressed: () => Navigator.pop(context),
                                                            child: Text(tr("Common.Close")),
                                                        ),
                                                      ],
                                                      ),
                                                    );
                                                  },
                                                  child: Container(
                                                    padding: const EdgeInsets.all(4),
                                                    decoration: const BoxDecoration(
                                                      color: Color(0xFF313131),
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: const Icon(Icons.question_mark, size: 16),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const Icon(Icons.arrow_forward_ios, size: 16),
                                          ],
                                        ),
                                      ),
                                      // Public key row                                      
                                       const SizedBox(height: 8),
                                      const Divider(height: 1, color: Colors.grey),
                                      const SizedBox(height: 8),
                                      GestureDetector(
                                        onTap: () {
                                         
                                          ConfirmDialog.show(
                                            context: context,
                                            title: 'Common.Warning',
                                            content: 'Account.Wallet.Detail.Confirm.Content',
                                            okText: 'Common.OK',
                                            cancelText: 'Common.Cancel',
                                            icon: Icons.info_outline, // Add icon
                                            iconBorderColor: Colors.red,
                                            iconSize:64,                                            
                                            onOkPressed: () async {
                                              try{                                                                                             
                                               await Get.toNamed(
                                                  WalletExportPrivateKeyPage.route,
                                                  arguments: ExportPrivateKeyPageParam(wallet: controller.walletsInfo!),
                                                );
                                              }catch (e) {
                                                // ignore: use_build_context_synchronously
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(content: Text('Failed to create wallet: $e')),
                                                );
                                              } finally {
                                                // ignore: use_build_context_synchronously
                                                Navigator.of(context).pop();
                                              }                                        
                                            },
                                            onCancelPressed: () {                                        
                                              Navigator.of(context).pop();
                                            },
                                          );
                                        },
                                        child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(tr("Account.Wallet.Detail.Export.PrivateKey")),                                            
                                            const SizedBox(width: 4),   
                                            const Icon(Icons.arrow_forward_ios, size: 16),
                                          ],
                                        ),
                                      ),                                      
                                    ],
                                  ),
                                ),
                              ],
                            )
                          )                      
                        ],
                      ),
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
  Widget _buildSubmitButton(BuildContext context, WalletDetailController controller) {
    return Obx(
      () => MainButton(
        isLoading: controller.isLoadingSubmit.value,
        width: double.infinity,
        text: "Account.Wallet.Deleted",
        onTap: () async {
         // if (controller.formKey.currentState!.validate()) {
            // Đảm bảo loading hiển thị ngay lập tức
            controller.isLoadingSubmit.value = true;
            await Future.delayed(Duration.zero);       
            ConfirmDialog.show(
              // ignore: use_build_context_synchronously
              context: context,
              title: '',
              content: 'Account.Wallet.Detail.Confirm.Delete',
              okText: 'Account.Wallet.Detail.Confirm.StillDelete',
              cancelText: 'Common.Cancel',
              icon: Icons.info_outline, // Add icon
              iconBorderColor: Colors.white,
              iconSize:64,                                            
              onOkPressed: () async {
                try{                                                                                             
                  await controller.deleteWallet(controller.walletsInfo!.id!);
                }catch (e) {
                  // ignore: use_build_context_synchronously
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to delete wallet: $e')),
                  );
                  controller.isLoadingSubmit.value = false;
                } finally {
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pop();
                  controller.isLoadingSubmit.value = false;
                }                                        
              },
              onCancelPressed: () {                                        
                Navigator.of(context).pop();
                controller.isLoadingSubmit.value = false;
              },
            );     
            //controller.submitForm();
         // }
        },
      ),
    );
  }
   void _navigateToQRScanPage(CreateWalletWithContractController controller, BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => QRScanPage(
          showDialogOnScan: false,                  
          onScanResult: (result) {
            controller.contractController.text = result;
            controller.updateContractInfomation();     
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
