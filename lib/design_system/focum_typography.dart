import 'package:flutter/material.dart';
import 'package:focum/design_system/focum_colors.dart';

class FocumTypography {
  static TextTheme textTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    // Use Android's system typeface; no font downloads or network requests.
    final base = ThemeData(brightness: brightness).textTheme;
    final primary = isDark
        ? FocumColors.textPrimaryDark
        : FocumColors.textPrimary;
    final secondary = isDark
        ? FocumColors.textSecondaryDark
        : FocumColors.textSecondary;
    final tertiary = isDark
        ? FocumColors.textTertiaryDark
        : FocumColors.textTertiary;

    return base.copyWith(
      displayLarge: base.displayLarge?.copyWith(
        fontSize: 48,
        fontWeight: FontWeight.w600,
        letterSpacing: -2.2,
        height: 1.02,
        color: primary,
      ),
      displayMedium: base.displayMedium?.copyWith(
        fontSize: 40,
        fontWeight: FontWeight.w600,
        letterSpacing: -1.8,
        height: 1.04,
        color: primary,
      ),
      headlineLarge: base.headlineLarge?.copyWith(
        fontSize: 32,
        fontWeight: FontWeight.w600,
        letterSpacing: -1.3,
        height: 1.08,
        color: primary,
      ),
      headlineMedium: base.headlineMedium?.copyWith(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        letterSpacing: -1.0,
        height: 1.1,
        color: primary,
      ),
      titleLarge: base.titleLarge?.copyWith(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.5,
        color: primary,
      ),
      titleMedium: base.titleMedium?.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.2,
        color: primary,
      ),
      bodyLarge: base.bodyLarge?.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.4,
        letterSpacing: -0.15,
        color: secondary,
      ),
      bodyMedium: base.bodyMedium?.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.4,
        letterSpacing: -0.1,
        color: secondary,
      ),
      bodySmall: base.bodySmall?.copyWith(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        height: 1.35,
        letterSpacing: -0.05,
        color: tertiary,
      ),
      labelLarge: base.labelLarge?.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.1,
        color: primary,
      ),
      labelMedium: base.labelMedium?.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
        color: tertiary,
      ),
    );
  }
}
