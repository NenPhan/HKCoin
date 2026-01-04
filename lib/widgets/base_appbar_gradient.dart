import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hkcoin/gen/assets.gen.dart';
import 'package:hkcoin/localization/localization_context_extension.dart';
import 'package:hkcoin/presentation.pages/home_page.dart';

class BaseAppBarGradient extends StatelessWidget
    implements PreferredSizeWidget {
  final String? title;
  final bool isBackEnabled;
  final bool enableHomeButton;
  final Widget? actionWidget;

  /// LEFT / CENTER / RIGHT cho actionWidget
  final Alignment actionAlignment;

  const BaseAppBarGradient({
    super.key,
    this.title,
    this.isBackEnabled = true,
    this.enableHomeButton = true,
    this.actionWidget,
    this.actionAlignment = Alignment.centerRight,
  });

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    return Container(
      height: preferredSize.height,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromARGB(255, 0, 0, 0),
            Color.fromARGB(255, 8, 8, 8),
            Color.fromARGB(255, 18, 18, 19),
          ],
        ),
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 2)),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ---------------- LEADING ----------------
          SizedBox(
            width: 48,
            child:
                isBackEnabled
                    ? IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.white,
                        size: 20,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    )
                    : const SizedBox(),
          ),

          // ---------------- TITLE ----------------
          Expanded(
            child: Center(
              child: Text(
                context.tr(title!),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          // ---------------- TRAILING (ACTION) ----------------
          Container(
            padding: const EdgeInsets.only(right: 0), // 🔥 ép sát cạnh phải
            child: Align(
              alignment: Alignment.centerRight,
              child: Row(
                mainAxisSize: MainAxisSize.min, // 🔥 chỉ rộng bằng nội dung
                children: [
                  if (enableHomeButton)
                    actionWidget ??
                        GestureDetector(
                          onTap: () {
                            Get.offNamedUntil(HomePage.route, (route) => false);
                          },
                          child: Hero(
                            tag: "main-logo",
                            child: Assets.icons.hkcLogoIcon.image(height: 32),
                          ),
                        ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
