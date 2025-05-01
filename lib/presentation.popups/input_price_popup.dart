import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:hkcoin/core/config/app_theme.dart';
import 'package:hkcoin/core/presentation/widgets/spacing.dart';
import 'package:hkcoin/widgets/main_text_field.dart';

class InputPricePopup extends StatefulWidget {
  const InputPricePopup({super.key, required this.onConfirm});
  final Function(int price) onConfirm;

  @override
  State<InputPricePopup> createState() => _InputPricePopupState();
}

class _InputPricePopupState extends State<InputPricePopup> {
  TextEditingController priceController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Material(
          child: Container(
            width: scrSize(context).width * 0.9,
            height: scrSize(context).height * 0.3,
            padding: EdgeInsets.symmetric(
              horizontal: scrSize(context).width * 0.05,
            ),
            child: SpacingColumn(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: scrSize(context).height * 0.02,
              children: [
                Text("Nhập mức đầu tư", style: textTheme(context).titleSmall),
                MainTextField(
                  autofocus: true,
                  keyboardType: TextInputType.number,
                  controller: priceController,
                  validator:
                      (value) =>
                          value != "" && value != null
                              ? null
                              : tr(
                                "Account.Register.Errors.UsernameIsNotProvided",
                              ),
                ),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(scrSize(context).width * 0.03),
                  child: ElevatedButton(
                    onPressed: () {
                      if (priceController.text.trim() != "") {
                        widget.onConfirm(
                          int.parse(priceController.text.trim()),
                        );
                        Get.back();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      tr("Enums.WalletPostingReason.Purchase"),
                      style: textTheme(context).titleSmall,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
