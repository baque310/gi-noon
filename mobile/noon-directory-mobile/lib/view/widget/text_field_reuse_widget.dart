import 'package:flutter/material.dart';

import '../../core/constant/app_text_style.dart';

class TextFieldReuse extends StatelessWidget {
  const TextFieldReuse({
    super.key,
    required this.controller,
    this.onChange,
    required this.hint,
    this.inputTupe,
    this.validate,
    this.prefixIcon,
    this.suffixIcon,
    this.readOnly = false,
  });

  final Function(String)? onChange;
  final TextEditingController controller;
  final String hint;
  final TextInputType? inputTupe;
  final String? Function(String?)? validate;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: readOnly,
      validator: validate,
      onChanged: onChange,
      controller: controller,
      keyboardType: inputTupe,
      decoration: InputDecoration(
        fillColor: Colors.transparent,
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: const Color(0xFF1A202C).withValues(alpha: 0.12),
          ),
          borderRadius: .circular(12),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: const Color(0xFF1A202C).withValues(alpha: 0.12),
          ),
          borderRadius: .circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: const Color(0xFF1A202C).withValues(alpha: 0.12),
          ),
          borderRadius: .circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: const Color(0xFF1A202C).withValues(alpha: 0.12),
          ),
          borderRadius: .circular(12),
        ),
        hintText: hint,
        hintStyle: AppTextStyles.medium14.copyWith(
          color: AppTextStyles.medium14.color!.withValues(alpha: 0.60),
        ),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
      ),
    );
  }
}
