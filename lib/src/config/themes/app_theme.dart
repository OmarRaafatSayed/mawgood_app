import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF0D48A5);
  static const Color secondaryColor = Color(0xFFD65E2C);

  static ThemeData get light => FlexThemeData.light(
        colors: const FlexSchemeColor(
          primary: primaryColor,
          primaryContainer: Color(0xFFD0E4FF),
          secondary: secondaryColor,
          secondaryContainer: Color(0xFFFFDBCE),
          tertiary: Color(0xFF006875),
          tertiaryContainer: Color(0xFF95F0FF),
          appBarColor: Color(0xFFFFDBCE),
          error: Color(0xFFBA1A1A),
        ),
        surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
        blendLevel: 7,
        subThemesData: const FlexSubThemesData(
          blendOnLevel: 10,
          blendOnColors: false,
          useTextTheme: true,
          useM2StyleDividerInM3: true,
          alignedDropdown: true,
          useInputDecoratorThemeInDialogs: true,
          inputDecoratorRadius: 8.0,
          elevatedButtonRadius: 25.0,
        ),
        visualDensity: FlexColorScheme.comfortablePlatformDensity,
        useMaterial3: true,
        fontFamily: GoogleFonts.cairo().fontFamily,
      ).copyWith(
        textTheme: GoogleFonts.cairoTextTheme().apply(
          fontFamily: 'Cairo',
        ),
      );

  static ThemeData get dark => FlexThemeData.dark(
        colors: const FlexSchemeColor(
          primary: Color(0xFFD0E4FF),
          primaryContainer: primaryColor,
          secondary: Color(0xFFFFDBCE),
          secondaryContainer: secondaryColor,
          tertiary: Color(0xFF95F0FF),
          tertiaryContainer: Color(0xFF006875),
          appBarColor: Color(0xFFFFDBCE),
          error: Color(0xFFBA1A1A),
        ),
        surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
        blendLevel: 13,
        subThemesData: const FlexSubThemesData(
          blendOnLevel: 20,
          useTextTheme: true,
          useM2StyleDividerInM3: true,
          alignedDropdown: true,
          useInputDecoratorThemeInDialogs: true,
          inputDecoratorRadius: 8.0,
          elevatedButtonRadius: 25.0,
        ),
        visualDensity: FlexColorScheme.comfortablePlatformDensity,
        useMaterial3: true,
        fontFamily: GoogleFonts.cairo().fontFamily,
      );
}
