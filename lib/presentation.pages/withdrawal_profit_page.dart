import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hkcoin/core/config/app_theme.dart';
import 'package:hkcoin/core/presentation/widgets/spacing.dart';
import 'package:hkcoin/core/utils.dart';
import 'package:hkcoin/presentation.controllers/withdrawal_profit_controller.dart';
import 'package:hkcoin/widgets/base_app_bar.dart';
import 'package:hkcoin/widgets/custom_drop_down_button.dart';
import 'package:hkcoin/widgets/main_text_field.dart';

class ProfitWithdrawalContentPage extends StatefulWidget {
  const ProfitWithdrawalContentPage({super.key});
  static String route = "/withdrawal-profit";

  @override
  State<ProfitWithdrawalContentPage> createState() =>
      _ProfitWithdrawalContentPageState();
}

class _ProfitWithdrawalContentPageState
    extends State<ProfitWithdrawalContentPage> {
  final WithdrawalProfitController controller = Get.put(
    WithdrawalProfitController(),
  );

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GetBuilder<WithdrawalProfitController>(
      id: "withdrawal-profit-page",
      builder: (controller) {
        return Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                const BaseAppBar(
                  title: "Account.WithDrawalRequest.Profits.Title",
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: scrSize(context).width * 0.03,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Form(
                            key: controller.formKey,
                            child: SpacingColumn(
                              spacing: 15,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                const SizedBox(height: 20),
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Stack(
                                        children: [
                                          CustomDropDownButton(
                                            items:
                                                controller
                                                    .aviableWithDrawalSwaps,
                                            isRequired: true,
                                            selectedValue:
                                                controller
                                                    .selectedWithDrawalSwap,
                                            title:
                                                "Account.WithDrawalRequest.WithDrawalSwap",
                                            onChanged: (p0) {
                                              controller.amountController
                                                  .clear();
                                              controller.isLoading.value
                                                  ? null // Vô hiệu hóa khi loading
                                                  : controller.onSwapChanged(
                                                    p0,
                                                  );
                                            },
                                          ),
                                          if (controller.isLoading.value)
                                            const Positioned(
                                              right: 10,
                                              top: 25,
                                              child: SizedBox(
                                                width: 20,
                                                height: 20,
                                                child:
                                                    CircularProgressIndicator(
                                                      strokeWidth: 2,
                                                    ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                MainTextField(
                                  controller: controller.amountController,
                                  label: tr("Account.WithDrawalRequest.Amount"),
                                  keyboardType: TextInputType.number,
                                  enableSelectOnMouseDown: true,
                                  onChanged: (value) {
                                    controller.updateAmountSwap();
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return tr("Field required");
                                    }
                                    if (double.tryParse(value) == null) {
                                      return tr("Invalid number");
                                    }
                                    return null;
                                  },
                                ),
                                MainTextField(
                                  controller: controller.amountSwapController,
                                  label: tr(
                                    "Account.WithDrawalRequest.Fields.AmountSwap",
                                  ),
                                  readOnly: true,
                                ),
                                Visibility(
                                  visible:
                                      controller
                                          .hiddenExchangePrice, // Ẩn nếu true
                                  maintainState: true,
                                  child: MainTextField(
                                    controller:
                                        controller.exchangePriceController,
                                    label: tr(
                                      "Account.WithDrawalRequest.TokenExchangePrice",
                                    ),
                                    readOnly: true,
                                  ),
                                ),
                                MainTextField(
                                  controller: controller.walletController,
                                  label: tr(
                                    "Account.WithDrawalRequest.WalletTokenAddresExt",
                                  ),
                                  readOnly:
                                      controller
                                              .walletController
                                              .text
                                              .isNotEmpty
                                          ? true
                                          : false,
                                  validator:
                                      (value) => requiredValidator(
                                        value,
                                        "Account.WithDrawalRequest.WalletTokenAddres.Requird",
                                      ),
                                ),
                                MainTextField(
                                  controller: controller.commentController,
                                  isRequired: false,
                                  maxLines: 4,
                                  label: tr(
                                    "Account.WithDrawalRequest.Comments",
                                  ),
                                ),
                                Visibility(
                                  visible: false, // Ẩn hoàn toàn
                                  maintainState:
                                      true, // Giữ trạng thái controller
                                  child: TextField(
                                    controller:
                                        controller
                                            .exchangePriceHiddenController,
                                  ),
                                ),
                                Visibility(
                                  visible: false, // Ẩn hoàn toàn
                                  maintainState:
                                      true, // Giữ trạng thái controller
                                  child: TextField(
                                    controller:
                                        controller.exchangeHKCHiddenController,
                                  ),
                                ),
                                Text(
                                  textAlign: TextAlign.left,
                                  controller.withdrawFeeHintController.text,
                                  style: textTheme(context).bodySmall,
                                ),
                                _buildActionButton(
                                  size,
                                  tr("WithDrawalRequest.Submit"),
                                  Icons.send,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
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

  Widget _buildActionButton(Size size, String text, IconData icon) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: Icon(icon),
        label: Text(text),
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: size.height * 0.02),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: () {
          controller.submitWithdrawal();
        },
      ),
    );
  }
}
