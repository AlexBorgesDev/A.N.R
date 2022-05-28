import 'package:A.N.R/styles/colors.dart';
import 'package:flutter/material.dart';

class CustomTheme {
  static ThemeData get dark {
    return ThemeData(
      fontFamily: 'Poppins',
      brightness: Brightness.dark,
      appBarTheme: const AppBarTheme(backgroundColor: CustomColors.surface),
      primaryColor: CustomColors.primary,
      backgroundColor: CustomColors.background,
      scaffoldBackgroundColor: CustomColors.background,
      popupMenuTheme: const PopupMenuThemeData(color: CustomColors.surfaceTwo),
    );
  }
}
