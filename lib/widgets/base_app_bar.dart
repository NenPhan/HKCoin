import 'package:flutter/material.dart';
import 'package:hkcoin/core/config/app_theme.dart';
import 'package:hkcoin/gen/assets.gen.dart';

class BaseAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool isBackEnabled;
  final int? cartCount;
  final Widget? actionWidget;

  final Color? backgroundColor;
  const BaseAppBar({
    super.key,
    this.title,
    this.isBackEnabled = true,
    this.cartCount,
    this.backgroundColor,
    this.actionWidget,
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
          isBackEnabled
              ? IconButton(
                icon: const Icon(Icons.arrow_back_ios, size: 32),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
              : const SizedBox(),
          Text(title ?? "", style: textTheme(context).titleMedium),
          // if (actionWidget != null) actionWidget!,
          const Spacer(),
          Hero(
            tag: "main-logo",
            child: Assets.icons.hkcLogoIcon.image(height: 50),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
