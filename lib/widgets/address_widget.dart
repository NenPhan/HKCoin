import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/state_manager.dart';
import 'package:hkcoin/core/config/app_theme.dart';
import 'package:hkcoin/core/presentation/widgets/spacing.dart';
import 'package:hkcoin/data.models/address.dart';
import 'package:hkcoin/presentation.pages/address_list_page.dart';

class AddressWidget extends StatelessWidget {
  const AddressWidget({super.key, required this.address, this.onChanged});
  final Address? address;
  final Function? onChanged;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(AddressListPage.route, arguments: address?.id)?.then((
          value,
        ) {
          onChanged?.call();
        });
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(scrSize(context).width * 0.03),
        margin: EdgeInsets.symmetric(horizontal: scrSize(context).width * 0.03),
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
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SpacingRow(
                    spacing: scrSize(context).width * 0.02,
                    children: [
                      Text(
                        (address?.lastName ?? "") +
                            (address?.firstName == null
                                ? ""
                                : " ${address!.firstName!}"),
                        style: textTheme(context).bodyLarge,
                      ),
                      Text(
                        address?.phoneNumber ?? "",
                        style: textTheme(
                          context,
                        ).bodySmall?.copyWith(color: Colors.grey[300]),
                      ),
                    ],
                  ),
                  Text(
                    address?.address1 ?? "",
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
