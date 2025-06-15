import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hkcoin/core/config/app_theme.dart';
import 'package:hkcoin/core/extensions/extensions.dart';

class MainTextField extends StatefulWidget {
  const MainTextField({
    super.key,
    this.controller,
    this.label,
    this.hintText,
    this.obscureText = false,
    this.validator,
    this.isRequired = true,
    this.autofocus = false,
    this.readOnly = false,
    this.keyboardType,
    this.onChanged,
    this.minLines = 1, // Thêm minLines
    this.maxLines = 1, // Thêm
    this.enableSelectOnMouseDown = false,
    this.isNumberOnly = false,
    this.inputFormatters,
  });
  final TextEditingController? controller;
  final String? label;
  final String? hintText;
  final bool obscureText;
  final String? Function(String?)? validator;
  final bool isRequired;
  final bool readOnly;
  final bool autofocus;
  final TextInputType? keyboardType;
  final Function(String)? onChanged;
  final int minLines; // Số dòng tối thiểu
  final int maxLines; // Số dòng tối đa
  final bool enableSelectOnMouseDown;
  final bool isNumberOnly;
  final List<TextInputFormatter>? inputFormatters;

  @override
  State<MainTextField> createState() => _MainTextFieldState();
}

class _MainTextFieldState extends State<MainTextField> {
  bool obscureText = false;
  bool isFirstTap = true;
  final FocusNode _focusNode = FocusNode();
  @override
  void initState() {
    obscureText = widget.obscureText;
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus && widget.enableSelectOnMouseDown) {
        isFirstTap = true; // Đặt lại khi mất focus
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      style: const TextStyle(color: Colors.white),
      obscureText: obscureText,
      autofocus: widget.autofocus,
      keyboardType: widget.keyboardType,
      readOnly: widget.readOnly,
      minLines: widget.minLines, // Truyền minLines
      maxLines: widget.maxLines, //
      onTap:
          () => {
            if (widget.enableSelectOnMouseDown && widget.controller != null)
              {
                if (isFirstTap)
                  {
                    widget.controller!
                        .selectAll(), // Chọn toàn bộ văn bản lần đầu
                    isFirstTap = false, // Đánh dấu không phải lần đầu
                  },
              },
          },
      inputFormatters:
          widget.readOnly
              ? null
              : widget.isNumberOnly
              ? (widget.inputFormatters ??
                  [
                    FilteringTextInputFormatter.allow(
                      RegExp(r'^\d*\.?\d{0,2}'),
                    ),
                  ])
              : null,
      decoration: InputDecoration(
        hintText: context.tr(widget.hintText ?? widget.label ?? ""),
        label:
            widget.label == null
                ? null
                : RichText(
                  text: TextSpan(
                    text: context.tr(widget.label!),
                    style: textTheme(context).bodyMedium,
                    children: [
                      if (widget.isRequired)
                        TextSpan(
                          text: "*",
                          style: textTheme(
                            context,
                          ).titleMedium?.copyWith(color: Colors.red),
                        ),
                    ],
                  ),
                ),
        border: InputBorder.none,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 20,
        ),
        suffixIcon:
            !widget.obscureText
                ? null
                : GestureDetector(
                  onTap: () {
                    if (widget.obscureText) {
                      obscureText = !obscureText;
                      setState(() {});
                    }
                  },
                  child: Icon(
                    obscureText ? Icons.visibility : Icons.visibility_off,
                  ),
                ),
      ),
      validator: (widget.validator),
      onChanged: widget.onChanged,
    );
  }
}
