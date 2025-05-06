import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:hkcoin/core/config/app_theme.dart';

class CustomDropDownButton<T> extends StatefulWidget {
  const CustomDropDownButton({
    Key? key,
    this.buttonWidth,
    this.buttonHeight = 60,
    this.dropdownWidth = 200,
    this.dropdownMaxHeight = 180,
    @required this.items,
    this.selectedValue,
    this.title,
    this.hint,
    this.itemDesign,
    this.fontSize,
    this.onChanged,
    this.buttonBorderColor,
    this.validate,
    this.color,
    this.showIconList = false,
    this.defautText,
    this.isRequired,
  }) : super(key: key);
  final double? buttonWidth, buttonHeight, dropdownWidth, dropdownMaxHeight;
  final List<T>? items;
  final T? selectedValue;
  final Function(T?)? onChanged;
  final Widget Function(T item)? itemDesign;
  final Widget? title;
  final String? hint;
  final bool? isRequired;
  final double? fontSize;
  final Color? buttonBorderColor;
  final String? validate;
  final bool showIconList;
  final String? defautText;

  // 3-10 add color text
  final Color? color;
  @override
  State<CustomDropDownButton<T>> createState() =>
      _CustomDropDownButtonState<T>();
}

class _CustomDropDownButtonState<T> extends State<CustomDropDownButton<T>> {
  T? selectedItem;
  @override
  void initState() {
    if (widget.selectedValue != null) {
      selectedItem = widget.selectedValue;
    }
    super.initState();
  }

  @override
  void didUpdateWidget(covariant CustomDropDownButton<T> oldWidget) {
    if (widget.selectedValue != oldWidget.selectedValue) {
      selectedItem = widget.selectedValue;
      setState(() {});
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonHideUnderline(
          child: DropdownButton2<T>(
            isExpanded: true,
            hint:
                widget.hint != null
                    ? Row(
                      children: [
                        Text(
                          widget.hint!,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (widget.isRequired ?? false)
                          Text(
                            " *",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.red.withValues(alpha: .8),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    )
                    : Row(
                      children: [
                        if (widget.showIconList) ...[
                          const Icon(Icons.list, size: 16),
                          const SizedBox(width: 4),
                        ],
                        Expanded(
                          child: Text(
                            selectedItem?.toString() ??
                                widget.defautText ??
                                '...',
                            style: textTheme(
                              context,
                            ).bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
            items:
                widget.items
                    ?.map(
                      (item) => DropdownMenuItem<T>(
                        value: item,
                        child:
                            widget.itemDesign != null
                                ? Builder(
                                  builder: (context) {
                                    return widget.itemDesign!(item);
                                  },
                                )
                                : Text(
                                  item.toString(),
                                  overflow: TextOverflow.ellipsis,
                                  style: textTheme(context).bodyMedium,
                                ),
                      ),
                    )
                    .toList(),
            value: selectedItem,
            onChanged: (item) {
              selectedItem = item;
              setState(() {});
              widget.onChanged?.call(item);
            },
            buttonStyleData: ButtonStyleData(
              height: widget.buttonHeight,
              width: widget.buttonWidth,
              padding: const EdgeInsets.only(left: 10, right: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  width: 1,
                  color: widget.buttonBorderColor ?? Colors.grey[900]!,
                ),
                color: Colors.grey[900],
              ),
              elevation: 0,
            ),
            iconStyleData: const IconStyleData(
              icon: Icon(Icons.arrow_drop_down),
            ),
            menuItemStyleData: MenuItemStyleData(
              height: 40,
              padding: const EdgeInsets.only(left: 14, right: 14),
              selectedMenuItemBuilder: (context, child) {
                return Container(color: Colors.deepOrange, child: child);
              },
            ),
            dropdownStyleData: DropdownStyleData(
              scrollbarTheme: const ScrollbarThemeData(
                radius: Radius.circular(40),
              ),
              maxHeight: widget.dropdownMaxHeight,
              width: widget.dropdownWidth,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.black,
              ),
              elevation: 8,
            ),
            style: TextStyle(fontSize: widget.fontSize, color: Colors.black),
          ),
        ),
        widget.validate != '' && widget.validate != null
            ? Padding(
              padding: const EdgeInsets.fromLTRB(10, 5, 0, 0),
              child: Text(
                widget.validate ?? '',
                style: textTheme(
                  context,
                ).bodySmall!.copyWith(color: Colors.red),
              ),
            )
            : const SizedBox(),
      ],
    );
  }
}
