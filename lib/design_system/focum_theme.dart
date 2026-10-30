import 'package:flutter/material.dart';
import 'package:focum/design_system/focum_colors.dart';
import 'package:focum/design_system/focum_radius.dart';
import 'package:focum/design_system/focum_typography.dart';

class FocumTheme {
  static ThemeData light() => _build(Brightness.light);

  static ThemeData dark() => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final primary = isDark ? const Color(0xFF7D958E) : FocumColors.brand;
    final onPrimary = Colors.white;
    final surface = isDark ? FocumColors.surfaceDark : FocumColors.surface;
    final surfaceMuted =
        isDark ? FocumColors.surfaceMutedDark : FocumColors.surfaceMuted;
    final background =
        isDark ? FocumColors.backgroundDark : FocumColors.background;
    final onSurface =
        isDark ? FocumColors.textPrimaryDark : FocumColors.textPrimary;
    final onSurfaceVariant =
        isDark ? FocumColors.textSecondaryDark : FocumColors.textSecondary;
    final outline = isDark ? FocumColors.strokeDark : FocumColors.stroke;
    final outlineVariant =
        isDark ? FocumColors.strokeStrongDark : FocumColors.strokeStrong;

    final colorScheme = ColorScheme(
      brightness: brightness,
      primary: primary,
      onPrimary: onPrimary,
      primaryContainer:
          isDark ? const Color(0xFF22302B) : FocumColors.brandSoft,
      onPrimaryContainer: isDark ? const Color(0xFFE1ECE7) : FocumColors.brandStrong,
      secondary: primary,
      onSecondary: onPrimary,
      error: FocumColors.danger,
      onError: Colors.white,
      surface: surface,
      onSurface: onSurface,
      onSurfaceVariant: onSurfaceVariant,
      outline: outline,
      outlineVariant: outlineVariant,
      shadow: Colors.black,
      scrim: Colors.black54,
      inverseSurface:
          isDark ? FocumColors.backgroundElevated : FocumColors.surfaceStrong,
      onInverseSurface:
          isDark ? FocumColors.textPrimary : FocumColors.textPrimaryDark,
      inversePrimary: FocumColors.brand,
    );

    final textTheme = FocumTypography.textTheme(brightness);

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: background,
      canvasColor: surface,
      textTheme: textTheme,
      splashColor: primary.withValues(alpha: 0.08),
      highlightColor: Colors.transparent,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: onSurface,
        elevation: 0,
        centerTitle: false,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: textTheme.titleLarge,
      ),
      cardTheme: CardThemeData(
        color: surface,
        margin: EdgeInsets.zero,
        elevation: 0,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(FocumRadius.large),
          side: BorderSide(color: outline),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: outline,
        thickness: 1,
        space: 1,
      ),
      iconTheme: IconThemeData(color: onSurface),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: primary,
        linearTrackColor: surfaceMuted,
        circularTrackColor: surfaceMuted,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: isDark ? FocumColors.surfaceStrongDark : Colors.white,
        contentTextStyle: textTheme.bodyMedium?.copyWith(color: onSurface),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(FocumRadius.medium),
          side: BorderSide(color: outline),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: onPrimary,
          minimumSize: const Size.fromHeight(56),
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          textStyle: textTheme.labelLarge,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(FocumRadius.medium),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: onSurface,
          minimumSize: const Size.fromHeight(56),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          side: BorderSide(color: outline),
          textStyle: textTheme.labelLarge,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(FocumRadius.medium),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primary,
          textStyle: textTheme.labelLarge,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(FocumRadius.medium),
          ),
        ),
      ),
    );
  }
}
