import 'package:flutter/material.dart';

class Pallete {
  static const blackColor = Color.fromRGBO(1, 1, 1, 1);
  static const whiteColor = Colors.white;
  static const bluishColor = Color.fromRGBO(26, 39, 45, 1);
  static const darkGrayColor = Color.fromRGBO(18, 18, 18, 1);
  static var blueColor = Colors.blue.shade300;
  static var redColor = Colors.red.shade500;

  // Themes
  static var darkModeAppTheme = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: blackColor,
    cardColor: bluishColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: darkGrayColor,
      iconTheme: IconThemeData(
        color: whiteColor,
      ),
    ),
    drawerTheme: const DrawerThemeData(
      backgroundColor: darkGrayColor,
    ),
    primaryColor: redColor,
    colorScheme: ColorScheme.dark(
      surface: darkGrayColor,
    ),
  );

  static var lightModeAppTheme = ThemeData.light().copyWith(
    scaffoldBackgroundColor: whiteColor,
    cardColor: bluishColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: whiteColor,
      elevation: 0,
      iconTheme: IconThemeData(
        color: blackColor,
      ),
    ),
    drawerTheme: const DrawerThemeData(
      backgroundColor: whiteColor,
    ),
    primaryColor: redColor,
    colorScheme: ColorScheme.light(
      surface: whiteColor,
    ),
  );
}
