import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  late final ThemeData customTheme;

  final Color _primaryColor = const Color(0xFF047769);

  AppTheme(){
    customTheme = ThemeData(
      textTheme: GoogleFonts.nunitoTextTheme(),
      primaryColor: _primaryColor,
      appBarTheme: AppBarTheme(
        backgroundColor: _primaryColor
      ),
    );
  }
}