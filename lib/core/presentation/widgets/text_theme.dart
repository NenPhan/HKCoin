import 'package:flutter/material.dart';

import '../app_colors.dart';

class AppTextStyle {
  AppTextStyle._();

  static const TextStyle headline2 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 22 / 16, //line height
    color: AppColors.main,
  );

  static const TextStyle bodyBold = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    height: 17 / 14, //line height
    color: AppColors.secondary,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    height: 20 / 15, //line height
    color: AppColors.secondary,
  );

  static const TextStyle bodyRegular = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    height: 20 / 14, //line height
    letterSpacing: 0,
    color: AppColors.secondary,
  );
}
