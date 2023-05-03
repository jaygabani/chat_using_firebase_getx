import 'package:chat_using_firebase_getx/app/utils/app_colors.dart';
import 'package:chat_using_firebase_getx/app/utils/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

//App's theme setup

ThemeData buildThemeData = ThemeData(
  primaryColor: AppColors.primaryColor,
  scaffoldBackgroundColor: AppColors.background,
  visualDensity: VisualDensity.adaptivePlatformDensity,
  elevatedButtonTheme: elevatedButtonTheme,
  appBarTheme: AppBarTheme(
    color: AppColors.primaryColor,
    elevation: 0,
  ),
  textTheme: TextTheme(
    headlineLarge: headlineLarge,
    bodyLarge: bodyLarge,
    bodyMedium: bodyMedium,
  ),
);

//elevated button theme
ElevatedButtonThemeData elevatedButtonTheme = ElevatedButtonThemeData(
  style: ButtonStyle(
    fixedSize: MaterialStatePropertyAll(Size(double.maxFinite, 36.h)),
    backgroundColor: MaterialStateProperty.all<Color>(AppColors.buttonColor),
    shape: MaterialStateProperty.all<OutlinedBorder>(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.r),
      ),
    ),
    foregroundColor:
        MaterialStateProperty.all<Color>(Colors.white), //actual text color
    textStyle: MaterialStateProperty.all<TextStyle>(
      TextStyle(fontSize: 16.sp),
    ),
    elevation: const MaterialStatePropertyAll(0),
  ),
);
