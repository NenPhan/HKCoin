import 'package:hkcoin/data.models/withdrawals_investment.dart';
import 'package:hkcoin/localization/localization_context_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hkcoin/core/config/app_theme.dart';
import 'package:hkcoin/core/presentation/widgets/spacing.dart';
import 'package:hkcoin/core/utils.dart';
import 'package:hkcoin/presentation.controllers/withdrawal_investment_controller.dart';
import 'package:hkcoin/widgets/base_app_bar.dart';
import 'package:hkcoin/widgets/dropdown_popup.dart';
import 'package:hkcoin/widgets/loading_widget.dart';
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
                const BaseAppBar(title: "Account.WithDrawalRequest.Title"),
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
                                          PopupDropdown<AviablePackages>(
                                            title: context.tr(
                                              "Account.WithDrawalRequest.Package",
                                            ),
                                            items: controller.aviablePackages,
                                            selectedItem:
                                                controller.selectedPackage,
                                            placeholder: context.tr(
                                              "Account.WithDrawalRequest.Package.Selected",
                                            ),

                                            iconBuilder:
                                                (item) => const Icon(
                                                  Icons.monetization_on,
                                                ),

                                            itemLabel: (item) => item.name,
                                            validator: (value) {
                                              if (value == null) {
                                                return context.tr(
                                                  "Account.WithDrawalRequest.WithDrawalSwap.Required",
                                                );
                                              }
                                              return null;
                                            },
                                            onChanged: (value) {
                                              controller.onSwapChanged(value);
                                            },
                                            labelColor: Colors.white,
                                            textColor: Colors.white,
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
                                  controller:
                                      controller.amountSwapToHKCController,
                                  label:
                                      "Account.WithDrawalRequest.AmountToHKC",
                                  keyboardType: TextInputType.number,
                                  enableSelectOnMouseDown: true,
                                  isNumberOnly: true,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return context.tr("Field required");
                                    }
                                    if (double.tryParse(value) == null) {
                                      return context.tr("Invalid number");
                                    }
                                    return null;
                                  },
                                ),
                                MainTextField(
                                  controller:
                                      controller.walletTokenAddresController,
                                  label:
                                      "Account.WithDrawalRequest.WalletHKCTokenAddres",
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
                                _buildAlert(
                                  "Account.WithDrawalRequest.WalletHKCTokenAddres.Hint",
                                ),
                                MainTextField(
                                  controller: controller.commentController,
                                  isRequired: false,
                                  maxLines: 4,
                                  label: "Account.WithDrawalRequest.Comments",
                                ),
                                Visibility(
                                  visible: false, // Ẩn hoàn toàn
                                  maintainState:
                                      true, // Giữ trạng thái controller
                                  child: TextField(
                                    controller:
                                        controller.exchangeHKCController,
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
                                  context.tr("WithDrawalRequest.Submit"),
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
    return Obx(
      () => SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          icon: controller.isLoadingSubmit.value ? null : Icon(icon),
          label:
              controller.isLoadingSubmit.value
                  ? const LoadingWidget()
                  : Text(text),
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: size.height * 0.02),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: () {
            if (!controller.isLoadingSubmit.value) {
              controller.submitWithdrawal();
            }
          },
        ),
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
                  context.tr(alert),
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
