import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hkcoin/widgets/screen_popup_widget.dart';

class PopupDropdown<T> extends FormField<T> {
  final String title;
  final List<T> items;
  final T? selectedItem;
  final List<T>? selectedItems;
  final String Function(T) itemLabel;
  final void Function(T?)? onChanged;
  final void Function(List<T>)? onChangedMulti;
  final double popupHeightFactor;
  final double? height;
  final String? placeholder;
  final Color? textColor;
  final Color? titleColor;
  final Color? labelColor;
  final Widget? Function(T)? iconBuilder;
  final bool isMultiSelect;
  final bool showClearButton;
  final Color? searchFieldBackgroundColor;
  final TextStyle? itemTextStyle;
  final Color? popupBackgroundColor;
  final String? cleartext;

  PopupDropdown({
    super.key,
    required this.title,
    required this.items,
    required this.itemLabel,
    this.selectedItem,
    this.selectedItems,
    this.onChanged,
    this.onChangedMulti,
    this.popupHeightFactor = 0.5,
    this.height = 48,
    this.placeholder,
    this.textColor,
    this.titleColor,
    this.labelColor,
    this.iconBuilder,
    this.isMultiSelect = false,
    this.showClearButton = true,
    this.searchFieldBackgroundColor,
    this.itemTextStyle,
    this.popupBackgroundColor,
    this.cleartext,
    String? Function(T?)? validator,
    AutovalidateMode autovalidateMode = AutovalidateMode.disabled,
  }) : super(
         initialValue: selectedItem,
         validator: validator,
         autovalidateMode: autovalidateMode,
         builder: (FormFieldState<T> field) {
           return _PopupDropdownField<T>(
             title: title,
             items: items,
             itemLabel: itemLabel,
             field: field,
             selectedItem: selectedItem,
             selectedItems: selectedItems,
             onChanged: onChanged,
             onChangedMulti: onChangedMulti,
             popupHeightFactor: popupHeightFactor,
             height: height,
             placeholder: placeholder,
             textColor: textColor,
             titleColor: titleColor,
             labelColor: labelColor,
             iconBuilder: iconBuilder,
             isMultiSelect: isMultiSelect,
             showClearButton: showClearButton,
             searchFieldBackgroundColor: searchFieldBackgroundColor,
             itemTextStyle: itemTextStyle,
             popupBackgroundColor: popupBackgroundColor,
             cleartext: cleartext,
           );
         },
       );
}

class _PopupDropdownField<T> extends StatefulWidget {
  final FormFieldState<T> field;
  final String title;
  final List<T> items;
  final T? selectedItem;
  final List<T>? selectedItems;
  final String Function(T) itemLabel;
  final void Function(T?)? onChanged;
  final void Function(List<T>)? onChangedMulti;
  final double popupHeightFactor;
  final double? height;
  final String? placeholder;
  final Color? textColor;
  final Color? titleColor;
  final Color? labelColor;
  final Widget? Function(T)? iconBuilder;
  final bool isMultiSelect;
  final bool showClearButton;
  final Color? searchFieldBackgroundColor;
  final TextStyle? itemTextStyle;
  final Color? popupBackgroundColor;
  final String? cleartext;

  const _PopupDropdownField({
    required this.field,
    required this.title,
    required this.items,
    required this.itemLabel,
    this.selectedItem,
    this.selectedItems,
    this.onChanged,
    this.onChangedMulti,
    required this.popupHeightFactor,
    this.height,
    this.placeholder,
    this.textColor,
    this.titleColor,
    this.labelColor,
    this.iconBuilder,
    required this.isMultiSelect,
    required this.showClearButton,
    this.searchFieldBackgroundColor,
    this.itemTextStyle,
    this.popupBackgroundColor,
    this.cleartext = 'Bỏ chọn',
  });

  @override
  State<_PopupDropdownField<T>> createState() => _PopupDropdownFieldState<T>();
}

class _PopupDropdownFieldState<T> extends State<_PopupDropdownField<T>> {
  late T? selected;
  late List<T> selectedList;

  @override
  void initState() {
    super.initState();
    selected = widget.selectedItem;
    selectedList = List<T>.from(widget.selectedItems ?? []);
  }

