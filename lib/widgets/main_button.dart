import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hkcoin/core/config/app_theme.dart';
import 'package:hkcoin/widgets/loading_widget.dart';

class MainButton extends StatefulWidget {
  const MainButton({
    super.key,
    this.isLoading = false,
    required this.text,
    required this.onTap,
    this.width,
  });
  final bool isLoading;
  final String text;
  final VoidCallback onTap;
  final double? width;

  @override
  State<MainButton> createState() => _MainButtonState();
}

class _MainButtonState extends State<MainButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: 60,
      child: ElevatedButton(
        onPressed: () {
          widget.onTap();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
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
                : Text(tr(widget.text), style: textTheme(context).titleSmall),
      ),
    );
  }
}
