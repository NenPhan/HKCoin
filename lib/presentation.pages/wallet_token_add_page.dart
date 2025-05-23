import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hkcoin/core/config/app_theme.dart';
import 'package:hkcoin/core/presentation/widgets/spacing.dart';
import 'package:hkcoin/presentation.controllers/add_wallet_token_controller.dart';
import 'package:hkcoin/widgets/base_app_bar.dart';
import 'package:hkcoin/widgets/custom_drop_down_button.dart';
import 'package:hkcoin/widgets/main_text_field.dart';

class AddWalletTokenPage extends StatefulWidget {
  const AddWalletTokenPage({super.key});
  static String route = "/add-wallet-token";

  @override
  State<AddWalletTokenPage> createState() =>
      _AddWalletTokenPageState();
}

class _AddWalletTokenPageState
    extends State<AddWalletTokenPage> {
  final AddWalletTokenController controller = Get.put(
    AddWalletTokenController(),
  );

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GetBuilder<AddWalletTokenController>(
      id: "add-wallet-token-page",
      builder: (controller) {
        return Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                const BaseAppBar(
                  title: "Account.WalletToken.Token.Create",
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
                                                    .aviableChainNetworks,
                                            isRequired: true,
                                            selectedValue:
                                                controller
                                                    .selectedChainNetwork,
                                            title:
                                                "Account.WalletToken.Token.Fields.ChainNetwork",
                                            onChanged: (p0) {
                                              controller.selectedChainNetwork = p0;        
                                              controller.validate();                                          
                                            },                                          
                                          ),                                         
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                MainTextField(
                                  controller: controller.tokenAddressController,
                                  label: tr("Account.WalletToken.Token.Fields.TokenAddress"),                                                                                                                                                                     
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return tr("Account.WalletToken.Token.Fields.TokenAddress.Requird");
                                    }                                  
                                    return null;
                                  },
                                  onChanged: (p0) => controller.validate(),
                                ),                                
                                _buildActionButton(
                                  size,
                                  tr("Common.Save"),
                                  Icons.save,
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
          //if(controller.canSave.value){
            controller.submitAddToken();
          //}          
        },
      ),
    );
  }
}
