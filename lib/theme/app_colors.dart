import 'package:flutter/material.dart';

@immutable
class AppColorsExtension extends ThemeExtension<AppColorsExtension> {
  final Color background;
  final Color surface;
  final Color cardBackground;
  final Color gold;
  final Color purple;
  final Color emerald;
  final Color textPrimary;
  final Color textSecondary;
  final Color white;
  final Color black;
  final Color error;
  final Color success;

  const AppColorsExtension({
    required this.background,
    required this.surface,
    required this.cardBackground,
    required this.gold,
    required this.purple,
    required this.emerald,
    required this.textPrimary,
    required this.textSecondary,
    required this.white,
    required this.black,
    required this.error,
    required this.success,
  });

  static const dark = AppColorsExtension(
    background: Color(0xFF121014),
    surface: Color(0xFF1E1B22),
    cardBackground: Color(0xFF262230),
    gold: Color(0xFFD4AF37),
    purple: Color(0xFFA78BFA),
    emerald: Color(0xFF34D399),
    textPrimary: Color(0xFFF5F3F7),
    textSecondary: Color(0xFFB0A8BC),
    white: Color(0xFFFFFFFF),
    black: Color(0xFF000000),
    error: Color(0xFFE86A6A),
    success: Color(0xFF34D399),
  );

  static const light = AppColorsExtension(
    background: Color(0xFFFAF6EF),
    surface: Color(0xFFF1E9DA),
    cardBackground: Color(0xFFFFFFFF),
    gold: Color(0xFFB8860B),
    purple: Color(0xFF7C3AED),
    emerald: Color(0xFF059669),
    textPrimary: Color(0xFF241F2B),
    textSecondary: Color(0xFF6B6478),
    white: Color(0xFFFFFFFF),
    black: Color(0xFF000000),
    error: Color(0xFFD32F2F),
    success: Color(0xFF059669),
  );

  @override
  AppColorsExtension copyWith({
    Color? background,
    Color? surface,
    Color? cardBackground,
    Color? gold,
    Color? purple,
    Color? emerald,
    Color? textPrimary,
    Color? textSecondary,
    Color? white,
    Color? black,
    Color? error,
    Color? success,
  }) {
    return AppColorsExtension(
      background: background ?? this.background,
      surface: surface ?? this.surface,
      cardBackground: cardBackground ?? this.cardBackground,
      gold: gold ?? this.gold,
      purple: purple ?? this.purple,
      emerald: emerald ?? this.emerald,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      white: white ?? this.white,
      black: black ?? this.black,
      error: error ?? this.error,
      success: success ?? this.success,
    );
  }

  @override
  AppColorsExtension lerp(ThemeExtension<AppColorsExtension>? other, double t) {
    if (other is! AppColorsExtension) return this;
    return AppColorsExtension(
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      cardBackground: Color.lerp(cardBackground, other.cardBackground, t)!,
      gold: Color.lerp(gold, other.gold, t)!,
      purple: Color.lerp(purple, other.purple, t)!,
      emerald: Color.lerp(emerald, other.emerald, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      white: Color.lerp(white, other.white, t)!,
      black: Color.lerp(black, other.black, t)!,
      error: Color.lerp(error, other.error, t)!,
      success: Color.lerp(success, other.success, t)!,
    );
  }
}

extension AppColorsContext on BuildContext {
  AppColorsExtension get colors =>
      Theme.of(this).extension<AppColorsExtension>()!;
}