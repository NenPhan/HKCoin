import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hkcoin/localization/localization_context_extension.dart';

class MainTextField extends StatefulWidget {
  const MainTextField({
    super.key,
    this.controller,
    this.label,
    this.hintText,
    this.prefixIcon,
    this.suffixWidget,
    this.obscureText = false,
    this.validator,
    this.isRequired = true,
    this.autofocus = false,
    this.readOnly = false,
    this.keyboardType,
    this.onChanged,
    this.onEditingComplete,
    this.minLines = 1,
    this.maxLines = 1,
    this.enableSelectOnMouseDown = false,
    this.isNumberOnly = false,
    this.inputFormatters,
    this.textInputAction,
  });

  final TextEditingController? controller;
  final String? label;
  final String? hintText;
  final bool obscureText;
  final bool isRequired;
  final bool readOnly;
  final bool autofocus;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final Function(String)? onChanged;
  final VoidCallback? onEditingComplete;
  final int minLines;
  final int maxLines;
  final bool enableSelectOnMouseDown;
  final bool isNumberOnly;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? suffixWidget;
  final Widget? prefixIcon;
  final TextInputAction? textInputAction;

  @override
  State<MainTextField> createState() => _MainTextFieldState();
}

class _MainTextFieldState extends State<MainTextField>
    with SingleTickerProviderStateMixin {
  bool obscureText = false;
  bool isFirstTap = true;

  final FocusNode _focusNode = FocusNode();

  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    obscureText = widget.obscureText;

    _focusNode.addListener(() => setState(() {}));

    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 450),
      vsync: this,
    );

    _shakeAnimation = Tween<double>(begin: 0, end: 8)
        .chain(CurveTween(curve: Curves.elasticIn))
        .animate(_shakeController);
  }

  @override
  void dispose() {
    _shakeController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _triggerShake() {
    _shakeController.forward(from: 0);
  }

  OutlineInputBorder _border(Color color, {double width = 1.2}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: color, width: width),
    );
  }

  @override
  Widget build(BuildContext context) {
    // -------------------------------------------------------
    // 🌙 DARK THEME — luôn sử dụng màu dark mặc định
    // -------------------------------------------------------
    const textColor = Colors.white;
    const hintColor = Colors.white70;
    final fillColor = Colors.white.withOpacity(0.08);

    final borderColor =
        _focusNode.hasFocus ? Colors.blueAccent : Colors.white24;

    return AnimatedBuilder(
      animation: _shakeController,
      builder: (context, child) {
        return Transform.translate(
          offset:
              Offset(_shakeAnimation.value * sin(DateTime.now().millisecond), 0),
          child: child,
        );
      },
      child: AnimatedScale(
        scale: _focusNode.hasFocus ? 1.02 : 1.0,
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        child: TextFormField(
          controller: widget.controller,
          focusNode: _focusNode,
          autofocus: widget.autofocus,
          obscureText: widget.suffixWidget != null ? false : obscureText,
          readOnly: widget.readOnly,
          keyboardType: widget.keyboardType,
          style: const TextStyle(
            color: textColor,
            fontSize: 16,
          ),
          minLines: widget.minLines,
          maxLines: widget.maxLines,
          textInputAction: widget.textInputAction ?? TextInputAction.done,

          autovalidateMode: AutovalidateMode.onUserInteraction,

          onEditingComplete: () {
            widget.onEditingComplete?.call();
            if (widget.onEditingComplete == null) _focusNode.unfocus();
          },

          validator: (value) {
            final error = widget.validator?.call(value);
            if (error != null) _triggerShake();
            return error;
          },

          onChanged: widget.onChanged,

          decoration: InputDecoration(
            filled: true,
            fillColor: fillColor,
            label: _buildLabel(textColor),
            hintText: context.tr(widget.hintText ?? widget.label ?? ""),
            hintStyle: const TextStyle(color: hintColor),

            prefixIcon: _buildPrefixIcon(),
            suffixIcon: _buildSuffixIcon(hintColor),

            enabledBorder: _border(Colors.white24),
            focusedBorder: _border(Colors.blueAccent, width: 1.6),
            errorBorder: _border(Colors.redAccent),
            focusedErrorBorder:
                _border(Colors.redAccent.withOpacity(0.8), width: 1.5),

            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          ),
        ),
      ),
    );
  }

  // LABEL
  Widget? _buildLabel(Color color) {
    if (widget.label == null) return null;
    return RichText(
      text: TextSpan(
        text: context.tr(widget.label!),
        style: TextStyle(color: color, fontSize: 15),
        children: [
          if (widget.isRequired)
            const TextSpan(
              text: " *",
              style: TextStyle(color: Colors.redAccent),
            ),
        ],
      ),
    );
  }

  // PREFIX ICON
  Widget? _buildPrefixIcon() {
    if (widget.prefixIcon == null) return null;
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 6),
      child: widget.prefixIcon!,
    );
  }

  // SUFFIX ICON
  Widget? _buildSuffixIcon(Color color) {
    if (widget.suffixWidget != null) {
      return Padding(
        padding: const EdgeInsets.only(right: 8),
        child: widget.suffixWidget!,
      );
    }

    if (!widget.obscureText) return null;

    return GestureDetector(
      onTap: () {
        obscureText = !obscureText;
        setState(() {});
      },
      child: Icon(
        obscureText ? Icons.visibility : Icons.visibility_off,
        color: color,
      ),
    );
  }
}
