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
    primaryColor: const Color(0xFF5670f0),
    backgroundColor: Colors.white,
    colorScheme: ColorScheme(
      primary: const Color(0xFF5670f0),
      primaryVariant: const Color(0xFF5670f0),
      secondary: const Color(0xFF7EC9F5),
      secondaryVariant: const Color(0xFF7EC9F5),
      surface: Colors.white,
      background: Colors.grey,
      error: Colors.red,
      onPrimary: Colors.white, // Appbar text und icons
      onSecondary: Colors.white,
      onSurface: Colors.grey.shade800,
      onBackground: Colors.white,
      onError: Colors.red,
      brightness: Brightness.light,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF7EC9F5),
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
