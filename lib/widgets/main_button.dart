import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hkcoin/core/config/app_theme.dart';
import 'package:hkcoin/core/presentation/widgets/spacing.dart';
import 'package:hkcoin/widgets/disable_widget.dart';
import 'package:hkcoin/widgets/loading_widget.dart';

class MainButton extends StatefulWidget {
  const MainButton({
    super.key,
    this.isLoading = false,
    this.enable = true,
    required this.text,
    required this.onTap,
    this.width,
    this.icon,
  });
  final bool isLoading;
  final bool enable;
  final String text;
  final VoidCallback onTap;
  final double? width;
  final Widget? icon;

  @override
  State<MainButton> createState() => _MainButtonState();
}

class _MainButtonState extends State<MainButton> {
  @override
  Widget build(BuildContext context) {
    return DisableWidget(
      disable: !widget.enable,
      child: SizedBox(
        width: widget.width,
        height: 50,
        child: ElevatedButton(
          onPressed: () {
            FocusManager.instance.primaryFocus?.unfocus();
            widget.onTap();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.amber[900],
            padding: EdgeInsets.symmetric(
              // vertical: scrSize(context).height * 0.02,
              horizontal: scrSize(context).width * 0.03,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child:
              widget.isLoading
                  ? const LoadingWidget()
                  : SpacingRow(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: scrSize(context).width * 0.02,
                    children: [
                      if (widget.icon != null) widget.icon!,
                      Text(
                        context.tr(widget.text),
                        style: textTheme(context).titleSmall,
                      ),
                    ],
                  ),
        ),
      ),
    );
  }
}
