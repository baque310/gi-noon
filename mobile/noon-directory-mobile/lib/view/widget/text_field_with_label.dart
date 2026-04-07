import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:noon/core/constant/app_text_style.dart';

class TextFieldWithLabel extends StatelessWidget {
  const TextFieldWithLabel({
    super.key,
    required this.label,
    this.hint,
    this.onChange,
    this.keyboardType,
    required this.controller,
    this.inputFormatters = const [],
    this.maxLines = 1,
    this.validator,
    this.enabled = true,
    this.passwordFiled = false,
  });

  final TextEditingController controller; // Add this line
  final TextInputType? keyboardType;
  final String label;
  final String? hint;
  final Function? onChange;
  final List<TextInputFormatter>? inputFormatters;
  final int maxLines;
  final String? Function(String?)? validator;
  final bool enabled;
  final bool passwordFiled;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 8,
      crossAxisAlignment: .start,
      children: [
        Text(label, style: AppTextStyles.semiBold14),
        TextFormField(
          style: AppTextStyles.semiBold14,
          controller: controller,
          keyboardType: keyboardType,
          onChanged: onChange as Function(String val)?,
          inputFormatters: inputFormatters,
          maxLines: maxLines,
          validator: validator,
          enabled: enabled,
          obscureText: passwordFiled,
          decoration: InputDecoration(
            hintText: hint,
            prefixIconConstraints: passwordFiled
                ? const BoxConstraints(minHeight: 40, minWidth: 40)
                : null,
            // prefixIcon: passwordFiled ? Container(
            //   width: 40,
            //   height: 40,
            //   alignment:.center,
            //   margin: const .only(
            //     left: 8.0,
            //     right: 6.0,
            //   ),
            //   child: SvgPicture.asset(AppAssets.icPassword),
            // ) : null,
          ),
        ),
      ],
    );
  }
}
