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

/// Light mode color palette - Desert Day
/// Inverted palette for light theme while maintaining Dune aesthetic
class DuneColorsLight {
  // Background Colors - Light sand tones
  static const primaryBackground = Color(0xFFF5F0E8); // Warm cream
  static const secondaryBackground = Color(0xFFEDE6DA); // Light sand
  static const tertiaryBackground = Color(0xFFE5DDD0); // Pale dune
  static const quaternaryBackground = Color(0xFFDDD4C5); // Sandy beige
  static const borderColor = Color(0xFFCCC2B0); // Muted tan

  // Text Colors - Dark for readability
  static const primaryText = Color(0xFF2B2419); // Dark brown
  static const secondaryText = Color(0xFF4A4132); // Medium brown
  static const mutedText = Color(0xFF7A7060); // Muted brown

  // Status Colors - Same as dark theme for consistency
  static const safePrimary = Color(0xFFC49A64); // Darker spice gold
  static const safeSecondary = Color(0xFFB98F51); // Darker golden sand
  static const safeAccent = Color(0xFFD6A83F); // Darker amber

  static const warningPrimary = Color(0xFFD6A83F); // Darker amber
  static const warningSecondary = Color(0xFFC49A64); // Darker spice gold
  static const warningAccent = Color(0xFFE0B84A); // Medium amber

  static const cautionPrimary = Color(0xFFB96D50); // Darker burnt orange
  static const cautionSecondary = Color(0xFFA84D37); // Darker rust
  static const cautionAccent = Color(0xFFC97B5F); // Medium rust

  static const criticalPrimary = Color(0xFF983D2A); // Deep rust (darker)
  static const criticalSecondary = Color(0xFF7B2A1A); // Dark terracotta
  static const criticalAccent = Color(0xFFB94D3A); // Medium rust

  // Accent Colors - Slightly darker for light backgrounds
  static const primaryAccent = Color(0xFFC49A64); // Darker spice gold
  static const secondaryAccent = Color(0xFFD6A83F); // Darker amber

  // Semantic Colors
  static const success = Color(0xFF7B8A5B); // Darker sage green
  static const error = Color(0xFF983D2A); // Darker rust
  static const info = Color(0xFF5B7B8A); // Darker desert blue

  // Interactive Elements
  static const buttonPrimary = Color(0xFFC49A64);
  static const buttonPrimaryHover = Color(0xFFD6A83F);
  static const buttonSecondary = Color(0xFFDDD4C5);
  static const buttonSecondaryHover = Color(0xFFCCC2B0);
  static const link = Color(0xFFB98F51);
  static const linkHover = Color(0xFFD6A83F);
  static const focusRing = Color(0xFFD6A83F);

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
}

// =============================================================================
// FACTION THEMES
// =============================================================================

/// House Atreides - Green & Black (The Noble House)
class AtreidesColors {
  // Background Colors - Dark with green undertones
  static const primaryBackground = Color(0xFF0D1A12); // Deep forest night
  static const secondaryBackground = Color(0xFF162419); // Dark moss
  static const tertiaryBackground = Color(0xFF1F3022); // Forest shadow
  static const quaternaryBackground = Color(0xFF283D2B); // Moss green
  static const borderColor = Color(0xFF3A5A3D); // Muted emerald

  // Text Colors
  static const primaryText = Color(0xFFE8F0E8); // Pale sage
  static const secondaryText = Color(0xFFC4D4C4); // Light sage
  static const mutedText = Color(0xFF8AA88A); // Muted green

  // Accent Colors - Atreides Green & Gold
  static const primaryAccent = Color(0xFF4A8C5A); // Atreides green
  static const secondaryAccent = Color(0xFFD4AF37); // Noble gold

  // Semantic Colors
  static const success = Color(0xFF6B9B6B); // Sage green
  static const error = Color(0xFFB85D4A); // Muted red
  static const info = Color(0xFF5A8A9A); // Teal

  // Interactive Elements
  static const buttonPrimary = Color(0xFF4A8C5A);
  static const buttonSecondary = Color(0xFF283D2B);
  static const focusRing = Color(0xFFD4AF37);
}

