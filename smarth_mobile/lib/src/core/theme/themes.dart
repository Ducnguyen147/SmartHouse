import 'package:flutter/material.dart';

class AppColors {
  static const background = Color(0xffEEEEEE);
  static const primaryColor = Color(0xff12283D);
  static const white = Color(0xffFFFFFF);

  static const shadow = Color(0xff000000);
  static const text = Color(0xff262626);
  static const palGreen = Color(0xff7DBDBD);
  static const palRed = Color(0xffFF6897);
  static const palYellow = Color(0xffF5BD38);
  // 3C81B5
  static const offDeviceContainerBackground = Color(0xff3C81B5);
}

class AppTheme {
  //

  static final primaryShadow = BoxShadow(
    color: AppColors.shadow.withOpacity(0.02),
    blurRadius: 6,
    offset: const Offset(0, 2),
  );

  static final primaryDecoration = BoxDecoration(
    color: AppColors.white,
    borderRadius: BorderRadius.circular(10.0),
    boxShadow: [primaryShadow],
  );
}
