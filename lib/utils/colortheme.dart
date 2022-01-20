import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
    textTheme: GoogleFonts.nunitoTextTheme(),
    primaryColor: const Color(0xFF047769),
    colorScheme: const ColorScheme.light(
        primary: Color(0xFF047769), secondary: Color(0xFF047769)),
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
