import 'package:hkcoin/localization/localization_context_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hkcoin/core/config/app_theme.dart';
import 'package:hkcoin/gen/assets.gen.dart';
import 'package:hkcoin/presentation.pages/home_page.dart';

class BaseAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool isBackEnabled;
  final bool enableHomeButton;
  final Widget? actionWidget;
  final Color? backgroundColor;
  final bool centerTitle;
  final Color? titleColor;
  final Alignment actionAlignment;

  const BaseAppBar({
    super.key,
    this.title,
    this.isBackEnabled = true,
    this.enableHomeButton = true,
    this.actionWidget,
    this.backgroundColor,
    this.centerTitle = false,
    this.titleColor,
    this.actionAlignment = Alignment.centerRight,
  });

  @override
  Widget build(BuildContext context) {
    final double topInset = MediaQuery.of(context).padding.top;
    final Color resolvedTitleColor =
        titleColor ??
        Theme.of(context).appBarTheme.titleTextStyle?.color ??
        Colors.white;
    return Container(
      color: backgroundColor ?? Colors.grey.shade900,
      padding: EdgeInsets.fromLTRB(12, topInset + 8, 12, 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ---- LEFT ----
          SizedBox(
            width: 48,
            child:
                isBackEnabled
                    ? IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios_new,
                        size: 22,
                        color: resolvedTitleColor,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    )
                    : const SizedBox(),
          ),

          // ---- TITLE ----
          Expanded(
            child: Text(
              title != null ? context.tr(title!) : "",
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: textTheme(context).titleMedium?.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: resolvedTitleColor,
              ),
            ),
          ),

          // ---- ACTION ----
          SizedBox(
            // width: 70,
            child: Align(
              alignment: actionAlignment, // ✅ GIỜ MỚI CÓ TÁC DỤNG
              child:
                  actionWidget ??
                  GestureDetector(
                    onTap: () {
                      if (enableHomeButton) {
                        Get.offNamedUntil(HomePage.route, (route) => false);
                      }
                    },
                    child: Hero(
                      tag: "main-logo",
                      child: Assets.icons.hkcLogoIcon.image(height: 28),
                    ),
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
