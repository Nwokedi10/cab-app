import 'package:flutter/material.dart';

abstract class AppColors {
  static const Color primaryColorBackground = Color(0xFF0F0D46);
  static const Color accentColor = Color(0xFF9792FF);
  static const Color secondaryColor = Color(0xFF0F017A);
  static const Color red = Color(0xFFFF1F1F);
  static const Color green = Color(0xFF1FFF1F);
  static const Color white = Colors.white;
  static Color white40 = Colors.white.withOpacity(0.4);
  static const Color black = Colors.black;
  static const Color grey = Colors.grey;
  static const Color transparent = Colors.transparent;

  static const MaterialColor primaryColor =
      MaterialColor(0xFF06012D, <int, Color>{
    50: Color(0xffe6e3fe),
    100: Color(0xffb5acfd),
    200: Color(0xff8474fc),
    300: Color(0xff533dfb),
    400: Color(0xff2106f9),
    500: Color(0xff1a04c2),
    600: Color(0xff12038b),
    700: Color(0xff0b0253),
    800: Color(0xff06012d),
    900: Color(0xff04011c),
  });
}
