import 'package:flutter/material.dart';
import 'package:noon/core/constant/app_sizes.dart';
import 'package:noon/core/constant/app_text_style.dart';
import 'package:s_extensions/extensions/number_ext.dart';

enum GenericDropdownPosition { above, below, auto }

class CustomGenericDropDown<T> extends StatefulWidget {
  const CustomGenericDropDown({
    super.key,
    required this.onChanged,
    required this.content,
    required this.hint,
    required this.displayText,
    this.value,
    this.onTap,
    this.onClear,
    this.dropdownPosition = GenericDropdownPosition.auto,
  });

  final void Function(T?)? onChanged;
  final T? value;
  final String hint;
  final List<T> content;
  final String Function(T) displayText;
  final Function()? onTap;
  final VoidCallback? onClear;
  final GenericDropdownPosition dropdownPosition;

  @override
  State<CustomGenericDropDown<T>> createState() => _CustomDropState<T>();
}

class _CustomDropState<T> extends State<CustomGenericDropDown<T>> {
  final GlobalKey _key = GlobalKey();
  OverlayEntry? _overlayEntry;

  static VoidCallback? _closeActiveDropdown;

  void _showDropdown() {
    if (_closeActiveDropdown != null &&
        _closeActiveDropdown != _removeDropdown) {
      _closeActiveDropdown!();
    }
    _closeActiveDropdown = _removeDropdown;

    final RenderBox renderBox =
        _key.currentContext!.findRenderObject() as RenderBox;
    final Offset offset = renderBox.localToGlobal(Offset.zero);

    final double screenHeight = 1.screenHeight;
    final double spaceBelow =
        screenHeight - (offset.dy + renderBox.size.height);
    final double spaceAbove = offset.dy;

    final bool showAbove;
    switch (widget.dropdownPosition) {
      case GenericDropdownPosition.above:
        showAbove = true;
        break;
      case GenericDropdownPosition.below:
        showAbove = false;
        break;
      case GenericDropdownPosition.auto:
        showAbove = spaceBelow < 200 && spaceAbove > spaceBelow;
        break;
    }

    final double? top = showAbove ? null : offset.dy + renderBox.size.height;
    final double? bottom = showAbove ? screenHeight - offset.dy : null;
    final double maxHeight = showAbove ? spaceAbove - 20 : spaceBelow - 20;

    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          GestureDetector(
            onTap: _removeDropdown,
            behavior: .translucent,
            child: SizedBox(width: 1.screenWidth, height: 1.screenHeight),
          ),
          Positioned(
            left: offset.dx,
            top: top,
            bottom: bottom,
            width: renderBox.size.width,
            child: Material(
              elevation: 4.0,
              borderRadius: .circular(12),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxHeight: maxHeight),
                child: ListView(
                  padding: .zero,
                  shrinkWrap: true,
                  children: widget.content.map((item) {
                    return GestureDetector(
                      onTap: () {
                        widget.onChanged?.call(item);
                        _removeDropdown();
                      },
                      child: Container(
                        padding: const .symmetric(horizontal: 14, vertical: 10),
                        child: Text(
                          widget.displayText(item),
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeDropdown() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    if (_closeActiveDropdown == _removeDropdown) {
      _closeActiveDropdown = null;
    }
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
                widget.value == null
                    ? widget.hint
                    : widget.displayText(widget.value as T),
                style: AppTextStyles.medium14.copyWith(
                  color: AppTextStyles.medium14.color!.withValues(alpha: 0.60),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (widget.value != null && widget.onClear != null)
              GestureDetector(
                onTap: () {
                  _removeDropdown();
                  widget.onClear!();
                },
                child: Padding(
                  padding: const .symmetric(horizontal: 12),
                  child: Icon(
                    Icons.close,
                    size: 21,
                    color: Colors.black.withValues(alpha: 0.4),
                  ),
                ),
              ),
            const Icon(Icons.keyboard_arrow_down_sharp, color: Colors.teal),
          ],
        ),
      ),
    );
  }
}
