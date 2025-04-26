import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hkcoin/core/config/app_theme.dart';
import 'package:hkcoin/core/presentation/storage.dart';
import 'package:hkcoin/presentation.controllers/profile_controller.dart';
import 'package:hkcoin/presentation.pages/login_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    Get.put(ProfileController());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
      id: "profile",
      builder: (controller) {
        return Scaffold(
          body: Padding(
            padding: EdgeInsets.all(scrSize(context).width * 0.03),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    tr("Profile"),
                    style: textTheme(context).titleLarge,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  controller.customerInfo?.fullName ?? "",
                  style: textTheme(context).titleLarge,
                ),
                Text(
                  controller.customerInfo?.email ?? "",
                  style: textTheme(context).bodyMedium,
                ),
                Text(
                  "0${controller.customerInfo?.phone ?? ""}",
                  style: textTheme(context).bodyMedium,
                ),
                const SizedBox(height: 50),
                Center(
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Storage().dispose();
                        Get.offAllNamed(LoginPage.route);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Logout',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
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
}
