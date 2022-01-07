import 'package:flutter/material.dart';

class AppColor {
  static Color primary = Color(0xFFFF795C);
  static final Color backgroundColor = Colors.white.withOpacity(0.1);


  static final Color red = Color(0xFFFF5F73);
  static final Color black = Color(0xFF000000);
  static final Color white = Color(0xFFffffff);
  static final Color gray = Color(0xFFB7B7B7);
  static final Color blue = Color(0xFF6C99FE);

  static LinearGradient _linearLR({required List<Color> colors}) =>
      LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: colors);
  static final LinearGradient linearRed =
      _linearLR(colors: [Color(0xFFF15F41), Color(0xFFF02C6A)]);
}
