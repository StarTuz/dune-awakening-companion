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

      // Tooltip - Dune themed
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: DuneColors.quaternaryBackground,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: DuneColors.primaryAccent.withOpacity(0.5),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        textStyle: const TextStyle(
          color: DuneColors.primaryText,
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        waitDuration: const Duration(milliseconds: 500),
        showDuration: const Duration(seconds: 2),
      ),
    );
  }

  /// Light theme - Desert Day
  static ThemeData get duneLightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      
      // Color Scheme
      colorScheme: ColorScheme.light(
        primary: DuneColorsLight.primaryAccent,
        secondary: DuneColorsLight.secondaryAccent,
        surface: DuneColorsLight.secondaryBackground,
        background: DuneColorsLight.primaryBackground,
        error: DuneColorsLight.error,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: DuneColorsLight.primaryText,
        onBackground: DuneColorsLight.primaryText,
        onError: Colors.white,
      ),

      // Scaffold
      scaffoldBackgroundColor: DuneColorsLight.primaryBackground,

      // AppBar
      appBarTheme: const AppBarTheme(
        backgroundColor: DuneColorsLight.secondaryBackground,
        foregroundColor: DuneColorsLight.primaryText,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(
          color: DuneColorsLight.primaryText,
        ),
      ),

      // Card
      cardTheme: CardThemeData(
        color: DuneColorsLight.tertiaryBackground,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),

      // Input Decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: DuneColorsLight.tertiaryBackground,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: DuneColorsLight.borderColor,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: DuneColorsLight.borderColor,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: DuneColorsLight.focusRing,
            width: 2,
          ),
        ),
        labelStyle: const TextStyle(
          color: DuneColorsLight.secondaryText,
        ),
        hintStyle: const TextStyle(
          color: DuneColorsLight.mutedText,
        ),
      ),

      // Button Themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: DuneColorsLight.buttonPrimary,
          foregroundColor: Colors.white,
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
          foregroundColor: DuneColorsLight.link,
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: DuneColorsLight.primaryText,
          side: const BorderSide(
            color: DuneColorsLight.borderColor,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),

      // Text Theme
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          color: DuneColorsLight.primaryText,
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
        displayMedium: TextStyle(
          color: DuneColorsLight.primaryText,
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
        displaySmall: TextStyle(
          color: DuneColorsLight.primaryText,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        headlineLarge: TextStyle(
          color: DuneColorsLight.primaryText,
          fontSize: 22,
          fontWeight: FontWeight.w600,
        ),
        headlineMedium: TextStyle(
          color: DuneColorsLight.primaryText,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        headlineSmall: TextStyle(
          color: DuneColorsLight.primaryText,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        titleLarge: TextStyle(
          color: DuneColorsLight.primaryText,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        titleMedium: TextStyle(
          color: DuneColorsLight.primaryText,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        titleSmall: TextStyle(
          color: DuneColorsLight.primaryText,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: TextStyle(
          color: DuneColorsLight.primaryText,
          fontSize: 16,
        ),
        bodyMedium: TextStyle(
          color: DuneColorsLight.primaryText,
          fontSize: 14,
        ),
        bodySmall: TextStyle(
          color: DuneColorsLight.secondaryText,
          fontSize: 12,
        ),
        labelLarge: TextStyle(
          color: DuneColorsLight.primaryText,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        labelMedium: TextStyle(
          color: DuneColorsLight.secondaryText,
          fontSize: 12,
        ),
        labelSmall: TextStyle(
          color: DuneColorsLight.mutedText,
          fontSize: 10,
        ),
      ),

      // Icon Theme
      iconTheme: const IconThemeData(
        color: DuneColorsLight.primaryText,
        size: 24,
      ),

      // Divider
      dividerTheme: const DividerThemeData(
        color: DuneColorsLight.borderColor,
        thickness: 1,
        space: 1,
      ),

      // Dialog
      dialogTheme: DialogThemeData(
        backgroundColor: DuneColorsLight.secondaryBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),

      // Snackbar
      snackBarTheme: SnackBarThemeData(
        backgroundColor: DuneColorsLight.quaternaryBackground,
        contentTextStyle: const TextStyle(
          color: DuneColorsLight.primaryText,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),

      // Tooltip - Light themed
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: DuneColorsLight.quaternaryBackground,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: DuneColorsLight.primaryAccent.withOpacity(0.5),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        textStyle: const TextStyle(
          color: DuneColorsLight.primaryText,
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        waitDuration: const Duration(milliseconds: 500),
        showDuration: const Duration(seconds: 2),
      ),
    );
  }

  // ===========================================================================
  // FACTION THEMES
  // ===========================================================================

  /// Get dark theme based on faction
  static ThemeData getDarkThemeForFaction(dynamic faction) {
    // Import is handled in the file that calls this
    final factionName = faction.toString().split('.').last;
    switch (factionName) {
      case 'atreides':
        return atreidesTheme;
      case 'harkonnen':
        return harkonnenTheme;
      case 'fremen':
        return fremenTheme;
      case 'smuggler':
        return smugglerTheme;
      case 'desert':
      default:
        return duneTheme;
    }
  }

  /// Get light theme based on faction (defaults to duneLightTheme for now)
  static ThemeData getLightThemeForFaction(dynamic faction) {
    // For now, all factions use the same light theme
    // Could be extended to have faction-specific light themes
    return duneLightTheme;
  }

  /// House Atreides Theme - Green & Black
  static ThemeData get atreidesTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        primary: AtreidesColors.primaryAccent,
        secondary: AtreidesColors.secondaryAccent,
        surface: AtreidesColors.secondaryBackground,
        background: AtreidesColors.primaryBackground,
        error: AtreidesColors.error,
        onPrimary: Colors.white,
        onSecondary: AtreidesColors.primaryBackground,
        onSurface: AtreidesColors.primaryText,
        onBackground: AtreidesColors.primaryText,
        onError: Colors.white,
      ),
      scaffoldBackgroundColor: AtreidesColors.primaryBackground,
      appBarTheme: const AppBarTheme(
        backgroundColor: AtreidesColors.secondaryBackground,
        foregroundColor: AtreidesColors.primaryText,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: AtreidesColors.primaryText),
      ),
      cardTheme: CardThemeData(
        color: AtreidesColors.tertiaryBackground,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AtreidesColors.tertiaryBackground,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AtreidesColors.borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AtreidesColors.borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AtreidesColors.focusRing, width: 2),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AtreidesColors.buttonPrimary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: AtreidesColors.primaryText),
        bodyMedium: TextStyle(color: AtreidesColors.primaryText),
        bodySmall: TextStyle(color: AtreidesColors.secondaryText),
      ),
      iconTheme: const IconThemeData(color: AtreidesColors.primaryText),
      dividerTheme: const DividerThemeData(color: AtreidesColors.borderColor),
      dialogTheme: DialogThemeData(
        backgroundColor: AtreidesColors.secondaryBackground,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AtreidesColors.tertiaryBackground,
        contentTextStyle: const TextStyle(color: AtreidesColors.primaryText),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: AtreidesColors.quaternaryBackground,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AtreidesColors.primaryAccent.withOpacity(0.5)),
        ),
        textStyle: const TextStyle(color: AtreidesColors.primaryText, fontSize: 13),
      ),
    );
  }

  /// House Harkonnen Theme - Red & Black
  static ThemeData get harkonnenTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        primary: HarkonnenColors.primaryAccent,
        secondary: HarkonnenColors.secondaryAccent,
        surface: HarkonnenColors.secondaryBackground,
        background: HarkonnenColors.primaryBackground,
        error: HarkonnenColors.error,
        onPrimary: Colors.white,
        onSecondary: HarkonnenColors.primaryBackground,
        onSurface: HarkonnenColors.primaryText,
        onBackground: HarkonnenColors.primaryText,
        onError: Colors.white,
      ),
      scaffoldBackgroundColor: HarkonnenColors.primaryBackground,
      appBarTheme: const AppBarTheme(
        backgroundColor: HarkonnenColors.secondaryBackground,
        foregroundColor: HarkonnenColors.primaryText,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: HarkonnenColors.primaryText),
      ),
      cardTheme: CardThemeData(
        color: HarkonnenColors.tertiaryBackground,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: HarkonnenColors.tertiaryBackground,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: HarkonnenColors.borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: HarkonnenColors.borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: HarkonnenColors.focusRing, width: 2),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: HarkonnenColors.buttonPrimary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: HarkonnenColors.primaryText),
        bodyMedium: TextStyle(color: HarkonnenColors.primaryText),
        bodySmall: TextStyle(color: HarkonnenColors.secondaryText),
      ),
      iconTheme: const IconThemeData(color: HarkonnenColors.primaryText),
      dividerTheme: const DividerThemeData(color: HarkonnenColors.borderColor),
      dialogTheme: DialogThemeData(
        backgroundColor: HarkonnenColors.secondaryBackground,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: HarkonnenColors.tertiaryBackground,
        contentTextStyle: const TextStyle(color: HarkonnenColors.primaryText),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: HarkonnenColors.quaternaryBackground,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: HarkonnenColors.primaryAccent.withOpacity(0.5)),
        ),
        textStyle: const TextStyle(color: HarkonnenColors.primaryText, fontSize: 13),
      ),
    );
  }

  /// Fremen Theme - Tan & Blue
  static ThemeData get fremenTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        primary: FremenColors.primaryAccent,
        secondary: FremenColors.secondaryAccent,
        surface: FremenColors.secondaryBackground,
        background: FremenColors.primaryBackground,
        error: FremenColors.error,
        onPrimary: Colors.white,
        onSecondary: FremenColors.primaryBackground,
        onSurface: FremenColors.primaryText,
        onBackground: FremenColors.primaryText,
        onError: Colors.white,
      ),
      scaffoldBackgroundColor: FremenColors.primaryBackground,
      appBarTheme: const AppBarTheme(
        backgroundColor: FremenColors.secondaryBackground,
        foregroundColor: FremenColors.primaryText,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: FremenColors.primaryText),
      ),
      cardTheme: CardThemeData(
        color: FremenColors.tertiaryBackground,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: FremenColors.tertiaryBackground,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: FremenColors.borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: FremenColors.borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: FremenColors.focusRing, width: 2),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: FremenColors.buttonPrimary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: FremenColors.primaryText),
        bodyMedium: TextStyle(color: FremenColors.primaryText),
        bodySmall: TextStyle(color: FremenColors.secondaryText),
      ),
      iconTheme: const IconThemeData(color: FremenColors.primaryText),
      dividerTheme: const DividerThemeData(color: FremenColors.borderColor),
      dialogTheme: DialogThemeData(
        backgroundColor: FremenColors.secondaryBackground,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: FremenColors.tertiaryBackground,
        contentTextStyle: const TextStyle(color: FremenColors.primaryText),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: FremenColors.quaternaryBackground,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: FremenColors.primaryAccent.withOpacity(0.5)),
        ),
        textStyle: const TextStyle(color: FremenColors.primaryText, fontSize: 13),
      ),
    );
  }

  /// Smuggler Theme - Purple & Bronze
  static ThemeData get smugglerTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        primary: SmugglerColors.primaryAccent,
        secondary: SmugglerColors.secondaryAccent,
        surface: SmugglerColors.secondaryBackground,
        background: SmugglerColors.primaryBackground,
        error: SmugglerColors.error,
        onPrimary: Colors.white,
        onSecondary: SmugglerColors.primaryBackground,
        onSurface: SmugglerColors.primaryText,
        onBackground: SmugglerColors.primaryText,
        onError: Colors.white,
      ),
      scaffoldBackgroundColor: SmugglerColors.primaryBackground,
      appBarTheme: const AppBarTheme(
        backgroundColor: SmugglerColors.secondaryBackground,
        foregroundColor: SmugglerColors.primaryText,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: SmugglerColors.primaryText),
      ),
      cardTheme: CardThemeData(
        color: SmugglerColors.tertiaryBackground,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: SmugglerColors.tertiaryBackground,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: SmugglerColors.borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: SmugglerColors.borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: SmugglerColors.focusRing, width: 2),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: SmugglerColors.buttonPrimary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: SmugglerColors.primaryText),
        bodyMedium: TextStyle(color: SmugglerColors.primaryText),
        bodySmall: TextStyle(color: SmugglerColors.secondaryText),
      ),
      iconTheme: const IconThemeData(color: SmugglerColors.primaryText),
      dividerTheme: const DividerThemeData(color: SmugglerColors.borderColor),
      dialogTheme: DialogThemeData(
        backgroundColor: SmugglerColors.secondaryBackground,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: SmugglerColors.tertiaryBackground,
        contentTextStyle: const TextStyle(color: SmugglerColors.primaryText),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: SmugglerColors.quaternaryBackground,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: SmugglerColors.primaryAccent.withOpacity(0.5)),
        ),
        textStyle: const TextStyle(color: SmugglerColors.primaryText, fontSize: 13),
      ),
    );
  }
}
