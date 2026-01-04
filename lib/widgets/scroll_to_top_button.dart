import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hkcoin/localization/localization_context_extension.dart';

class ScrollToTopButton extends StatefulWidget {
  final ScrollController controller;

  // UI
  final String? label;
  final Color backgroundColor;
  final Color textColor;
  final Color iconColor;
  final List<BoxShadow>? boxShadow;

  // Size / style
  final double scale;
  final double borderRadius;
  final EdgeInsets padding;

  // Position
  final double bottom;
  final double right;

  // Behavior
  final double showOffset; // offset để hiện button

  const ScrollToTopButton({
    super.key,
    required this.controller,
    this.label,
    this.backgroundColor = const Color(0xCC000000),
    this.textColor = Colors.white,
    this.iconColor = Colors.white,
    this.boxShadow,
    this.scale = 1.0,
    this.borderRadius = 999,
    this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    this.bottom = 24,
    this.right = 20,
    this.showOffset = 300,
  });

  @override
  State<ScrollToTopButton> createState() => _ScrollToTopButtonState();
}

class _ScrollToTopButtonState extends State<ScrollToTopButton> {
  bool _visible = false;
  double _lastOffset = 0;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onScroll);
  }

  void _onScroll() {
    final offset = widget.controller.offset;

    // Scroll xuống → hiện
    if (offset > _lastOffset && offset > widget.showOffset) {
      if (!_visible) setState(() => _visible = true);
    }

    // Scroll lên → ẩn
    if (offset < _lastOffset) {
      if (_visible) setState(() => _visible = false);
    }

    _lastOffset = offset;
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onScroll);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
      bottom: _visible ? widget.bottom : -90,
      right: widget.right,
      child: AnimatedScale(
        scale: _visible ? widget.scale : 0.8,
        duration: const Duration(milliseconds: 280),
        curve: Curves.elasticOut,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            onTap: () {
              HapticFeedback.lightImpact();

              widget.controller.animateTo(
                0,
                duration: const Duration(milliseconds: 450),
                curve: Curves.easeOutCubic,
              );
            },
            child: Container(
              padding: widget.padding,
              decoration: BoxDecoration(
                color: widget.backgroundColor,
                borderRadius: BorderRadius.circular(widget.borderRadius),
                boxShadow:
                    widget.boxShadow ??
                    const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.keyboard_arrow_up,
                    color: widget.iconColor,
                    size: 20,
                  ),
                  if (widget.label != null) ...[
                    const SizedBox(width: 6),
                    Text(
                      context.tr(widget.label ?? "Lên đầu"),
                      style: TextStyle(
                        color: widget.textColor,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
