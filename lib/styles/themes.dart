
import 'package:first_flutter/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';

ThemeData darkTheme = ThemeData(
  scaffoldBackgroundColor: HexColor('333739'),
  colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: defaultColor,
      onPrimary: defaultColor,
      secondary: defaultColor,
      onSecondary: defaultColor,
      error: Colors.red,
      onError: Colors.red,
      background: defaultColor,
      onBackground: Colors.white,
      surface: Colors.white,
      onSurface: Colors.white
  ),
  appBarTheme: AppBarTheme(
    surfaceTintColor: HexColor('333739'),
    titleSpacing: 20,
    color: HexColor('333739'),
    elevation: 0.0,
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: HexColor('333739'),
      statusBarIconBrightness: Brightness.light,
    ),
    iconTheme: const IconThemeData(color: Colors.white),
    titleTextStyle: const TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold
    ),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    type: BottomNavigationBarType.fixed,
    selectedItemColor: defaultColor,
    unselectedItemColor: Colors.grey,
    elevation: 20.0,
    backgroundColor: HexColor('333739'),
  ),
  progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: Colors.deepOrange
  ),
  textTheme: const TextTheme(
      bodyLarge: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 18,
          color: Colors.white
      )
  ),
  fontFamily: 'Janna',
);

ThemeData lightTheme = ThemeData(
  scaffoldBackgroundColor: Colors.white,
  colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: defaultColor,
      onPrimary: defaultColor,
      secondary: defaultColor,
      onSecondary: defaultColor,
      error: defaultColor,
      onError: defaultColor,
      background: Colors.grey,
      onBackground: Colors.grey,
      surface: Colors.black,
      onSurface: Colors.white
  ),
  appBarTheme: const AppBarTheme(
    surfaceTintColor: Colors.white,
    titleSpacing: 20,
    color: Colors.white,
    elevation: 0.0,
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
    ),
    iconTheme: IconThemeData(color: Colors.black),
    titleTextStyle: TextStyle(
        color: Colors.black,
        fontSize: 20,
        fontWeight: FontWeight.bold
    ),
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: defaultColor,
      unselectedItemColor: Colors.grey,
      elevation: 20.0,
      backgroundColor: Colors.white
  ),
  progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: defaultColor
  ),
  textTheme: const TextTheme(
        bodyLarge: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: Colors.black
        )
    ),
  fontFamily: 'Janna',
);