import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hkcoin/core/config/app_theme.dart';
import 'package:hkcoin/gen/assets.gen.dart';
import 'package:hkcoin/presentation.pages/home_page.dart';

class BaseAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool isBackEnabled;
  final bool enableHomeButton;
  final int? cartCount;
  final Widget? actionWidget;
  final Color? backgroundColor;
  final bool centerTitle; // Thêm thuộc tính mới để kiểm soát vị trí title

  const BaseAppBar({
    super.key,
    this.title,
    this.isBackEnabled = true,
    this.cartCount,
    this.backgroundColor,
    this.actionWidget,
    this.enableHomeButton = true,
    this.centerTitle = false, // Mặc định là false để giữ behavior cũ
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: scrSize(context).width * 0.03,
        vertical: scrSize(context).height * 0.015,
      ),
      color: backgroundColor ?? Colors.grey[900],
      child: Row(
        children: [
          if (isBackEnabled)
            IconButton(
              icon: const Icon(Icons.arrow_back_ios, size: 32),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          else
            const SizedBox(),                  
          // Spacer sẽ khác nhau tùy theo centerTitle
          if (centerTitle) ...[
            Expanded(
              child: Center(
                child: Text(
                  context.tr(title ?? ""),
                  style: textTheme(context).titleMedium,
                ),
              ),
            ),
          ] else ...[
          if (title != null) 
              Text(
                context.tr(title!),
                style: textTheme(context).titleMedium,
              ),
            if (actionWidget != null)              
              actionWidget!,
            const Expanded(child: SizedBox()),     
          ],

          // Logo bên phải
          Hero(
            tag: "main-logo",
            child: GestureDetector(
              onTap: () {
                if (enableHomeButton) {
                  Get.offNamedUntil(HomePage.route, (route) => false);
                }
              },
              child: Assets.icons.hkcLogoIcon.image(height: 35),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
