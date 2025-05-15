import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hkcoin/core/config/app_theme.dart';
import 'package:hkcoin/core/presentation/widgets/spacing.dart';
import 'package:hkcoin/core/utils.dart';
import 'package:hkcoin/presentation.controllers/withdrawal_investment_controller.dart';
import 'package:hkcoin/widgets/base_app_bar.dart';
import 'package:hkcoin/widgets/custom_drop_down_button.dart';
import 'package:hkcoin/widgets/main_text_field.dart';

class InvestmentWithdrawalContentPage extends StatefulWidget {
  const InvestmentWithdrawalContentPage({super.key});
  static String route = "/withdrawal-invertment";

  @override
  State<InvestmentWithdrawalContentPage> createState() =>
      _InvestmentWithdrawalContentPageState();
}

class _InvestmentWithdrawalContentPageState
    extends State<InvestmentWithdrawalContentPage> {
  final WithdrawalInvestmentController controller = Get.put(
    WithdrawalInvestmentController(),
  );

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GetBuilder<WithdrawalInvestmentController>(
      id: "withdrawal-investment-page",
      builder: (controller) {
        return Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                const BaseAppBar(
                  title: "Account.WithDrawalRequest.Title",
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
                                                controller.aviablePackages,
                                            isRequired: true,
                                            selectedValue:
                                                controller.selectedPackage,
                                            title:
                                                "Account.WithDrawalRequest.Package.Selected",
                                            onChanged: (p0) {
                                              controller.amountSwapToHKCController
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
                                  controller: controller.amountSwapToHKCController,
                                  label: tr("Account.WithDrawalRequest.AmountToHKC"),
                                  keyboardType: TextInputType.number,
                                  enableSelectOnMouseDown: true,                                  
                                  isNumberOnly: true,                                                                                              
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
                                  controller: controller.walletTokenAddresController,
                                  label: tr(
                                    "Account.WithDrawalRequest.WalletHKCTokenAddres",
                                  ),
                                  readOnly:
                                      controller
                                              .walletTokenAddresController
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
                                _buildAlert("Account.WithDrawalRequest.WalletHKCTokenAddres.Hint"),
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
                                            .exchangeHKCController,
                                  ),
                                ),
                                Visibility(
                                  visible: false, // Ẩn hoàn toàn
                                  maintainState:
                                      true, // Giữ trạng thái controller
                                  child: TextField(
                                    controller:
                                        controller.withdrawFeeController,
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
  _buildAlert(String alert) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Container(
              width: scrSize(context).width * 0.15,
              color: Colors.amber[900],
              child: const Center(
                child: Icon(Icons.priority_high_rounded, color: Colors.white),
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(scrSize(context).width * 0.03),
                color: Colors.white,
                child: Text(
                  tr(alert),
                  style: textTheme(
                    context,
                  ).bodyMedium?.copyWith(color: Colors.indigo[900]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
