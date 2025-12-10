import 'package:hkcoin/localization/localization_context_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hkcoin/core/config/app_theme.dart';
import 'package:hkcoin/core/presentation/widgets/spacing.dart';
import 'package:hkcoin/core/utils.dart';
import 'package:hkcoin/data.models/network.dart';
import 'package:hkcoin/presentation.controllers/create_wallet_contract_controller.dart';
import 'package:hkcoin/presentation.pages/qr_scan_page.dart';
import 'package:hkcoin/widgets/base_app_bar.dart';
import 'package:hkcoin/widgets/dropdown_popup.dart';
import 'package:hkcoin/widgets/main_button.dart';
import 'package:hkcoin/widgets/main_text_field.dart';

class AddWalletWithContractPage extends StatefulWidget {
  const AddWalletWithContractPage({super.key});
  static String route = "/add-wallet-with-contract";

  @override
  State<AddWalletWithContractPage> createState() =>
      _AddWalletWithContractPageState();
}

class _AddWalletWithContractPageState extends State<AddWalletWithContractPage> {
  final CreateWalletWithContractController controller = Get.put(
    CreateWalletWithContractController(),
  );
  @override
  void initState() {
    final args = Get.arguments as Map<String, dynamic>;
    if (args.isNotEmpty) {
      final walletAddress = args['walletAddress'];
      final id = args['id'];
      controller.walletId = id;
      controller.selectedWalletAddress = walletAddress;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CreateWalletWithContractController>(
      id: "add-wallet-contract-page",
      builder: (controller) {
        return Scaffold(
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildSubmitButton(controller),
          ),
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const BaseAppBar(title: "Account.wallet.withContract"),
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
                                const SizedBox(height: 15),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 8.0,
                                      ),
                                      child: Text(
                                        context.tr(
                                          "Account.wallet.withContract.NetWork",
                                        ),
                                        style: TextStyle(
                                          // Thêm style cho label nếu cần
                                        ),
                                      ),
                                    ),
                                    PopupDropdown<Network>(
                                      title: '',
                                      items: controller.listNetwork,
                                      itemLabel: (item) => item.name!,
                                      selectedItem: controller.selectNetwork,
                                      onChanged: (Network? network) {
                                        controller.selectNetwork = network;
                                        controller.update([
                                          'add-wallet-contract-page',
                                        ]);
                                      },
                                      validator: (val) {
                                        if (val == null) {
                                          return context.tr(
                                            'Account.wallet.withContract.NetWork.Required',
                                          );
                                        }
                                        return null;
                                      },
                                      iconBuilder:
                                          (item) => const Icon(Icons.wifi),
                                      textColor: Colors.white,
                                      titleColor: Colors.white,
                                      labelColor: Colors.white,
                                      placeholder:
                                          'Account.wallet.withContract.SelectNetWork',
                                      popupBackgroundColor:
                                          Colors.grey.shade900,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                Container(
                                  constraints: const BoxConstraints(
                                    minHeight: 60,
                                  ),
                                  child: Stack(
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // Label
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              bottom: 8.0,
                                              right: 40,
                                            ),
                                            child: Text(
                                              context.tr(
                                                "Account.wallet.withContract.ContractAddress",
                                              ),
                                              style: const TextStyle(
                                                // Thêm style cho label nếu cần
                                              ),
                                            ),
                                          ),
                                          MainTextField(
                                            controller:
                                                controller.contractController,
                                            hintText:
                                                "Account.wallet.withContract.ContractAddress",
                                            onChanged: (value) {
                                              controller
                                                  .updateContractInfomation();
                                              controller.update([
                                                'add-wallet-contract-page',
                                              ]);
                                            },
                                            validator:
                                                (value) => requiredValidator(
                                                  value,
                                                  "Account.wallet.withContract.ContractAddress.Required",
                                                ),
                                          ),
                                        ],
                                      ),

                                      // Icon scan ở bên phải label
                                      Positioned(
                                        right: 0,
                                        top: -12,
                                        child: IconButton(
                                          icon: const Icon(
                                            Icons.qr_code_scanner_outlined,
                                          ),
                                          onPressed:
                                              () => _navigateToQRScanPage(
                                                controller,
                                                context,
                                              ),
                                          tooltip: 'Quét QR',
                                        ),
                                      ),
                                    ],
                                  ),
                                  // child: Stack(
                                  //   children: [

                                  //     Padding(
                                  //       padding: const EdgeInsets.only(right: 40),
                                  //       child: MainTextField(
                                  //         controller: controller.contractController,
                                  //         label: tr("Account.wallet.withContract.ContractAddress"),
                                  //         onChanged: (value) {
                                  //           controller.updateContractInfomation();
                                  //           controller.update([
                                  //             'add-wallet-contract-page',
                                  //           ]);
                                  //         },
                                  //         validator: (value) => requiredValidator(
                                  //           value,
                                  //           "Account.wallet.withContract.ContractAddress.Required",
                                  //         ),
                                  //       ),
                                  //     ),
                                  //     Positioned(
                                  //       right: 8,
                                  //       top: 0,
                                  //       bottom: 0,
                                  //       child: Center(
                                  //         child: IconButton(
                                  //           icon: const Icon(Icons.qr_code_scanner),
                                  //           onPressed: () => _navigateToQRScanPage(controller, context),
                                  //           tooltip: 'Quét QR',
                                  //         ),
                                  //       ),
                                  //     ),
                                  //   ],
                                  // ),
                                ),
                                Visibility(
                                  visible:
                                      controller
                                          .contractController
                                          .text
                                          .isNotEmpty,
                                  maintainState: true,
                                  maintainSize: false,
                                  child: Column(
                                    children: [
                                      const SizedBox(height: 20),
                                      MainTextField(
                                        controller:
                                            controller.contractSymbolController,
                                        label:
                                            "Account.wallet.withContract.Symbol",                                        
                                      ),
                                    ],
                                  ),
                                ),
                                Visibility(
                                  visible:
                                      controller
                                          .contractController
                                          .text
                                          .isNotEmpty,
                                  maintainState: true,
                                  maintainSize: false,
                                  child: Column(
                                    children: [
                                      const SizedBox(height: 20),
                                      MainTextField(
                                        controller:
                                            controller
                                                .contractDecimalController,
                                        label: context.tr(
                                          "Account.wallet.withContract.Decimal",
                                        ),                                        
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSubmitButton(CreateWalletWithContractController controller) {
    return Obx(
      () => MainButton(
        isLoading: controller.isLoadingSubmit.value,
        width: double.infinity,
        text: "Common.Save",
        onTap: () async {
          // if (controller.formKey.currentState!.validate()) {
          // Đảm bảo loading hiển thị ngay lập tức
          controller.isLoadingSubmit.value = true;
          await Future.delayed(Duration.zero);
          controller.submitForm();
          // }
        },
      ),
    );
  }

  void _navigateToQRScanPage(
    CreateWalletWithContractController controller,
    BuildContext context,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (_) => QRScanPage(
              showDialogOnScan: false,
              onScanResult: (result) {
                controller.contractController.text = result;
                controller.updateContractInfomation();
                controller.update(['add-wallet-contract-page']);
                Navigator.of(context).pop();
              },
            ),
      ),
    );
  }
}
