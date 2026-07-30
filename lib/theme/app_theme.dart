import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColorsExtension.dark.background,
    primaryColor: AppColorsExtension.dark.gold,
    extensions: const [AppColorsExtension.dark],
    appBarTheme: AppBarTheme(
      backgroundColor: AppColorsExtension.dark.background,
      foregroundColor: AppColorsExtension.dark.gold,
      elevation: 0,
      centerTitle: true,
    ),
    colorScheme: ColorScheme.dark(
      primary: AppColorsExtension.dark.gold,
      secondary: AppColorsExtension.dark.purple,
      surface: AppColorsExtension.dark.surface,
      error: AppColorsExtension.dark.error,
    ),
    cardColor: AppColorsExtension.dark.cardBackground,
    textTheme: GoogleFonts.poppinsTextTheme(
      TextTheme(
        bodyLarge: TextStyle(color: AppColorsExtension.dark.textPrimary),
        bodyMedium: TextStyle(color: AppColorsExtension.dark.textSecondary),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColorsExtension.dark.gold,
        foregroundColor: AppColorsExtension.dark.black,
      ),
    ),
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
        TargetPlatform.iOS: FadeUpwardsPageTransitionsBuilder(),
      },
    ),
  );

  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColorsExtension.light.background,
    primaryColor: AppColorsExtension.light.gold,
    extensions: const [AppColorsExtension.light],
    appBarTheme: AppBarTheme(
      backgroundColor: AppColorsExtension.light.background,
      foregroundColor: AppColorsExtension.light.gold,
      elevation: 0,
      centerTitle: true,
    ),
    colorScheme: ColorScheme.light(
      primary: AppColorsExtension.light.gold,
      secondary: AppColorsExtension.light.purple,
      surface: AppColorsExtension.light.surface,
      error: AppColorsExtension.light.error,
    ),
    cardColor: AppColorsExtension.light.cardBackground,
    textTheme: GoogleFonts.poppinsTextTheme(
      TextTheme(
        bodyLarge: TextStyle(color: AppColorsExtension.light.textPrimary),
        bodyMedium: TextStyle(color: AppColorsExtension.light.textSecondary),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColorsExtension.light.gold,
        foregroundColor: AppColorsExtension.light.white,
      ),
    ),
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
        TargetPlatform.iOS: FadeUpwardsPageTransitionsBuilder(),
      },
    ),
  );
}