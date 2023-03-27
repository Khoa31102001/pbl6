import 'package:flutter/material.dart';
import 'package:base_code/src/struct/app_color.dart';

final ThemeData appTheme = ThemeData(
  fontFamily: 'Nunito',
  colorScheme: ColorScheme.fromSwatch()
      .copyWith(primary: AppColors.primay, secondary: AppColors.secondary),
  scaffoldBackgroundColor: Colors.white,
  platform: TargetPlatform.iOS,
  textTheme: const TextTheme(
    // used for highlight text
    bodyText1: TextStyle(
      color: AppColors.textColor,
      fontWeight: FontWeight.w600,
      fontSize: 14.0,
    ),
    // used for normal text
    bodyText2: TextStyle(
      color: AppColors.textColor,
      fontWeight: FontWeight.w400,
      fontSize: 16.0,
    ),
    headline1: TextStyle(
      color: AppColors.textColor,
      fontWeight: FontWeight.w700,
      fontSize: 48,
    ),
    headline2: TextStyle(
      color: AppColors.textColor,
      fontWeight: FontWeight.w700,
      fontSize: 32,
    ),
    headline3: TextStyle(
      color: AppColors.textColor,
      fontWeight: FontWeight.w700,
      fontSize: 32,
    ),
    headline4: TextStyle(
      color: AppColors.textColor,
      fontWeight: FontWeight.w700,
      fontSize: 28,
    ),
    headline5: TextStyle(
      color: AppColors.textColor,
      fontWeight: FontWeight.w700,
      fontSize: 24,
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      fillColor: AppColors.pinkLight,
      filled: true,
      contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      floatingLabelBehavior: FloatingLabelBehavior.never,
      iconColor: AppColors.primay,
      hintStyle: const TextStyle(
          color: AppColors.secondary,
          fontSize: 16,
          fontWeight: FontWeight.w400)),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
        side: const BorderSide(color: AppColors.primay),
        primary: AppColors.pink,
        onPrimary: AppColors.primay,
        minimumSize: const Size(0, 32),
        textStyle: const TextStyle(fontWeight: FontWeight.w400, fontSize: 16)),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
        side: const BorderSide(color: AppColors.primay),
        primary: AppColors.primay,
        minimumSize: const Size(0, 32),
        textStyle: const TextStyle(fontWeight: FontWeight.w400, fontSize: 16)),
  ),
  // bottomSheetTheme: const BottomSheetThemeData(
  //   backgroundColor: Colors.white,
  //   shape: RoundedRectangleBorder(
  //     borderRadius: BorderRadius.only(
  //       topLeft: Radius.circular(24),
  //       topRight: Radius.circular(24),
  //     ),
  //   ),
  // ),
  // appBarTheme: const AppBarTheme(
  //   color: Colors.white,
  //   centerTitle: true,
  //   elevation: 0,
  //   titleTextStyle: TextStyle(
  //     color: AppColors.textColor,
  //     fontWeight: FontWeight.w600,
  //     fontSize: 16.0,
  //   ),
  //   iconTheme: IconThemeData(
  //     color: AppColors.textColor,
  //     size: 24.0,
  //   ),
  // ),
);
