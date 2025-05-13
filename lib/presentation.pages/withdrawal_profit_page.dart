import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hkcoin/core/config/app_theme.dart';
import 'package:hkcoin/core/presentation/widgets/spacing.dart';
import 'package:hkcoin/core/utils.dart';
import 'package:hkcoin/presentation.controllers/withdrawal_profit_controller.dart';
import 'package:hkcoin/widgets/disable_widget.dart';
import 'package:hkcoin/widgets/main_button.dart';
import 'package:hkcoin/widgets/main_text_field.dart';

class ProfitWithdrawalContentPage extends StatefulWidget {
  const ProfitWithdrawalContentPage({super.key});

  @override
  State<ProfitWithdrawalContentPage> createState() => _ProfitWithdrawalContentPageState();
}

class _ProfitWithdrawalContentPageState extends State<ProfitWithdrawalContentPage> {
  final WithdrawalProfitController controller = Get.put(WithdrawalProfitController());
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
      final theme = Theme.of(context);
    return GetBuilder<WithdrawalProfitController>(
      id: "withdrawal-profit-page",
      builder: (controller) {
        return Scaffold(
          body: SafeArea(
            child: Column(
              children: [                
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: scrSize(context).width * 0.03,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: SpacingColumn(
                              spacing: size.height * 0.01, 
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    tr("Account.Report.Shopping"),
                                    style: theme.textTheme.titleLarge?.copyWith(
                                      fontSize: size.width * 0.05,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.grey[300], // Using theme color
                                    ),
                                  ),
                                  Text(
                                    controller.withDrawalsProfit!.walletAmountProfits??"",
                                    style: theme.textTheme.titleLarge?.copyWith(
                                      fontSize: size.width * 0.05,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white, // Using theme color
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                            ),
                          ),
                          _buildAssetTab(
                              size: size,
                              content: [
                                _buildAssetItem(
                                  title: "Tiền mặt",
                                  amount: "1,000,000 VND",
                                  icon: Icons.money,
                                ),
                                _buildAssetItem(
                                  title: "Tiền điện tử",
                                  amount: "0.5 BTC",
                                  icon: Icons.currency_bitcoin,
                                ),
                              ],
                            ),
                          Form(
                            key: controller.formKey,
                            child: SpacingColumn(
                              spacing: 15,
                              children: [
                                const SizedBox(height: 20),
                                DisableWidget(
                                  child: MainTextField(
                                    controller: controller.amountController,
                                    label: tr("Account.Fields.Username"),
                                  ),
                                ),
                                // MainTextField(
                                //   controller: controller.fNameController,
                                //   label: tr("Account.Fields.FirstName"),
                                //   validator:
                                //       (value) => requiredValidator(
                                //         value,
                                //         "Account.Register.Errors.FirstNameIsNotProvided",
                                //       ),
                                // ),
                                // MainTextField(
                                //   controller: controller.lNameController,
                                //   label: tr("Account.Fields.LastName"),
                                //   validator:
                                //       (value) => requiredValidator(
                                //         value,
                                //         "Account.Register.Errors.LastNameIsNotProvided",
                                //       ),
                                // ),
                                // MainTextField(
                                //   controller: controller.emailController,
                                //   label: tr("Account.Login.Fields.Email"),
                                //   validator:
                                //       (value) => requiredValidator(
                                //         value,
                                //         "Account.Register.Errors.EmailIsNotProvided",
                                //       ),
                                // ),
                                // MainTextField(
                                //   controller: controller.phoneController,
                                //   label: tr("Account.Fields.Phone"),
                                //   validator:
                                //       (value) => requiredValidator(
                                //         value,
                                //         "Account.Register.Errors.PhoneIsNotProvided",
                                //       ),
                                // ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                          Obx(
                            () => MainButton(
                              //isLoading: controller.isLoadingSaveButton.value,
                              text: "Common.Save",
                              onTap: () async {
                                //await controller.updateCustomerInfo();
                              },
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
  Widget _buildAssetTab({
    required Size size,
    required List<Widget> content,
  }) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: size.width * 0.03,
        vertical: size.height * 0.02,
      ),
      child: Column(
        children: [
          ...content,
          SizedBox(height: size.height * 0.02),
          _buildActionButton(size, "Rút tiền", Icons.money_off),
          SizedBox(height: size.height * 0.01),
          _buildActionButton(size, "Nạp tiền", Icons.money),
        ],
      ),
    );
  }
  Widget _buildAssetItem({
    required String title,
    required String amount,
    required IconData icon,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(icon, size: 30, color: Colors.blue),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(amount),
        trailing: const Icon(Icons.chevron_right),
      ),
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
          // Xử lý khi nhấn nút
        },
      ),
    );
  }
}

  