import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:hkcoin/core/config/app_theme.dart';
import 'package:hkcoin/core/presentation/widgets/spacing.dart';

class DeleteCartPopup extends StatefulWidget {
  const DeleteCartPopup({super.key, required this.onConfirm});
  final Function onConfirm;

  @override
  State<DeleteCartPopup> createState() => _DeleteCartPopupState();
}

class _DeleteCartPopupState extends State<DeleteCartPopup> {
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
              spacing: scrSize(context).height * 0.01,
              children: [
                Text(
                  context.tr("ShoppingCart.Deleted"),
                  style: textTheme(context).titleSmall,
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      widget.onConfirm();
                      Get.back();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      context.tr("Common.Apply"),
                      style: textTheme(context).titleSmall,
                    ),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Get.back();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      context.tr("Common.Back"),
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
