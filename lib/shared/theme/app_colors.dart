import 'package:flutter/material.dart';

/// Dune-inspired color palette (copyright-safe)
/// 
/// This color scheme is inspired by desert/sand aesthetics
/// without infringing on any copyrighted material.
class DuneColors {
  // Background Colors
  static const primaryBackground = Color(0xFF1A1612); // Deep desert night
  static const secondaryBackground = Color(0xFF2B2419); // Dark sand
  static const tertiaryBackground = Color(0xFF3D3528); // Sand dune
  static const quaternaryBackground = Color(0xFF4A4132); // Light sand dune
  static const borderColor = Color(0xFF5A4F3F); // Subtle sand

  // Text Colors
  static const primaryText = Color(0xFFE8DCC8); // Warm sand
  static const secondaryText = Color(0xFFD4C4B0); // Desert sand
  static const mutedText = Color(0xFF9A8B7A); // Muted sand

  // Status Colors - Safe (> 24 hours)
  static const safePrimary = Color(0xFFD4A574); // Spice gold
  static const safeSecondary = Color(0xFFC9A961); // Golden sand
  static const safeAccent = Color(0xFFE6B84F); // Amber

  // Status Colors - Warning (24-12 hours)
  static const warningPrimary = Color(0xFFE6B84F); // Desert amber
  static const warningSecondary = Color(0xFFD4A574); // Spice gold
  static const warningAccent = Color(0xFFF0C85A); // Bright amber

  // Status Colors - Caution (12-6 hours)
  static const cautionPrimary = Color(0xFFC97D60); // Burnt orange
  static const cautionSecondary = Color(0xFFB85D47); // Rust
  static const cautionAccent = Color(0xFFD98B6F); // Light rust

  // Status Colors - Critical (< 6 hours)
  static const criticalPrimary = Color(0xFFA84D3A); // Deep rust
  static const criticalSecondary = Color(0xFF8B3A2A); // Terracotta
  static const criticalAccent = Color(0xFFC95D4A); // Bright rust

  // Accent Colors
  static const primaryAccent = Color(0xFFD4A574); // Spice gold
  static const secondaryAccent = Color(0xFFE6B84F); // Desert amber

  // Semantic Colors
  static const success = Color(0xFF8B9A6B); // Sage green (subtle, desert-appropriate)
  static const error = Color(0xFFA84D3A); // Deep rust
  static const info = Color(0xFF6B8B9A); // Desert blue (subtle)

  // Interactive Elements
  static const buttonPrimary = Color(0xFFD4A574);
  static const buttonPrimaryHover = Color(0xFFE6B84F);
  static const buttonSecondary = Color(0xFF4A4132);
  static const buttonSecondaryHover = Color(0xFF5A4F3F);
  static const link = Color(0xFFE6B84F);
  static const linkHover = Color(0xFFF0C85A);
  static const focusRing = Color(0xFFE6B84F);

  /// Get status color based on hours remaining
  static Color getStatusColor(double hoursRemaining) {
    if (hoursRemaining > 24) {
      return safePrimary;
    } else if (hoursRemaining > 12) {
      return warningPrimary;
    } else if (hoursRemaining > 6) {
      return cautionPrimary;
    } else {
      return criticalPrimary;
    }
  }

  /// Get status color name for accessibility
  static String getStatusColorName(double hoursRemaining) {
    if (hoursRemaining > 24) {
      return 'Safe';
    } else if (hoursRemaining > 12) {
      return 'Warning';
    } else if (hoursRemaining > 6) {
      return 'Caution';
    } else {
      return 'Critical';
    }
  }
}

/// Alias for backwards compatibility
/// Some parts of the codebase use AppColors instead of DuneColors
class AppColors {
  // Background Colors
  static const background = DuneColors.primaryBackground;
  static const cardBackground = DuneColors.tertiaryBackground;
  
  // Text Colors
  static const textPrimary = DuneColors.primaryText;
  static const textSecondary = DuneColors.secondaryText;
  
  // Status Colors
  static const criticalStatus = DuneColors.criticalPrimary;
  static const warningYellow = DuneColors.warningPrimary;
  static const safeGreen = DuneColors.success;
  
  // Accent Colors
  static const primaryAccent = DuneColors.primaryAccent;
}
