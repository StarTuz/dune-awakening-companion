import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Font size scale options
enum FontSizeOption {
  small,   // 0.85
  medium,  // 1.0 (default)
  large,   // 1.15
  xl,      // 1.3
}

/// Font weight options
enum FontWeightOption {
  light,   // FontWeight.w300
  regular, // FontWeight.w400 (default)
  bold,    // FontWeight.w600
}

/// Accessibility settings state
class AccessibilitySettings {
  final FontSizeOption fontSize;
  final FontWeightOption fontWeight;
  final bool highContrast;
  final bool reducedMotion;

  const AccessibilitySettings({
    this.fontSize = FontSizeOption.medium,
    this.fontWeight = FontWeightOption.regular,
    this.highContrast = false,
    this.reducedMotion = false,
  });

  AccessibilitySettings copyWith({
    FontSizeOption? fontSize,
    FontWeightOption? fontWeight,
    bool? highContrast,
    bool? reducedMotion,
  }) {
    return AccessibilitySettings(
      fontSize: fontSize ?? this.fontSize,
      fontWeight: fontWeight ?? this.fontWeight,
      highContrast: highContrast ?? this.highContrast,
      reducedMotion: reducedMotion ?? this.reducedMotion,
    );
  }

  /// Get the text scale factor for MediaQuery
  double get textScaleFactor {
    switch (fontSize) {
      case FontSizeOption.small:
        return 0.85;
      case FontSizeOption.medium:
        return 1.0;
      case FontSizeOption.large:
        return 1.15;
      case FontSizeOption.xl:
        return 1.3;
    }
  }

  /// Get FontWeight for text themes
  FontWeight get fontWeightValue {
    switch (fontWeight) {
      case FontWeightOption.light:
        return FontWeight.w300;
      case FontWeightOption.regular:
        return FontWeight.w400;
      case FontWeightOption.bold:
        return FontWeight.w600;
    }
  }

  /// Get display name for font size
  static String getFontSizeDisplayName(FontSizeOption option) {
    switch (option) {
      case FontSizeOption.small:
        return 'Small';
      case FontSizeOption.medium:
        return 'Medium';
      case FontSizeOption.large:
        return 'Large';
      case FontSizeOption.xl:
        return 'Extra Large';
    }
  }

  /// Get display name for font weight
  static String getFontWeightDisplayName(FontWeightOption option) {
    switch (option) {
      case FontWeightOption.light:
        return 'Light';
      case FontWeightOption.regular:
        return 'Regular';
      case FontWeightOption.bold:
        return 'Bold';
    }
  }
}

/// Accessibility settings provider
final accessibilityProvider = StateNotifierProvider<AccessibilityNotifier, AccessibilitySettings>((ref) {
  return AccessibilityNotifier();
});

/// Notifier for accessibility settings with persistence
class AccessibilityNotifier extends StateNotifier<AccessibilitySettings> {
  AccessibilityNotifier() : super(const AccessibilitySettings()) {
    _loadSettings();
  }

  static const String _kFontSizeKey = 'accessibility_font_size';
  static const String _kFontWeightKey = 'accessibility_font_weight';
  static const String _kHighContrastKey = 'accessibility_high_contrast';
  static const String _kReducedMotionKey = 'accessibility_reduced_motion';

  /// Load saved settings from SharedPreferences
  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    
    final fontSizeIndex = prefs.getInt(_kFontSizeKey) ?? FontSizeOption.medium.index;
    final fontWeightIndex = prefs.getInt(_kFontWeightKey) ?? FontWeightOption.regular.index;
    final highContrast = prefs.getBool(_kHighContrastKey) ?? false;
    final reducedMotion = prefs.getBool(_kReducedMotionKey) ?? false;

    state = AccessibilitySettings(
      fontSize: FontSizeOption.values[fontSizeIndex.clamp(0, FontSizeOption.values.length - 1)],
      fontWeight: FontWeightOption.values[fontWeightIndex.clamp(0, FontWeightOption.values.length - 1)],
      highContrast: highContrast,
      reducedMotion: reducedMotion,
    );
  }

  /// Set font size
  Future<void> setFontSize(FontSizeOption size) async {
    state = state.copyWith(fontSize: size);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_kFontSizeKey, size.index);
  }

  /// Set font weight
  Future<void> setFontWeight(FontWeightOption weight) async {
    state = state.copyWith(fontWeight: weight);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_kFontWeightKey, weight.index);
  }

  /// Set high contrast mode
  Future<void> setHighContrast(bool enabled) async {
    state = state.copyWith(highContrast: enabled);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kHighContrastKey, enabled);
  }

  /// Set reduced motion
  Future<void> setReducedMotion(bool enabled) async {
    state = state.copyWith(reducedMotion: enabled);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kReducedMotionKey, enabled);
  }

  /// Reset all accessibility settings to defaults
  Future<void> resetToDefaults() async {
    state = const AccessibilitySettings();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kFontSizeKey);
    await prefs.remove(_kFontWeightKey);
    await prefs.remove(_kHighContrastKey);
    await prefs.remove(_kReducedMotionKey);
  }
}
