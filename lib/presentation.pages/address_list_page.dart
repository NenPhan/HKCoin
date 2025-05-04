import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hkcoin/core/config/app_theme.dart';
import 'package:hkcoin/core/presentation/widgets/spacing.dart';
import 'package:hkcoin/presentation.controllers/address_list_controller.dart';
import 'package:hkcoin/widgets/address_item_widget.dart';
import 'package:hkcoin/widgets/base_app_bar.dart';
import 'package:hkcoin/widgets/loading_widget.dart';

class AddressListPage extends StatefulWidget {
  const AddressListPage({super.key});
  static String route = "/address-list";

  @override
  State<AddressListPage> createState() => _AddressListPageState();
}

class _AddressListPageState extends State<AddressListPage> {
  final AddressListController controller = Get.put(AddressListController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            BaseAppBar(title: tr("Account.CustomerAddresses")),
            Expanded(
              child: GetBuilder<AddressListController>(
                id: "address-list",
                builder: (controller) {
                  return controller.isLoading
                      ? const LoadingWidget()
                      : ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: controller.listAddress.length + 1,
                        itemBuilder: (context, index) {
                          if (index == controller.listAddress.length) {
                            return _buildAddButton();
                          }
                          var address = controller.listAddress[index];
                          return AddressItemWidget(address: address);
                        },
                      );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildAddButton() {
    return GestureDetector(
      onTap: () {
        // Get.toNamed(page)
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
        child: SpacingRow(
          spacing: scrSize(context).width * 0.02,
          children: [
            const Icon(Icons.add, color: Colors.deepOrange),
            Text(
              tr("Account.CustomerAddresses.AddNew"),
              style: textTheme(
                context,
              ).bodyMedium?.copyWith(color: Colors.deepOrange),
            ),
          ],
        ),
      ),
    );
  }
}
