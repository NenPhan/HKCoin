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
    this.onFieldSubmitted,
    this.focusNode,
    this.enableFill = false,
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
  final Function(String)? onFieldSubmitted;
  final FocusNode? focusNode;
  final bool enableFill;

  @override
  State<MainTextField> createState() => _MainTextFieldState();
}

class _MainTextFieldState extends State<MainTextField> {
  bool obscureText = false;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    obscureText = widget.obscureText;
    _focusNode.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  OutlineInputBorder _border(Color color, {double width = 1.2}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(18),
      borderSide: BorderSide(color: color, width: width),
    );
  }

  OutlineInputBorder _focusedBorder(BuildContext context) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(18),
      borderSide: BorderSide(
        width: 1.6,
        color: Theme.of(context).colorScheme.primary, // ⭐ màu primary
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final textColor = isDark ? Colors.white : Colors.black;
    final hintColor = isDark ? Colors.white60 : Colors.black54;

    final fillColor =
        isDark
            ? Colors.white.withOpacity(0.08)
            : Colors.black.withOpacity(0.05);

    final borderColor =
        _focusNode.hasFocus
            ? Colors.blueAccent
            : (isDark ? Colors.white24 : Colors.black26);

    return AnimatedScale(
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
        inputFormatters: widget.inputFormatters,
        style: TextStyle(color: textColor, fontSize: 16),
        minLines: widget.minLines,
        maxLines: widget.maxLines,
        textInputAction: widget.textInputAction ?? TextInputAction.done,
        onFieldSubmitted: widget.onFieldSubmitted,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        onEditingComplete: () {
          widget.onEditingComplete?.call();
          if (widget.onEditingComplete == null) _focusNode.unfocus();
        },
        validator: widget.validator,
        onChanged: widget.onChanged,
        decoration: InputDecoration(
          filled: widget.enableFill,
          fillColor: widget.enableFill ? fillColor : null,
          label: _buildLabel(textColor),
          hintText: context.tr(widget.hintText ?? widget.label ?? ""),
          hintStyle: TextStyle(color: hintColor),
          prefixIcon: _buildPrefixIcon(),
          enabledBorder: _border(borderColor),
          focusedBorder: _focusedBorder(context),
          errorBorder: _border(Colors.redAccent),
          focusedErrorBorder: _border(Colors.redAccent, width: 1.5),
          suffixIcon: _buildSuffixIcon(hintColor),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 15,
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
            const TextSpan(text: " *", style: TextStyle(color: Colors.red)),
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
        setState(() => obscureText = !obscureText);
      },
      child: Icon(
        obscureText ? Icons.visibility : Icons.visibility_off,
        color: color,
      ),
    );
  }

  // BORDER GRADIENT
  InputBorder _gradientBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(width: 1.6, color: Colors.transparent),
    );
  }
}
