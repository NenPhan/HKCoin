/*
PopupDropdown<Doctor>(
  title: "Bác sĩ",
  enableAsyncSearch: true,
  autoFocusSearch: true,
  fullScreenOnLargeList: true,
  itemLabel: (d) => d.fullName,
  onSearchAsync: (keyword, page) async {
    final res = await HospitalRepository()
        .searchDoctors(keyword: keyword, page: page);

    return AsyncSearchResult(
      items: res.items,
      hasMore: res.hasMore,
    );
  },
  onChanged: (d) => controller.setDoctor(d!),
),

 */
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hkcoin/core/enums.dart';
import 'package:hkcoin/widgets/forms/screen_popup_widget.dart';
import 'package:hkcoin/localization/localization_context_extension.dart';

/// ===============================
/// PopupDropdown
/// ===============================
class PopupDropdown<T> extends FormField<T> {
  final String title;
  final List<T> items;
  final T? selectedItem;
  final List<T>? selectedItems;
  final String Function(T) itemLabel;
  final void Function(T?)? onChanged;
  final void Function(List<T>)? onChangedMulti;

  // UI
  final double popupHeightFactor;
  final double? height;
  final String? placeholder;
  final Color? textColor;
  final Color? titleColor;
  final Color? labelColor;
  final Widget? Function(T?)? iconBuilder;
  final bool isMultiSelect;
  final bool showClearButton;
  final Color? searchFieldBackgroundColor;
  final TextStyle? itemTextStyle;
  final Color? popupBackgroundColor;
  final String? cleartext;
  final bool enableFill;

  // ASYNC SEARCH
  final bool enableAsyncSearch;
  final Duration searchDebounce;
  final Future<AsyncSearchResult<T>> Function(String keyword, int page)?
  onSearchAsync;

  // UX
  final PopupStatus popupStatus;
  final bool fullScreenOnLargeList;
  final int fullScreenThreshold;

  /// ✅ OPTION MỚI – AN TOÀN
  /// false = KHÔNG auto focus, không requestFocus
  /// true  = chỉ cho phép focus khi user tap vào TextField
  final bool enableSearchFocus;

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
    this.enableAsyncSearch = false,
    this.searchDebounce = const Duration(milliseconds: 400),
    this.onSearchAsync,
    this.popupStatus = PopupStatus.normal,
    this.fullScreenOnLargeList = true,
    this.fullScreenThreshold = 8,
    this.enableFill = false,

    /// ⭐ MẶC ĐỊNH FALSE – KHÔNG FOCUS
    this.enableSearchFocus = false,

    String? Function(T?)? validator,
  }) : super(
         initialValue: selectedItem,
         validator: validator,
         builder: (field) {
           return _PopupDropdownField<T>(
             field: field,
             dropdown: field.widget as PopupDropdown<T>,
           );
         },
       );
}

/// ===============================
/// Internal Field
/// ===============================
class _PopupDropdownField<T> extends StatefulWidget {
  final FormFieldState<T> field;
  final PopupDropdown<T> dropdown;

  const _PopupDropdownField({required this.field, required this.dropdown});

  @override
  State<_PopupDropdownField<T>> createState() => _PopupDropdownFieldState<T>();
}

class _PopupDropdownFieldState<T> extends State<_PopupDropdownField<T>> {
  late T? selected;
  late List<T> selectedList;

  // Async state
  Timer? _debounce;
  bool isSearching = false;
  bool hasMore = true;
  bool isError = false;
  int page = 1;
  String keyword = '';

  // Cache
  final Map<String, List<T>> _cache = {};

