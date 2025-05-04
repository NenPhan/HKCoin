import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/state_manager.dart';
import 'package:hkcoin/core/config/app_theme.dart';
import 'package:hkcoin/core/presentation/widgets/spacing.dart';
import 'package:hkcoin/data.models/address.dart';
import 'package:hkcoin/presentation.pages/address_list_page.dart';
import 'package:hkcoin/widgets/custom_icon_button.dart';

class AddressItemWidget extends StatelessWidget {
  const AddressItemWidget({super.key, required this.address});
  final Address address;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(AddressListPage.route);
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(scrSize(context).width * 0.03),
        margin: EdgeInsets.fromLTRB(
          scrSize(context).width * 0.03,
          scrSize(context).width * 0.03,
          scrSize(context).width * 0.03,
          0,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey[900],
        ),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 17,
                height: 17,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border.all(color: Colors.deepOrange),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color:
                          address.isDefault ?? false
                              ? Colors.deepOrange
                              : Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
              SizedBox(width: scrSize(context).width * 0.02),
              Expanded(
                child: Column(
                  children: [
                    SpacingRow(
                      spacing: scrSize(context).width * 0.02,
                      children: [
                        Text(
                          "${address.lastName ?? ""}${address.firstName == null ? "" : " ${address.firstName!}"}",
                          style: textTheme(context).bodyLarge,
                        ),
                        Text(
                          address.phoneNumber ?? "",
                          style: textTheme(
                            context,
                          ).bodySmall?.copyWith(color: Colors.grey[300]),
                        ),
                      ],
                    ),
                    Text(
                      "Bến thuyền qua Mars Venus, 9A Đ. Trần Văn Trà, Tân Phú, Quận 7, HCM, VN",
                      style: textTheme(
                        context,
                      ).bodyMedium?.copyWith(color: Colors.grey[300]),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  CustomIconButton(
                    icon: const Icon(Icons.edit, size: 20),
                    onTap: () {},
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