  void _showPopup(BuildContext context) {
    List<T> filteredItems = widget.items;
    final searchController = TextEditingController();

    ScreenPopup(
      title: context.tr(widget.title),
      titleColor: widget.titleColor ?? Colors.black,
      heightFactor: widget.popupHeightFactor,
      backgroundColor: widget.popupBackgroundColor ?? Colors.white,
      child: SizedBox(
        height: MediaQuery.of(context).size.height * widget.popupHeightFactor,
        child: StatefulBuilder(
          builder:
              (context, setModalState) => Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor:
                            widget.searchFieldBackgroundColor ??
                            Colors.grey.shade100,
                        hintText: 'Tìm kiếm...',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onChanged: (value) {
                        setModalState(() {
                          filteredItems =
                              widget.items
                                  .where(
                                    (item) => widget
                                        .itemLabel(item)
                                        .toLowerCase()
                                        .contains(value.toLowerCase()),
                                  )
                                  .toList();
                        });
                      },
                    ),
                  ),
                  const Divider(height: 0),
                  if (widget.showClearButton && !widget.isMultiSelect)
                    ListTile(
                      leading: const Icon(Icons.clear, color: Colors.red),
                      title: Text(
                        context.tr(widget.cleartext ?? 'Bỏ chọn'),
                        style: const TextStyle(color: Colors.red),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        setState(() => selected = null);
                        widget.field.didChange(null); // Quan trọng!
                        widget.onChanged?.call(null);
                      },
                    ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredItems.length,
                      itemBuilder: (context, index) {
                        final item = filteredItems[index];
                        final style =
                            widget.itemTextStyle ??
                            TextStyle(color: widget.textColor ?? Colors.black);

                        if (widget.isMultiSelect) {
                          return CheckboxListTile(
                            value: selectedList.contains(item),
                            onChanged: (checked) {
                              setModalState(() {
                                if (checked == true) {
                                  selectedList.add(item);
                                } else {
                                  selectedList.remove(item);
                                }
                              });
                            },
                            title: Text(widget.itemLabel(item), style: style),
                            secondary: widget.iconBuilder?.call(item),
                          );
                        } else {
                          return ListTile(
                            title: Text(widget.itemLabel(item), style: style),
                            leading: widget.iconBuilder?.call(item),
                            trailing:
                                selected == item
                                    ? const Icon(
                                      Icons.check,
                                      color: Colors.green,
                                    )
                                    : null,
                            onTap: () {
                              Navigator.pop(context);
                              setState(() => selected = item);
                              widget.field.didChange(
                                item,
                              ); // Cập nhật FormFieldState
                              widget.onChanged?.call(item);
                            },
                          );
                        }
                      },
                    ),
                  ),
                  if (widget.isMultiSelect)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          widget.onChangedMulti?.call(selectedList);
                        },
                        child: const Text("Xác nhận"),
                      ),
                    ),
                ],
              ),
        ),
      ),
    ).show(context);
  }

  @override
  Widget build(BuildContext context) {
    final displayText =
        widget.isMultiSelect
            ? (widget.selectedItems?.map(widget.itemLabel).join(', ') ??
                context.tr(widget.placeholder ?? 'Chọn...'))
            : selected != null
            ? widget.itemLabel(selected!)
            : context.tr(widget.placeholder ?? 'Chọn...');
    print(widget.height);
    return GestureDetector(
      onTap: () => _showPopup(context),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: context.tr(widget.title),
          labelStyle: TextStyle(color: widget.labelColor ?? Colors.grey[700]),
          border: const OutlineInputBorder(),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 8,
          ),
          errorText: widget.field.errorText,
        ),
        child: SizedBox(
          height: widget.height ?? 48,
          child: Row(
            children: [
              Expanded(
                child: Text(
                  displayText,
                  style: TextStyle(
                    color:
                        (selected != null || widget.isMultiSelect)
                            ? widget.textColor ?? Colors.black
                            : Colors.grey,
                  ),
                ),
              ),
              const Icon(Icons.arrow_drop_down),
            ],
          ),
        ),
      ),
    );
  }
}