  // Scroll
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    selected = widget.dropdown.selectedItem;
    selectedList = List<T>.from(widget.dropdown.selectedItems ?? []);
    _scrollController.addListener(_onScroll);
  }

  @override
  void didUpdateWidget(covariant _PopupDropdownField<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    final newSelected = widget.dropdown.selectedItem;

    // ✅ CHỈ sync khi cha thay đổi thật sự
    if (newSelected != oldWidget.dropdown.selectedItem) {
      selected = newSelected;
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!widget.dropdown.enableAsyncSearch ||
        !hasMore ||
        isSearching ||
        widget.dropdown.onSearchAsync == null) {
      return;
    }

    if (_scrollController.position.pixels >
        _scrollController.position.maxScrollExtent - 120) {
      _loadMore();
    }
  }

  Future<void> _loadMore() async {
    isSearching = true;
    setState(() {});
    try {
      final result = await widget.dropdown.onSearchAsync!(keyword, page + 1);
      page++;
      hasMore = result.hasMore;
      _cache[keyword] = [...?_cache[keyword], ...result.items];
    } catch (_) {
      isError = true;
    } finally {
      isSearching = false;
      setState(() {});
    }
  }

  Future<void> _search(String value) async {
    keyword = value;
    page = 1;
    hasMore = true;
    isError = false;

    if (_cache.containsKey(value)) {
      setState(() {});
      return;
    }

    if (!widget.dropdown.enableAsyncSearch ||
        widget.dropdown.onSearchAsync == null) {
      return;
    }

    isSearching = true;
    setState(() {});
    try {
      final result = await widget.dropdown.onSearchAsync!(value, 1);
      _cache[value] = result.items;
      hasMore = result.hasMore;
    } catch (_) {
      isError = true;
    } finally {
      isSearching = false;
      setState(() {});
    }
  }

  void _showPopup(BuildContext context) {
    final searchController = TextEditingController();
    final searchFocusNode =
        widget.dropdown.enableSearchFocus ? FocusNode() : null;

    ScreenPopup(
      title: widget.dropdown.title,
      heightFactor:
          widget.dropdown.fullScreenOnLargeList &&
                  widget.dropdown.items.length >=
                      widget.dropdown.fullScreenThreshold
              ? 0.92
              : widget.dropdown.popupHeightFactor,

      /// ❌ KHÔNG AUTO FOCUS
      /// ❌ KHÔNG requestFocus
      onShow: null,
      child: Column(
        children: [
          // ================= SEARCH =================
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: searchController,
              focusNode: searchFocusNode,
              autofocus: false, // ❗ LUÔN FALSE
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Tìm kiếm...',
              ),
              onChanged: (v) {
                _debounce?.cancel();
                _debounce = Timer(
                  widget.dropdown.searchDebounce,
                  () => _search(v),
                );
              },
            ),
          ),

          // ================= LIST =================
          Expanded(
            child: Builder(
              builder: (_) {
                if (isError) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.error, color: Colors.red),
                        const SizedBox(height: 8),
                        const Text("Có lỗi xảy ra"),
                        TextButton(
                          onPressed: () => _search(keyword),
                          child: const Text("Thử lại"),
                        ),
                      ],
                    ),
                  );
                }

                List<T> data =
                    widget.dropdown.enableAsyncSearch
                        ? List<T>.from(_cache[keyword] ?? [])
                        : List<T>.from(widget.dropdown.items);

                // ⭐ ĐƯA ITEM ĐANG CHỌN LÊN ĐẦU
                if (selected != null) {
                  data.removeWhere((e) => e == selected);
                  data.insert(0, selected as T);
                }

                if (data.isEmpty && isSearching) {
                  return const Center(child: CircularProgressIndicator());
                }

                return ListView.builder(
                  controller: _scrollController,
                  itemCount: data.length + (isSearching && hasMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index >= data.length) {
                      return const Padding(
                        padding: EdgeInsets.all(16),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                    final item = data[index];
                    return buildPopupListRow(
                      context: context,
                      title: widget.dropdown.itemLabel(item),
                      selected: selected == item,
                      onTap: () {
                        Get.back();
                        setState(() => selected = item);
                        widget.field.didChange(item);
                        widget.dropdown.onChanged?.call(item);
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    ).show(context);
  }

  @override
  Widget build(BuildContext context) {
    final T? current = selected;
    final text = current != null ? widget.dropdown.itemLabel(current) : null;
    final Widget? prefixIcon =
        widget.dropdown.iconBuilder != null
            ? widget.dropdown.iconBuilder!(current)
            : null;

    return GestureDetector(
      onTap: () => _showPopup(context),
      child: InputDecorator(
        isEmpty: current == null, // ⭐ để label animate đúng
        decoration: InputDecoration(
          labelText: context.tr(widget.dropdown.title),
          // ⭐ FIX QUYẾT ĐỊNH
          prefixIcon: prefixIcon,
          prefixIconConstraints: const BoxConstraints(
            minWidth: 42,
            minHeight: 42,
          ),
          hintText:
              current == null
                  ? context.tr(widget.dropdown.placeholder ?? '')
                  : null,

          hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 16),
          filled: widget.dropdown.enableFill,
          fillColor:
              widget.dropdown.enableFill
                  ? Theme.of(context).brightness == Brightness.dark
                      ? Colors.white.withOpacity(0.08)
                      : Colors.black.withOpacity(0.05)
                  : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: const BorderSide(width: 1.2, color: Colors.black26),
          ),

          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: const BorderSide(width: 1.2, color: Colors.black26),
          ),

          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: const BorderSide(color: Colors.redAccent, width: 1.2),
          ),

          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
          ),

          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),

          errorText: widget.field.errorText,
        ),

        // ⭐⭐ BẮT BUỘC PHẢI CÓ ⭐⭐
        child: Row(
          children: [
            // ✅ ICON Ở ĐẦU BOX (PREFIX)
            //if (prefixIcon != null) ...[prefixIcon, const SizedBox(width: 8)],
            // TEXT
            Expanded(
              child: Text(
                text ?? "",
                style: TextStyle(
                  fontSize: 16,
                  color:
                      selected != null ? Colors.black87 : Colors.grey.shade600,
                ),
              ),
            ),

            // DROPDOWN ICON
            const Icon(Icons.arrow_drop_down, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget buildPopupListRow({
    required BuildContext context,
    required String title,
    required bool selected,
    VoidCallback? onTap,
  }) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return InkWell(
      onTap: onTap,
      child: Container(
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Color(0xFFE0E0E0), width: 0.6),
          ),
        ),
        child: Row(
          children: [
            // TEXT
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                  color: selected ? primary : Colors.black87,
                ),
              ),
            ),

            // ICON CHECK (BÊN PHẢI)
            if (selected) Icon(Icons.check, size: 20, color: primary),
          ],
        ),
      ),
    );
  }
}

/// ===============================
/// Async Search Result
/// ===============================
class AsyncSearchResult<T> {
  final List<T> items;
  final bool hasMore;

  AsyncSearchResult({required this.items, required this.hasMore});
}
