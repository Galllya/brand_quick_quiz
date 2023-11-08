import 'package:flutter/material.dart';
import 'package:brand_quick_quiz/style/colors.dart';

ThemeData appTheme = ThemeData(
  fontFamily: 'Intel',
  primaryColor: AppColors.mainColor,
  scaffoldBackgroundColor: AppColors.scaffoldBackgroundColor,
  appBarTheme:
      const AppBarTheme(elevation: 0, backgroundColor: AppColors.mainColor),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      shape: MaterialStateProperty.all(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      minimumSize: MaterialStateProperty.all(const Size(double.infinity, 60)),
      elevation: MaterialStateProperty.all(0),
      backgroundColor: MaterialStateProperty.resolveWith(
        (Set<MaterialState> states) {
          if (states.contains(MaterialState.disabled)) {
            return Colors.grey;
          } else if (states.contains(MaterialState.pressed)) {
            return AppColors.mainColor;
          } else {
            return AppColors.mainColor;
          }
        },
      ),
      overlayColor: MaterialStateProperty.all(Colors.transparent),
    ),
  ),
);
