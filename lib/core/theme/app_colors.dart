import 'package:flutter/material.dart';

class AppColors {
  // ============================================
  // MODERN BANKING APP THEME
  // ============================================
  
  // Primary Colors - Clean & Professional
  static const Color background = Color(0xFFE8EBF0);        // Medium gray background (daha koyu)
  static const Color backgroundDark = Color(0xFF121212);     // Dark background
  
  // Surface Colors - Card backgrounds
  static const Color surface = Color(0xFFFFFFFF);           // White
  static const Color surfaceElevated = Color(0xFFFFFFFF);   // White elevated
  static const Color surfaceLight = Color(0xFFF5F7FA);      // Very light gray
  static const Color surfaceDark = Color(0xFF1E1E1E);       // Dark surface
  
  // Brand Colors - Strong Contrast Green
  static const Color accent = Color(0xFF00E676);            // Vibrant green (Material Green A400)
  static const Color accentDark = Color(0xFF00C853);        // Dark green (Material Green A700)
  static const Color accentLight = Color(0xFF69F0AE);       // Light green
  
  // Secondary Accent - Black buttons
  static const Color buttonPrimary = Color(0xFF000000);     // Black
  static const Color buttonSecondary = Color(0xFF1A1A1A);   // Very dark gray
  
  // Text Colors - Professional contrast
  static const Color text = Color(0xFF1A1A1A);              // Almost black
  static const Color textLight = Color(0xFF6B7280);         // Gray
  static const Color textDark = Color(0xFF000000);          // Pure black
  static const Color textMuted = Color(0xFF9CA3AF);         // Light gray
  
  // Glass Material Colors (for overlays)
  static const Color glassLight = Color(0x26FFFFFF);        // 15% white
  static const Color glassMedium = Color(0x1AFFFFFF);       // 10% white
  static const Color glassDark = Color(0x0DFFFFFF);         // 5% white
  static const Color glassBorder = Color(0x4DFFFFFF);       // 30% white
  static const Color glassBorderLight = Color(0x33FFFFFF);  // 20% white
  
  // Vibrant Category Colors
  static const Color vibrantBlue = Color(0xFF667EEA);       // Electric blue
  static const Color vibrantPurple = Color(0xFF764BA2);     // Deep purple
  static const Color vibrantPink = Color(0xFFF093FB);       // Bright pink
  static const Color vibrantCyan = Color(0xFF4FACFE);       // Cyan blue
  static const Color vibrantOrange = Color(0xFFFF6B6B);     // Coral orange
  static const Color vibrantGreen = Color(0xFF4ECDC4);      // Teal green
  
  // Kategori Renkleri - Professional & Vibrant
  static const Color elementary = Color(0xFF4ECDC4);        // Teal cyan
  static const Color elementaryDark = Color(0xFF3DBAA8);    // Dark teal
  static const Color elementaryLight = Color(0xFFE0F7F5);   // Very light teal
  
  static const Color middle = Color(0xFF667EEA);            // Electric blue
  static const Color middleDark = Color(0xFF4F46E5);        // Dark blue
  static const Color middleLight = Color(0xFFE8EBFD);       // Very light blue
  
  static const Color high = Color(0xFFF093FB);              // Bright pink
  static const Color highDark = Color(0xFFD565E8);          // Dark pink
  static const Color highLight = Color(0xFFFCE8FE);         // Very light pink
  
  static const Color adult = Color(0xFFFF6B6B);             // Coral red
  static const Color adultDark = Color(0xFFE85555);         // Dark coral
  static const Color adultLight = Color(0xFFFFE5E5);        // Very light coral
  
  // Durum Renkleri - Professional & Elegant
  static const Color success = Color(0xFF10B981);           // Modern emerald green
  static const Color successLight = Color(0xFFD1FAE5);      // Very light emerald
  static const Color successDark = Color(0xFF059669);       // Dark emerald
  
  static const Color error = Color(0xFFEF4444);             // Modern red
  static const Color errorLight = Color(0xFFFEE2E2);        // Very light red
  static const Color errorDark = Color(0xFFDC2626);         // Dark red
  
  static const Color warning = Color(0xFFF59E0B);           // Modern amber
  static const Color warningLight = Color(0xFFFEF3C7);      // Very light amber
  static const Color warningDark = Color(0xFFD97706);       // Dark amber
  
  static const Color info = Color(0xFF3B82F6);              // Modern blue
  static const Color infoLight = Color(0xFFDCE7FE);         // Very light blue
  static const Color infoDark = Color(0xFF2563EB);          // Dark blue
  
  // Shadow & Glow - Professional shadows
  static const Color shadow = Color(0x1A000000);            // 10% black shadow
  static const Color shadowLight = Color(0x0D000000);       // 5% black shadow
  static const Color shadowStrong = Color(0x26000000);      // 15% black shadow
  
  // Glow effects for colored elements
  static Color accentGlow = accent.withOpacity(0.3);
  static Color successGlow = success.withOpacity(0.3);
  static Color errorGlow = error.withOpacity(0.3);
  static Color warningGlow = warning.withOpacity(0.3);
  static Color infoGlow = info.withOpacity(0.3);
  
  // Overlay Colors
  static const Color overlay = Color(0xCC000000);           // 80% opacity
  static const Color overlayLight = Color(0x66000000);      // 40% opacity
  
  // Border Colors - Professional borders
  static const Color border = Color(0xFFE5E7EB);            // Light gray
  static const Color borderLight = Color(0xFFF3F4F6);       // Very light gray
  static const Color borderDark = Color(0xFFD1D5DB);        // Gray
  
  // Gradient Colors - Vibrant mesh gradients
  static const Color gradientStart = Color(0xFF667EEA);     // Electric blue
  static const Color gradientEnd = Color(0xFFF093FB);       // Bright pink
  
  // Helper method - Category color mapping
  static Color getCategoryColor(String category) {
    switch (category) {
      case 'elementary':
        return elementary;
      case 'middle_school':
        return middle;
      case 'high_school':
        return high;
      case 'adult':
        return adult;
      default:
        return info;
    }
  }
  
  static Color getCategoryDarkColor(String category) {
    switch (category) {
      case 'elementary':
        return elementaryDark;
      case 'middle_school':
        return middleDark;
      case 'high_school':
        return highDark;
      case 'adult':
        return adultDark;
      default:
        return infoDark;
    }
  }
  
  static Color getCategoryLightColor(String category) {
    switch (category) {
      case 'elementary':
        return elementaryLight;
      case 'middle_school':
        return middleLight;
      case 'high_school':
        return highLight;
      case 'adult':
        return adultLight;
      default:
        return infoLight;
    }
  }
} 