import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hkcoin/core/config/app_theme.dart';
import 'package:hkcoin/core/presentation/storage.dart';
import 'package:hkcoin/core/presentation/widgets/spacing.dart';
import 'package:hkcoin/presentation.controllers/profile_controller.dart';
import 'package:hkcoin/presentation.pages/login_page.dart';
import 'package:hkcoin/widgets/expandale_button.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  List items = [
    {"name": "Rút tiền", "icon": Icons.local_atm},
    {"name": "Đội của tôi", "icon": Icons.people_alt_outlined},
    {
      "name": "Tài Khoản",
      "items": [
        {"name": "Thông tin khách hàng", "icon": Icons.person},
        {"name": "Gói đầu tư của tôi", "icon": Icons.description},
      ],
    },
  ];
  @override
  void initState() {
    Get.put(ProfileController());
    super.initState();
  }

  _buildButton(Map<String, dynamic> item, {VoidCallback? onTap}) {
    return InkWell(
      onTap: () {
        onTap?.call();
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: scrSize(context).height * 0.02),
        child: SpacingRow(
          spacing: scrSize(context).width * 0.05,
          children: [
            Icon(item["icon"], size: scrSize(context).width * 0.07),
            Text(tr(item["name"]), style: textTheme(context).bodyLarge),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
      id: "profile",
      builder: (controller) {
        return Scaffold(
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    vertical: scrSize(context).height * 0.02,
                    horizontal: scrSize(context).width * 0.03,
                  ),
                  width: double.infinity,
                  height: scrSize(context).height * 0.15,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.black, Colors.deepOrange, Colors.black],
                      stops: [0.1, 0.4, 0.9],
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        controller.customerInfo?.fullName ?? "",
                        style: textTheme(context).titleLarge,
                      ),
                      Text(
                        controller.customerInfo?.email ?? "",
                        style: textTheme(context).bodyMedium,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(scrSize(context).width * 0.03),
                  child: Column(
                    children: [
                      ...List.generate(items.length, (index) {
                        if (items[index]["items"] != null) {
                          return ExpandaleButton(
                            title: items[index]["name"],
                            items: List.generate(items[index]["items"].length, (
                              index2,
                            ) {
                              return _buildButton(
                                items[index]["items"][index2],
                              );
                            }),
                          );
                        }
                        return _buildButton(items[index]);
                      }),
                      GetBuilder<ProfileController>(
                        id: "logout-button",
                        builder: (controller) {
                          return _buildButton(
                            {"name": "Account.Logout", "icon": Icons.logout},
                            onTap: () {
                              controller.logout(() {
                                Storage().dispose();
                                Get.offAllNamed(LoginPage.route);
                              });
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
