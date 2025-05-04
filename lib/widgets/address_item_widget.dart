import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/state_manager.dart';
import 'package:hkcoin/core/config/app_theme.dart';
import 'package:hkcoin/core/presentation/widgets/spacing.dart';
import 'package:hkcoin/data.models/address.dart';
import 'package:hkcoin/presentation.pages/address_list_page.dart';
import 'package:hkcoin/widgets/custom_icon_button.dart';

class AddressItemWidget extends StatelessWidget {
  const AddressItemWidget({
    super.key,
    required this.address,
    this.isSelected = false,
    required this.onSelect,
  });
  final Address address;
  final bool isSelected;
  final Function(int? id) onSelect;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onSelect(address.id);
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
                          isSelected ? Colors.deepOrange : Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
              SizedBox(width: scrSize(context).width * 0.02),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
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
                      address.address1 ?? "",
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
