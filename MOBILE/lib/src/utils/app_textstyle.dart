import 'package:base_code/src/struct/app_color.dart';
import 'package:flutter/material.dart';

class AppTextStyle {
  static const linkTextStyle = TextStyle(
      color: AppColors.pinkDark, fontSize: 14, fontWeight: FontWeight.w400);
  static const secondaryText = TextStyle(
      color: AppColors.secondary, fontSize: 14, fontWeight: FontWeight.w400);
  static const headlineStyle = TextStyle(
      color: AppColors.primay, fontSize: 30, fontWeight: FontWeight.w400);
  static const bannerHeadlineStyle = TextStyle(
      fontFamily: 'NotoSerif',
      color: AppColors.primay,
      fontSize: 32,
      fontWeight: FontWeight.w700);
}
