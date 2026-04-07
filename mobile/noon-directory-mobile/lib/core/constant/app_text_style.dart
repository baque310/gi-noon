import 'package:flutter/material.dart';
import 'package:noon/core/constant/app_colors.dart';
import 'package:noon/core/constant/app_sizes.dart';

class AppTextStyles {
  AppTextStyles._();

  //36 font size
  static TextStyle get bold36 => TextStyle(
    fontSize: _getFontSize(36),
    fontWeight: FontWeight.w700,
    color: AppColors.blackColor,
    fontFamily: 'IBMPlexSansArabic',
  );
  static TextStyle get semiBold36 => TextStyle(
    fontSize: _getFontSize(36),
    fontWeight: FontWeight.w600,
    color: AppColors.blackColor,
    fontFamily: 'IBMPlexSansArabic',
  );
  static TextStyle get medium36 => TextStyle(
    fontSize: _getFontSize(36),
    fontWeight: FontWeight.w500,
    color: AppColors.blackColor,
    fontFamily: 'IBMPlexSansArabic',
  );
  static TextStyle get regular36 => TextStyle(
    fontSize: _getFontSize(36),
    fontWeight: FontWeight.w400,
    color: AppColors.blackColor,
    fontFamily: 'IBMPlexSansArabic',
  );

  //28 font size
  static TextStyle get bold28 => TextStyle(
    fontSize: _getFontSize(28),
    fontWeight: FontWeight.w700,
    color: AppColors.blackColor,
    fontFamily: 'IBMPlexSansArabic',
  );
  static TextStyle get semiBold28 => TextStyle(
    fontSize: _getFontSize(28),
    fontWeight: FontWeight.w600,
    color: AppColors.blackColor,
    fontFamily: 'IBMPlexSansArabic',
  );
  static TextStyle get medium28 => TextStyle(
    fontSize: _getFontSize(28),
    fontWeight: FontWeight.w500,
    color: AppColors.blackColor,
    fontFamily: 'IBMPlexSansArabic',
  );
  static TextStyle get regular28 => TextStyle(
    fontSize: _getFontSize(28),
    fontWeight: FontWeight.w400,
    color: AppColors.blackColor,
    fontFamily: 'IBMPlexSansArabic',
  );

  //24 font size
  static TextStyle get bold24 => TextStyle(
    fontSize: _getFontSize(24),
    fontWeight: FontWeight.w700,
    color: AppColors.blackColor,
    fontFamily: 'IBMPlexSansArabic',
  );
  static TextStyle get semiBold24 => TextStyle(
    fontSize: _getFontSize(24),
    fontWeight: FontWeight.w600,
    color: AppColors.blackColor,
    fontFamily: 'IBMPlexSansArabic',
  );
  static TextStyle get medium24 => TextStyle(
    fontSize: _getFontSize(24),
    fontWeight: FontWeight.w500,
    color: AppColors.blackColor,
    fontFamily: 'IBMPlexSansArabic',
  );
  static TextStyle get regular24 => TextStyle(
    fontSize: _getFontSize(24),
    fontWeight: FontWeight.w400,
    color: AppColors.blackColor,
    fontFamily: 'IBMPlexSansArabic',
  );

  //22 font size
  static TextStyle get bold22 => TextStyle(
    fontSize: _getFontSize(22),
    fontWeight: FontWeight.w700,
    color: AppColors.blackColor,
    fontFamily: 'IBMPlexSansArabic',
  );

  //20 font size
  static TextStyle get bold20 => TextStyle(
    fontSize: _getFontSize(20),
    fontWeight: FontWeight.w700,
    color: AppColors.blackColor,
    fontFamily: 'IBMPlexSansArabic',
  );
  static TextStyle get semiBold20 => TextStyle(
    fontSize: _getFontSize(20),
    fontWeight: FontWeight.w600,
    color: AppColors.blackColor,
    fontFamily: 'IBMPlexSansArabic',
  );
  static TextStyle get medium20 => TextStyle(
    fontSize: _getFontSize(20),
    fontWeight: FontWeight.w500,
    color: AppColors.blackColor,
    fontFamily: 'IBMPlexSansArabic',
  );
  static TextStyle get regular20 => TextStyle(
    fontSize: _getFontSize(20),
    fontWeight: FontWeight.w400,
    color: AppColors.blackColor,
  );

  //18 font size
  static TextStyle get bold18 => TextStyle(
    fontSize: _getFontSize(18),
    fontWeight: FontWeight.w700,
    color: AppColors.blackColor,
    fontFamily: 'IBMPlexSansArabic',
  );
  static TextStyle get semiBold18 => TextStyle(
    fontSize: _getFontSize(18),
    fontWeight: FontWeight.w600,
    color: AppColors.blackColor,
    fontFamily: 'IBMPlexSansArabic',
  );
  static TextStyle get medium18 => TextStyle(
    fontSize: _getFontSize(18),
    fontWeight: FontWeight.w500,
    color: AppColors.blackColor,
    fontFamily: 'IBMPlexSansArabic',
  );
  static TextStyle get regular18 => TextStyle(
    fontSize: _getFontSize(18),
    fontWeight: FontWeight.w400,
    color: AppColors.blackColor,
    fontFamily: 'IBMPlexSansArabic',
  );

