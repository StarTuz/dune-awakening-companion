import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get duneTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      
      // Color Scheme
      colorScheme: ColorScheme.dark(
        primary: DuneColors.primaryAccent,
        secondary: DuneColors.secondaryAccent,
        surface: DuneColors.secondaryBackground,
        background: DuneColors.primaryBackground,
        error: DuneColors.error,
        onPrimary: DuneColors.primaryBackground,
        onSecondary: DuneColors.primaryBackground,
        onSurface: DuneColors.primaryText,
        onBackground: DuneColors.primaryText,
        onError: DuneColors.primaryText,
      ),

      // Scaffold
      scaffoldBackgroundColor: DuneColors.primaryBackground,

      // AppBar
      appBarTheme: const AppBarTheme(
        backgroundColor: DuneColors.secondaryBackground,
        foregroundColor: DuneColors.primaryText,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: DuneColors.primaryText,
        ),
      ),

      // Card
      cardTheme: CardThemeData(
        color: DuneColors.tertiaryBackground,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),

      // Input Decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: DuneColors.tertiaryBackground,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: DuneColors.borderColor,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: DuneColors.borderColor,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: DuneColors.focusRing,
            width: 2,
          ),
        ),
        labelStyle: const TextStyle(
          color: DuneColors.secondaryText,
        ),
        hintStyle: const TextStyle(
          color: DuneColors.mutedText,
        ),
      ),

      // Button Themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: DuneColors.buttonPrimary,
          foregroundColor: DuneColors.primaryBackground,
          elevation: 2,
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 12,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: DuneColors.link,
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: DuneColors.primaryText,
          side: const BorderSide(
            color: DuneColors.borderColor,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),

      // Text Theme
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          color: DuneColors.primaryText,
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
        displayMedium: TextStyle(
          color: DuneColors.primaryText,
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
        displaySmall: TextStyle(
          color: DuneColors.primaryText,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        headlineLarge: TextStyle(
          color: DuneColors.primaryText,
          fontSize: 22,
          fontWeight: FontWeight.w600,
        ),
        headlineMedium: TextStyle(
          color: DuneColors.primaryText,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        headlineSmall: TextStyle(
          color: DuneColors.primaryText,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        titleLarge: TextStyle(
          color: DuneColors.primaryText,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        titleMedium: TextStyle(
          color: DuneColors.primaryText,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        titleSmall: TextStyle(
          color: DuneColors.primaryText,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: TextStyle(
          color: DuneColors.primaryText,
          fontSize: 16,
        ),
        bodyMedium: TextStyle(
          color: DuneColors.primaryText,
          fontSize: 14,
        ),
        bodySmall: TextStyle(
          color: DuneColors.secondaryText,
          fontSize: 12,
        ),
        labelLarge: TextStyle(
          color: DuneColors.primaryText,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        labelMedium: TextStyle(
          color: DuneColors.secondaryText,
          fontSize: 12,
        ),
        labelSmall: TextStyle(
          color: DuneColors.mutedText,
          fontSize: 10,
        ),
      ),

      // Icon Theme
      iconTheme: const IconThemeData(
        color: DuneColors.primaryText,
        size: 24,
      ),

      // Divider
      dividerTheme: const DividerThemeData(
        color: DuneColors.borderColor,
        thickness: 1,
        space: 1,
      ),

      // Dialog
      dialogTheme: DialogThemeData(
        backgroundColor: DuneColors.secondaryBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),

      // Snackbar
      snackBarTheme: SnackBarThemeData(
        backgroundColor: DuneColors.tertiaryBackground,
        contentTextStyle: const TextStyle(
          color: DuneColors.primaryText,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}

