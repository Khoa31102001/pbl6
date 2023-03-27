import 'package:base_code/src/struct/app_color.dart';
import 'package:base_code/src/utils/app_boxshadow.dart';
import 'package:base_code/src/utils/app_image.dart';
import 'package:base_code/src/utils/app_strings.dart';
import 'package:flutter/material.dart';

final customAppbar = AppBar(
    toolbarHeight: 100,
    elevation: 0,
    iconTheme: const IconThemeData(color: Colors.black),
    backgroundColor: AppColors.pinkLight,
    title: Container(
      margin: const EdgeInsets.only(top: 13, bottom: 21),
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(50),
          boxShadow: boxShadows),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(width: 50, height: 50, child: Image.asset(AppImages.logo)),
          const Text(
            AppStrings.appName,
            style: TextStyle(color: AppColors.primay),
          ),
        ],
      ),
    ));
