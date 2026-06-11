import 'package:flutter/material.dart';

/// Central theme constants for the Staff Dashboard.
/// White + Blue palette matching the Figma design.
class AppColors {
  AppColors._();

  // ── Primary Blue Scale ─────────────────────────────────
  static const Color primary = Color(0xFF1D4ED8);       // Blue-700
  static const Color primaryLight = Color(0xFF3B82F6);  // Blue-500
  static const Color primarySoft = Color(0xFFEFF6FF);   // Blue-50
  static const Color primaryBorder = Color(0xFFBFDBFE); // Blue-200

  // ── Neutral / White Scale ──────────────────────────────
  static const Color white = Color(0xFFFFFFFF);
  static const Color background = Color(0xFFF8FAFF);    // Off-white with blue tint
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceSecondary = Color(0xFFF1F5F9); // Slate-100
  static const Color border = Color(0xFFE2E8F0);        // Slate-200
  static const Color divider = Color(0xFFEFF6FF);

  // ── Text ──────────────────────────────────────────────
  static const Color textPrimary = Color(0xFF0F172A);   // Slate-900
  static const Color textSecondary = Color(0xFF475569); // Slate-600
  static const Color textMuted = Color(0xFF94A3B8);     // Slate-400
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // ── Status Colors ─────────────────────────────────────
  static const Color success = Color(0xFF10B981);
  static const Color successSoft = Color(0xFFD1FAE5);
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningSoft = Color(0xFFFEF3C7);
  static const Color error = Color(0xFFEF4444);
  static const Color errorSoft = Color(0xFFFEE2E2);
  static const Color info = Color(0xFF3B82F6);
  static const Color infoSoft = Color(0xFFEFF6FF);

  // ── Repair Status Colors ──────────────────────────────
  static Color statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'in progress':
        return primary;
      case 'waiting parts':
        return warning;
      case 'ready':
        return success;
      case 'completed':
        return success;
      case 'pending':
        return textMuted;
      default:
        return textMuted;
    }
  }

  static Color statusBg(String status) {
    switch (status.toLowerCase()) {
      case 'in progress':
        return primarySoft;
      case 'waiting parts':
        return warningSoft;
      case 'ready':
        return successSoft;
      case 'completed':
        return successSoft;
      case 'pending':
        return surfaceSecondary;
      default:
        return surfaceSecondary;
    }
  }
}

class AppTextStyles {
  AppTextStyles._();

  static const TextStyle displayLarge = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: -0.5,
    height: 1.2,
  );

  static const TextStyle headingMedium = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    letterSpacing: -0.3,
  );

  static const TextStyle headingSmall = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.5,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textMuted,
    height: 1.4,
  );

  static const TextStyle label = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    color: AppColors.textMuted,
    letterSpacing: 0.5,
  );

  static const TextStyle statNumber = TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.w800,
    color: AppColors.textPrimary,
    letterSpacing: -0.5,
  );
}

class AppTheme {
  AppTheme._();

  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.light,
        surface: AppColors.background,
      ),
      scaffoldBackgroundColor: AppColors.background,
      fontFamily: 'SF Pro Display', // Falls back to system font gracefully
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.white,
        elevation: 0,
        scrolledUnderElevation: 1,
        iconTheme: IconThemeData(color: AppColors.textPrimary),
        titleTextStyle: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 17,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}