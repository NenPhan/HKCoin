import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:hkcoin/core/presentation/widgets/spacing.dart';
import 'package:hkcoin/core/utils.dart';
import 'package:hkcoin/presentation.controllers/add_address_controller.dart';
import 'package:hkcoin/widgets/base_app_bar.dart';
import 'package:hkcoin/widgets/main_text_field.dart';

class AddAddressPage extends StatefulWidget {
  const AddAddressPage({super.key});
  static String route = "/add-address";

  @override
  State<AddAddressPage> createState() => _AddAddressPageState();
}

class _AddAddressPageState extends State<AddAddressPage> {
  final AddAddressController controller = Get.put(AddAddressController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            BaseAppBar(title: tr("Account.CustomerAddresses")),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Form(
                      key: controller.formKey,
                      child: SpacingColumn(
                        spacing: 15,
                        children: [
                          const SizedBox(height: 20),
                          MainTextField(
                            controller: controller.fNameController,
                            label: tr("Account.Fields.FirstName"),
                            validator:
                                (value) => requiredValidator(
                                  value,
                                  "Account.Register.Errors.FirstNameIsNotProvided",
                                ),
                          ),
                          MainTextField(
                            controller: controller.lNameController,
                            label: tr("Account.Fields.LastName"),
                            validator:
                                (value) => requiredValidator(
                                  value,
                                  "Account.Register.Errors.LastNameIsNotProvided",
                                ),
                          ),
                        ],
                      ),
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
}
