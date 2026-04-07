import 'package:flutter/material.dart';
import 'package:noon/core/constant/app_sizes.dart';
import 'package:noon/core/constant/app_text_style.dart';
import 'package:noon/core/localization/language.dart';
import 'package:get/get.dart';

class MultiSelectGenericDropDown<T> extends StatefulWidget {
  const MultiSelectGenericDropDown({
    super.key,
    required this.onChanged,
    required this.content,
    required this.hint,
    required this.displayText,
    required this.selectedValues,
    this.onTap,
  });

  final void Function(List<T>) onChanged;
  final List<T> selectedValues;
  final String hint;
  final List<T> content;
  final String Function(T) displayText;
  final Function()? onTap;

  @override
  State<MultiSelectGenericDropDown<T>> createState() =>
      _MultiSelectDropState<T>();
}

class _MultiSelectDropState<T> extends State<MultiSelectGenericDropDown<T>> {
  final GlobalKey _key = GlobalKey();
  OverlayEntry? _overlayEntry;

  void _showDropdown() {
    final RenderBox renderBox =
        _key.currentContext!.findRenderObject() as RenderBox;
    final Offset offset = renderBox.localToGlobal(Offset.zero);

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: offset.dx,
        top: offset.dy + renderBox.size.height,
        width: renderBox.size.width,
        child: Material(
          elevation: 4.0,
          borderRadius: .circular(12),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: 250),
            child: ListView(
              padding: .zero,
              shrinkWrap: true,
              children: [
                ...widget.content.map((item) {
                  final isSelected = widget.selectedValues.contains(item);
                  return GestureDetector(
                    onTap: () {
                      final newValues = List<T>.from(widget.selectedValues);
                      if (isSelected) {
                        newValues.remove(item);
                      } else {
                        newValues.add(item);
                      }
                      widget.onChanged(newValues);
                      // Don't close dropdown on selection for multi-select
                      _overlayEntry?.markNeedsBuild();
                    },
                    child: Container(
                      padding: const .symmetric(horizontal: 14, vertical: 10),
                      color: isSelected
                          ? Colors.teal.withValues(alpha: 0.1)
                          : null,
                      child: Row(
                        children: [
                          Icon(
                            isSelected
                                ? Icons.check_box
                                : Icons.check_box_outline_blank,
                            color: Colors.teal,
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              widget.displayText(item),
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
                GestureDetector(
                  onTap: _removeDropdown,
                  child: Container(
                    padding: const .symmetric(horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(color: Colors.grey.shade300),
                      ),
                    ),
                    alignment: .center,
                    child: Text(
                      AppLanguage
                          .done
                          .tr, // Assuming a "Done" string exists or I can use "OK"
                      style: AppTextStyles.bold14.copyWith(color: Colors.teal),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeDropdown() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  void dispose() {
    _removeDropdown();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (_overlayEntry == null) {
          _showDropdown();
        } else {
          _removeDropdown();
        }
        widget.onTap?.call();
      },
      child: Container(
        key: _key,
        padding: const .symmetric(horizontal: 14),
        height: getDynamicHeight(55),
        decoration: BoxDecoration(
          borderRadius: .circular(12),
          border: .all(color: Colors.black.withValues(alpha: 0.12), width: 0.5),
        ),
        child: Row(
          mainAxisAlignment: .spaceBetween,
          children: [
            Expanded(
              child: Text(
                widget.selectedValues.isEmpty
                    ? widget.hint
                    : widget.selectedValues
                          .map((e) => widget.displayText(e))
                          .join(', '),
                style: AppTextStyles.medium14.copyWith(
                  color: AppTextStyles.medium14.color!.withValues(alpha: 0.60),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Icon(Icons.keyboard_arrow_down_sharp, color: Colors.teal),
          ],
        ),
      ),
    );
  }
}
