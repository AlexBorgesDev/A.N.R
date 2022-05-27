import 'package:flutter/material.dart';

class CustomTheme {
  static ThemeData get dark {
    return ThemeData(
      fontFamily: 'Poppins',
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(primary: Colors.deepPurple),
      backgroundColor: Colors.grey[900],
      scaffoldBackgroundColor: Colors.grey[900],
    );
  }
}
