import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/state_manager.dart';
import 'package:hkcoin/core/config/app_theme.dart';
import 'package:hkcoin/core/presentation/widgets/spacing.dart';
import 'package:hkcoin/presentation.pages/address_list_page.dart';

class AddressWidget extends StatelessWidget {
  const AddressWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(AddressListPage.route);
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(scrSize(context).width * 0.03),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey[900],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(Icons.location_on, color: Colors.deepOrange),
            SizedBox(width: scrSize(context).width * 0.02),
            Expanded(
              child: Column(
                children: [
                  SpacingRow(
                    spacing: scrSize(context).width * 0.02,
                    children: [
                      Text(
                        "Name Name Name",
                        style: textTheme(context).bodyLarge,
                      ),
                      Text(
                        "0123456789",
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
            const Icon(Icons.arrow_forward_ios, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
