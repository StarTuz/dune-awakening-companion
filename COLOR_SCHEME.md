# Dune-Inspired Color Scheme

## Color Palette (Copyright-Safe)

### Background Colors
- **Primary Background (Deep Desert Night)**: `#1A1612` or `#2B2419`
  - Main app background, dark and immersive
- **Secondary Background (Sand Dune)**: `#3D3528` or `#4A4132`
  - Cards, panels, elevated surfaces
- **Tertiary Background**: `#5A4F3F`
  - Subtle borders, dividers

### Text Colors
- **Primary Text (Warm Sand)**: `#E8DCC8` or `#F5EDDC`
  - Main text, high contrast
- **Secondary Text (Desert Sand)**: `#D4C4B0` or `#C9B8A3`
  - Secondary text, labels
- **Muted Text**: `#9A8B7A`
  - Disabled text, hints

### Status Colors (Power Remaining)

#### Safe (> 24 hours)
- **Primary**: `#D4A574` (Spice Gold)
- **Secondary**: `#C9A961` (Golden Sand)
- **Accent**: `#E6B84F` (Amber)

#### Warning (24-12 hours)
- **Primary**: `#E6B84F` (Desert Amber)
- **Secondary**: `#D4A574` (Spice Gold)
- **Accent**: `#F0C85A` (Bright Amber)

#### Caution (12-6 hours)
- **Primary**: `#C97D60` (Burnt Orange)
- **Secondary**: `#B85D47` (Rust)
- **Accent**: `#D98B6F` (Light Rust)

#### Critical (< 6 hours)
- **Primary**: `#A84D3A` (Deep Rust)
- **Secondary**: `#8B3A2A` (Terracotta)
- **Accent**: `#C95D4A` (Bright Rust)

### Accent Colors
- **Primary Accent**: `#D4A574` (Spice Gold)
- **Secondary Accent**: `#E6B84F` (Desert Amber)
- **Success**: `#8B9A6B` (Sage Green - subtle, desert-appropriate)
- **Error**: `#A84D3A` (Deep Rust)
- **Info**: `#6B8B9A` (Desert Blue - subtle)

### Interactive Elements
- **Button Primary**: `#D4A574` with hover `#E6B84F`
- **Button Secondary**: `#4A4132` with hover `#5A4F3F`
- **Link**: `#E6B84F` with hover `#F0C85A`
- **Border**: `#5A4F3F`
- **Focus Ring**: `#E6B84F` with opacity

## Usage Guidelines

1. **Maintain Contrast**: Ensure text is readable on all backgrounds
2. **Status Indicators**: Use color coding consistently for power status
3. **Subtle Gradients**: Can use subtle gradients between similar shades
4. **Dark Theme Only**: This palette is designed for dark theme
5. **Accessibility**: Test color combinations for WCAG AA compliance

## Flutter Theme Implementation

```dart
// Example color definitions
class DuneColors {
  // Backgrounds
  static const Color primaryBackground = Color(0xFF1A1612);
  static const Color secondaryBackground = Color(0xFF3D3528);
  static const Color tertiaryBackground = Color(0xFF5A4F3F);
  
  // Text
  static const Color primaryText = Color(0xFFE8DCC8);
  static const Color secondaryText = Color(0xFFD4C4B0);
  static const Color mutedText = Color(0xFF9A8B7A);
  
  // Status - Safe
  static const Color safePrimary = Color(0xFFD4A574);
  static const Color safeSecondary = Color(0xFFC9A961);
  
  // Status - Warning
  static const Color warningPrimary = Color(0xFFE6B84F);
  static const Color warningSecondary = Color(0xFFD4A574);
  
  // Status - Caution
  static const Color cautionPrimary = Color(0xFFC97D60);
  static const Color cautionSecondary = Color(0xFFB85D47);
  
  // Status - Critical
  static const Color criticalPrimary = Color(0xFFA84D3A);
  static const Color criticalSecondary = Color(0xFF8B3A2A);
  
  // Accents
  static const Color primaryAccent = Color(0xFFD4A574);
  static const Color secondaryAccent = Color(0xFFE6B84F);
}
```