  //16 font size
  static TextStyle get bold16 => TextStyle(
    fontSize: _getFontSize(16),
    fontWeight: FontWeight.w700,
    color: AppColors.blackColor,
    fontFamily: 'IBMPlexSansArabic',
  );
  static TextStyle get semiBold16 => TextStyle(
    fontSize: _getFontSize(16),
    fontWeight: FontWeight.w600,
    color: AppColors.blackColor,
    fontFamily: 'IBMPlexSansArabic',
  );
  static TextStyle get medium16 => TextStyle(
    fontSize: _getFontSize(16),
    fontWeight: FontWeight.w500,
    color: AppColors.blackColor,
    fontFamily: 'IBMPlexSansArabic',
  );
  static TextStyle get regular16 => TextStyle(
    fontSize: _getFontSize(16),
    fontWeight: FontWeight.w400,
    color: AppColors.blackColor,
    fontFamily: 'IBMPlexSansArabic',
  );

  //14 font size
  static TextStyle get bold14 => TextStyle(
    fontSize: _getFontSize(14),
    fontWeight: FontWeight.w700,
    color: AppColors.blackColor,
    fontFamily: 'IBMPlexSansArabic',
  );
  static TextStyle get semiBold14 => TextStyle(
    fontSize: _getFontSize(14),
    fontWeight: FontWeight.w600,
    color: AppColors.blackColor,
    fontFamily: 'IBMPlexSansArabic',
  );
  static TextStyle get medium14 => TextStyle(
    fontSize: _getFontSize(14),
    fontWeight: FontWeight.w500,
    color: AppColors.blackColor,
    fontFamily: 'IBMPlexSansArabic',
  );
  static TextStyle get regular14 => TextStyle(
    fontSize: _getFontSize(14),
    fontWeight: FontWeight.w400,
    fontFamily: 'IBMPlexSansArabic',
    color: Colors.black,
  );

  //12 font size
  static TextStyle get bold12 => TextStyle(
    fontSize: _getFontSize(12),
    fontWeight: FontWeight.w700,
    color: AppColors.blackColor,
    fontFamily: 'IBMPlexSansArabic',
  );
  static TextStyle get semiBold12 => TextStyle(
    fontSize: _getFontSize(12),
    fontWeight: FontWeight.w600,
    color: AppColors.blackColor,
    fontFamily: 'IBMPlexSansArabic',
  );
  static TextStyle get medium12 => TextStyle(
    fontSize: _getFontSize(12),
    fontWeight: FontWeight.w500,
    color: AppColors.blackColor,
    fontFamily: 'IBMPlexSansArabic',
  );
  static TextStyle get regular12 => TextStyle(
    fontSize: _getFontSize(12),
    fontWeight: FontWeight.w400,
    color: Colors.black87,
    fontFamily: 'IBMPlexSansArabic',
  );

  static TextStyle get semiBold10 => TextStyle(
    fontSize: _getFontSize(10),
    fontWeight: FontWeight.w600,
    color: AppColors.blackColor,
    fontFamily: 'IBMPlexSansArabic',
  );

  static TextStyle get medium10 => TextStyle(
    fontSize: _getFontSize(10),
    fontWeight: FontWeight.w500,
    color: AppColors.blackColor,
    fontFamily: 'IBMPlexSansArabic',
  );
  static TextStyle get regular10 => TextStyle(
    fontSize: _getFontSize(10),
    fontWeight: FontWeight.w400,
    color: AppColors.blackColor,
    fontFamily: 'IBMPlexSansArabic',
  );

  static TextStyle get textSemiBold12 => semiBold12;
  static TextStyle get textMedium12 => medium12;
  static TextStyle get textRegular12 => regular12;
  static TextStyle get textSemiBold14 => semiBold14;
  static TextStyle get textMedium14 => medium14;
  static TextStyle get textRegular14 => regular14;
  static TextStyle get textSemiBold16 => semiBold16;
  static TextStyle get textMedium16 => medium16;
  static TextStyle get textSemiBold10 => semiBold10;
  static TextStyle get textMedium10 => medium10;
  static TextStyle get textRegular10 => regular10;

  static double _getFontSize(double size) {
    try {
      final width = AppSizes.screenWidth;
      if (width <= 480) {
        return size;
      } else if (width > 600 && width <= 960) {
        return size + 3;
      } else {
        return size + 4;
      }
    } catch (_) {
      return size;
    }
  }
}
