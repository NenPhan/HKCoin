import 'package:hkcoin/localization/localization_context_extension.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:hkcoin/core/config/app_theme.dart';

class CustomDropdownSearch<T> extends StatelessWidget {
  final List<T> items;
  final T? selectedItem;
  final void Function(T?)? onChanged;
  final String Function(T?) itemAsString;
  final String labelText;
  final String? errorText;
  final bool isEnabled;
  final IconData? icon;
  final Widget Function(BuildContext, T?, bool)? customItemBuilder;
  final double? height; // Chiều cao dropdown chính
  final double itemHeight; // Chiều cao mỗi mục trong danh sách
  final String? Function(T?)? validator;
  const CustomDropdownSearch({
    Key? key,
    required this.items,
    this.selectedItem,
    this.onChanged,
    required this.itemAsString,
    required this.labelText,
    this.errorText,
    this.isEnabled = true,
    this.icon,
    this.customItemBuilder,
    this.height,
    this.itemHeight = 48.0, // Chiều cao mặc định cho mỗi mục
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownSearch<T>(
      popupProps: PopupProps.menu(
        showSearchBox: true,
        searchFieldProps: TextFieldProps(
          decoration: InputDecoration(
            hintText: context.tr(labelText),
            hintStyle: TextStyle(color: Colors.grey[400], fontSize: 15),
            prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
            filled: true,
            fillColor: Colors.grey[900],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.black, width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.black, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.black, width: 1.5),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
          ),
          style: const TextStyle(color: Colors.white),
        ),
        itemBuilder:
            customItemBuilder ??
            (context, T? item, isSelected) {
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.grey[800] : Colors.black,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  children: [
                    Icon(
                      icon ?? Icons.list,
                      color: isSelected ? Colors.white : Colors.grey[300],
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        itemAsString(item),
                        style: textTheme(context).bodyMedium?.copyWith(
                          color: isSelected ? Colors.white : Colors.grey[200],
                          fontWeight:
                              isSelected ? FontWeight.w500 : FontWeight.normal,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
        menuProps: MenuProps(
          backgroundColor: Colors.black,
          elevation: 4,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      items: items,
      itemAsString: itemAsString,
      selectedItem: selectedItem,
      onChanged: (T? value) {
        if (onChanged != null) {
          onChanged!(value);
        }
      },
      dropdownDecoratorProps: DropDownDecoratorProps(
        dropdownSearchDecoration: InputDecoration(
          labelText: context.tr(labelText),
          labelStyle: TextStyle(color: Colors.grey[300]),
          filled: true,
          fillColor: Colors.grey[900],
          prefixIcon:
              icon != null
                  ? Icon(
                    icon,
                    color: Colors.grey[400], // Đồng bộ với labelStyle
                    size: 20.0,
                  )
                  : null, //
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.black, width: 1),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.black, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.black, width: 1.5),
          ),
          errorText: errorText,
          errorStyle: TextStyle(color: Colors.red[300]),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 20,
          ),
        ),
      ),
      enabled: isEnabled,
      validator: validator,
    );
  }
}
