import 'package:flutter/cupertino.dart';

class AppSizes {
  static late MediaQueryData _mediaQueryData;
  static late double screenWidth;
  static late double screenHeight;
  static double? defaultSize;
  static Orientation? orientation;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    orientation = _mediaQueryData.orientation;
    screenWidth = _isLandScape()
        ? _mediaQueryData.size.height
        : _mediaQueryData.size.width;
    screenHeight = _isLandScape()
        ? _mediaQueryData.size.width
        : _mediaQueryData.size.height;
  }

  bool _isLandScape() {
    return AppSizes.orientation == Orientation.landscape;
  }
}

// Get a dynamic height based on the input
double getDynamicHeight(double inputHeight) {
  double screenHeight = AppSizes.screenHeight;
  return (inputHeight / 844.0) * screenHeight;
}

// Get a dynamic width based on the input
double getDynamicWidth(double inputWidth) {
  double screenWidth = AppSizes.screenWidth;
  return (inputWidth / 390.0) * screenWidth;
}
