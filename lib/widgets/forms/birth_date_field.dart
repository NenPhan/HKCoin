import 'package:flutter/material.dart';
import 'package:hkcoin/core/extensions/date_time_extensions.dart';
import 'package:hkcoin/widgets/forms/main_text_field.dart';
import 'package:hkcoin/core/helper/date_mask_controller.dart';

class BirthDateField extends StatefulWidget {
  const BirthDateField({
    super.key,
    required this.controller,
    this.label,
    this.isRequired = true,
    this.firstDate,
    this.lastDate,
    this.prefixIcon,
  });

  final TextEditingController controller;
  final String? label;
  final bool isRequired;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final Widget? prefixIcon;

  @override
  State<BirthDateField> createState() => _BirthDateFieldState();
}

class _BirthDateFieldState extends State<BirthDateField> {
  final _mask = DateMaskController();

  @override
  void initState() {
    super.initState();
    _mask.attach(widget.controller);
  }

  Future<void> _openDatePicker(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate:
          widget.controller.text.toDate() ??
          DateTime.now().subtract(const Duration(days: 365 * 18)),
      firstDate: widget.firstDate ?? DateTime(1900),
      lastDate: widget.lastDate ?? DateTime.now(),
    );

    if (picked != null) {
      widget.controller.text =
          "${picked.day.toString().padLeft(2, '0')}/"
          "${picked.month.toString().padLeft(2, '0')}/"
          "${picked.year}";
    }
  }

  @override
  Widget build(BuildContext context) {
    return MainTextField(
      controller: widget.controller,
      label: widget.label,
      hintText: "dd/MM/yyyy",
      keyboardType: TextInputType.number,
      isRequired: widget.isRequired,
      prefixIcon: widget.prefixIcon,

      validator: (value) {
        if (!widget.isRequired && (value == null || value.isEmpty)) {
          return null;
        }
        if (value == null || value.isEmpty) {
          return "Vui lòng nhập ngày sinh";
        }
        if (!value.isValidBirthDate) {
          return "Ngày sinh không hợp lệ";
        }
        return null;
      },

      suffixWidget: IconButton(
        icon: const Icon(Icons.calendar_today),
        onPressed: () => _openDatePicker(context),
      ),
    );
  }
}
