import 'package:hkcoin/localization/localization_context_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ScreenPopup extends StatefulWidget {
  final Widget child;
  final String title;
  final Widget? leftIcon;
  final Widget? rightAction;
  final double heightFactor;
  final Color backgroundColor;
  final Color? headerColor;
  final double borderRadius;
  final bool isDismissible;
  final Color? titleColor;
  final Color? iconColor;
  final VoidCallback? onShow;
  final List<Widget>? footerButtons;

  const ScreenPopup({
    Key? key,
    required this.child,
    required this.title,
    this.leftIcon,
    this.rightAction,
    this.heightFactor = 0.5,
    this.backgroundColor = Colors.white,
    this.headerColor,
    this.borderRadius = 16.0,
    this.isDismissible = true,
    this.titleColor,
    this.iconColor,
    this.onShow,
    this.footerButtons = const [],
  }) : super(key: key);

  void show(BuildContext context) {
    Get.bottomSheet(
      this,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black54,
      isDismissible: isDismissible,
    );
  }

  @override
  State<ScreenPopup> createState() => _ScreenPopupState();
}

class _ScreenPopupState extends State<ScreenPopup> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onShow?.call();
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height * widget.heightFactor;

    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: height, minHeight: height),
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: widget.backgroundColor,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(widget.borderRadius),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max, // ✅ FIX
            children: [
              // ================= HEADER =================
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: widget.headerColor ?? widget.backgroundColor,
                  border: Border(
                    bottom: BorderSide(color: Colors.grey.shade200),
                  ),
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(widget.borderRadius),
                  ),
                ),
                child: Row(
                  children: [
                    widget.leftIcon != null
                        ? widget.iconColor != null
                            ? ColorFiltered(
                              colorFilter: ColorFilter.mode(
                                widget.iconColor!,
                                BlendMode.srcIn,
                              ),
                              child: widget.leftIcon,
                            )
                            : widget.leftIcon!
                        : IconButton(
                          icon: Icon(
                            Icons.close,
                            color: widget.iconColor ?? Colors.grey.shade600,
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                    Expanded(
                      child: Center(
                        child: Text(
                          context.tr(widget.title),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: widget.titleColor ?? Colors.grey.shade800,
                          ),
                        ),
                      ),
                    ),
                    widget.rightAction ?? const SizedBox(width: 48),
                  ],
                ),
              ),

              // ================= BODY (FIX) =================
              Expanded(
                child: widget.child, // ❗ KHÔNG SCROLL Ở ĐÂY
              ),

              // ================= FOOTER =================
              if (widget.footerButtons != null &&
                  widget.footerButtons!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ...widget.footerButtons!
                          .expand(
                            (button) => [button, const SizedBox(width: 8)],
                          )
                          .toList()
                        ..removeLast(),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
