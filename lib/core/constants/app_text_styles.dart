import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Application text style constants
/// Uses Syne (display) and DM Sans (body) fonts
abstract class AppTextStyles {
  // Headings - Syne font
  static const TextStyle headingLarge = TextStyle(
    fontFamily: 'Syne',
    fontSize: 30,
    fontWeight: FontWeight.bold,
    color: AppColors.kPrimaryText,
    height: 1.2,
  );

  static const TextStyle headingMedium = TextStyle(
    fontFamily: 'Syne',
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: AppColors.kPrimaryText,
    height: 1.3,
  );

  static const TextStyle headingSmall = TextStyle(
    fontFamily: 'Syne',
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.kPrimaryText,
    height: 1.4,
  );

  // Body - DM Sans font
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: 'DM Sans',
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.kPrimaryText,
    height: 1.5,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: 'DM Sans',
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.kPrimaryText,
    height: 1.5,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: 'DM Sans',
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.kSecondaryText,
    height: 1.4,
  );

  // Labels
  static const TextStyle labelLarge = TextStyle(
    fontFamily: 'DM Sans',
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: AppColors.kPrimaryText,
    letterSpacing: 0.5,
  );

  static const TextStyle labelMedium = TextStyle(
    fontFamily: 'DM Sans',
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.kPrimaryText,
    letterSpacing: 0.4,
  );

  static const TextStyle labelSmall = TextStyle(
    fontFamily: 'DM Sans',
    fontSize: 11,
    fontWeight: FontWeight.w600,
    color: AppColors.kPrimaryText,
    letterSpacing: 0.8,
  );

  // Button text
  static const TextStyle buttonText = TextStyle(
    fontFamily: 'DM Sans',
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.kBackground,
    letterSpacing: 0.5,
  );

  // Price styling
  static const TextStyle priceStyle = TextStyle(
    fontFamily: 'Syne',
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: AppColors.kPrimaryText,
  );

  static const TextStyle dealPriceStyle = TextStyle(
    fontFamily: 'Syne',
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.kDealBadge,
  );
}
