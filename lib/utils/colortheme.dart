import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';

enum ColorThemes {
  standard,
  purple,
}

class AppTheme extends ChangeNotifier {
  //Constant variables
  late ThemeData customTheme;
  late ColorThemes currentTheme;

  //Theme variables
  final _standardTheme = ThemeData(
    primarySwatch: Colors.teal,
    textTheme: GoogleFonts.nunitoTextTheme(),
    primaryColor: const Color(0xFF047769),
    colorScheme: const ColorScheme(
      primary: Color(0xFF047769),
      primaryVariant: Color(0xFF047769),
      secondary: Color(0xFF0cb09c),
      secondaryVariant: Color(0xFF0cb09c),
      surface: Colors.white,
      background: Colors.white,
      error: Colors.red,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Colors.white,
      onBackground: Colors.white,
      onError: Colors.white,
      brightness: Brightness.light,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF047769),
    ),
  );

  final _purpleTheme = ThemeData(
    textTheme: GoogleFonts.nunitoTextTheme(),
    primaryColor: Colors.purple,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.purple,
    ),
  );

  //Constructor
  AppTheme() {
    currentTheme = ColorThemes.standard;
    customTheme = _standardTheme;
  }

  //Methods
  void changeTheme(ColorThemes theme) {
    switch (theme) {
      case ColorThemes.standard:
        customTheme = _standardTheme;
        currentTheme = ColorThemes.standard;
        notifyListeners();
        break;
      case ColorThemes.purple:
        customTheme = _purpleTheme;
        currentTheme = ColorThemes.purple;
        notifyListeners();
        break;
      default:
        debugPrint("Theme not availabe!");
        customTheme = _standardTheme;
        currentTheme = ColorThemes.standard;
        notifyListeners();
        break;
    }
  }
}
