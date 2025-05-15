import 'package:flutter/material.dart';
import 'package:hkcoin/core/config/app_theme.dart';

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

  @override
  State<MainTextField> createState() => _MainTextFieldState();
}

class _MainTextFieldState extends State<MainTextField> {
  bool obscureText = false;

  @override
  void initState() {
    obscureText = widget.obscureText;
    super.initState();
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
      decoration: InputDecoration(
        hintText: widget.hintText ?? widget.label,
        label:
            widget.label == null
                ? null
                : RichText(
                  text: TextSpan(
                    text: widget.label,
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
      validator: widget.validator,
      onChanged: widget.onChanged,
    );
  }
}