/// House Harkonnen - Red & Black (The Brutal Rulers)
class HarkonnenColors {
  // Background Colors - Deep black with red undertones
  static const primaryBackground = Color(0xFF0F0A0A); // Obsidian black
  static const secondaryBackground = Color(0xFF1A1212); // Dark blood
  static const tertiaryBackground = Color(0xFF261818); // Charred ember
  static const quaternaryBackground = Color(0xFF331F1F); // Dark crimson shadow
  static const borderColor = Color(0xFF4A2A2A); // Dried blood

  // Text Colors
  static const primaryText = Color(0xFFF0E8E8); // Pale bone
  static const secondaryText = Color(0xFFD4C4C4); // Ash
  static const mutedText = Color(0xFF9A7A7A); // Dusty rose

  // Accent Colors - Harkonnen Red & Orange
  static const primaryAccent = Color(0xFFC94A3A); // Blood red
  static const secondaryAccent = Color(0xFFE86A4A); // Flame orange

  // Semantic Colors
  static const success = Color(0xFF7A9A6B); // Muted green
  static const error = Color(0xFFE84A3A); // Bright red
  static const info = Color(0xFF6A7A9A); // Steel blue

  // Interactive Elements
  static const buttonPrimary = Color(0xFFC94A3A);
  static const buttonSecondary = Color(0xFF331F1F);
  static const focusRing = Color(0xFFE86A4A);
}

/// Fremen - Tan & Blue (The Desert Warriors)
class FremenColors {
  // Background Colors - Desert sand with blue accents
  static const primaryBackground = Color(0xFF1A1814); // Desert night
  static const secondaryBackground = Color(0xFF26231C); // Warm sand shadow
  static const tertiaryBackground = Color(0xFF332F26); // Dune
  static const quaternaryBackground = Color(0xFF403A30); // Light dune
  static const borderColor = Color(0xFF5A5040); // Sandy border

  // Text Colors
  static const primaryText = Color(0xFFF0EBE0); // Cream
  static const secondaryText = Color(0xFFD4CCBC); // Light sand
  static const mutedText = Color(0xFF9A8A70); // Dusty sand

  // Accent Colors - Fremen Blue (stillsuit eyes) & Sand
  static const primaryAccent = Color(0xFF4A7AC9); // Spice blue (blue-within-blue)
  static const secondaryAccent = Color(0xFFD4B896); // Desert gold

  // Semantic Colors
  static const success = Color(0xFF8A9A6B); // Sage
  static const error = Color(0xFFB8604A); // Rust
  static const info = Color(0xFF4A7AC9); // Spice blue

  // Interactive Elements
  static const buttonPrimary = Color(0xFF4A7AC9);
  static const buttonSecondary = Color(0xFF403A30);
  static const focusRing = Color(0xFF6A9AE9);
}

/// Smuggler - Purple & Bronze (The Shadow Traders)
class SmugglerColors {
  // Background Colors - Dark purple/grey
  static const primaryBackground = Color(0xFF12101A); // Shadow night
  static const secondaryBackground = Color(0xFF1A1824); // Dark violet
  static const tertiaryBackground = Color(0xFF24222F); // Dusk
  static const quaternaryBackground = Color(0xFF2F2C3A); // Twilight
  static const borderColor = Color(0xFF4A4560); // Muted purple

  // Text Colors
  static const primaryText = Color(0xFFE8E6F0); // Pale lavender
  static const secondaryText = Color(0xFFC8C4D8); // Light purple
  static const mutedText = Color(0xFF8A86A0); // Muted violet

  // Accent Colors - Smuggler Purple & Bronze
  static const primaryAccent = Color(0xFF8A6AC9); // Deep purple
  static const secondaryAccent = Color(0xFFCD7F32); // Bronze

  // Semantic Colors
  static const success = Color(0xFF7A9A7A); // Muted green
  static const error = Color(0xFFB8504A); // Rusty red
  static const info = Color(0xFF6A8AC9); // Soft blue

  // Interactive Elements
  static const buttonPrimary = Color(0xFF8A6AC9);
  static const buttonSecondary = Color(0xFF2F2C3A);
  static const focusRing = Color(0xFFCD7F32);
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
