import 'package:flutter/material.dart';
import 'package:noon/core/constant/app_colors.dart';
import 'package:noon/core/constant/app_text_style.dart';

class AppTheme {
  static final OutlineInputBorder _outlineInputBorder = OutlineInputBorder(
    borderRadius: .circular(14),
    borderSide: const BorderSide(color: AppColors.yellow400Color, width: 0.5),
  );

  static ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: AppColors.scaffoldColor,
    useMaterial3: false,
    fontFamily: 'IBMPlexSansArabic',
    primaryColor: AppColors.black87Color,
    brightness: Brightness.light,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.scaffoldColor,
      elevation: 0.3,
    ),
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: const .all(16),
      fillColor: Colors.white,
      filled: true,
      enabledBorder: _outlineInputBorder,
      focusedBorder: _outlineInputBorder.copyWith(
        borderSide: const BorderSide(color: AppColors.yellow500Color),
      ),
      errorBorder: _outlineInputBorder.copyWith(
        borderSide: const BorderSide(color: AppColors.redColor),
      ),
      focusedErrorBorder: _outlineInputBorder.copyWith(
        borderSide: const BorderSide(color: AppColors.redColor),
      ),
      disabledBorder: _outlineInputBorder,
      helperMaxLines: 4,
      hintStyle: AppTextStyles.regular12.copyWith(
        color: AppColors.gray700Color,
      ),
    ),
    iconButtonTheme: IconButtonThemeData(
      style: ButtonStyle(
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: .circular(12),
            side: BorderSide(
              color: AppColors.blackColor.withValues(alpha: 0.12),
            ),
          ),
        ),
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      selectedItemColor: AppColors.mainColor,
      unselectedItemColor: AppColors.blackColor.withValues(alpha: 0.37),
      selectedLabelStyle: AppTextStyles.medium12.copyWith(
        color: AppColors.mainColor,
      ),
      unselectedLabelStyle: AppTextStyles.medium12.copyWith(
        color: AppColors.blackColor.withValues(alpha: 0.37),
      ),
    ),
  );
}
