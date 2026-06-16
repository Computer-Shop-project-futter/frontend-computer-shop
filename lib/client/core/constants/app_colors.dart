import 'package:flutter/material.dart';

/// Application color constants
/// Warm monochrome theme with neutral tones
abstract class AppColors {
  // Background colors
  static const Color kBackground = Color(0xFFFAF9F7); // Warm off-white
  static const Color kSurface = Color(0xFFF2F0ED); // Light warm gray
  static const Color kDark = Color(0xFF1A1917); // Very dark brown
  
  // Text colors
  static const Color kPrimaryText = Color(0xFF1A1917); // kDark
  static const Color kSecondaryText = Color(0xFF6B6760); // Gray-brown
  static const Color kHintText = Color(0xFFAA9C97); // Light gray-brown
  
  // Border & divider colors
  static const Color kBorder = Color(0xFFD6D3CE); // Light border
  static const Color kDivider = Color(0xFFE8E5E1); // Divider line
  
  // Status colors
  static const Color kSuccess = Color(0xFF4CAF50);
  static const Color kError = Color(0xFFE53935);
  static const Color kWarning = Color(0xFFFBC02D);
  static const Color kInfo = Color(0xFF1976D2);
  
  // Semantic colors for UI elements
  static const Color kDisabledBackground = Color(0xFFEBE8E3);
  static const Color kDisabledText = Color(0xFFC0BFBD);
  
  // Deal/promotion colors
  static const Color kDealBadge = Color(0xFFE53935);
  
  // Transparency variants
  static Color kDarkTransparent = const Color(0xFF1A1917).withOpacity(0.5);
  static Color kBorderTransparent = const Color(0xFFD6D3CE).withOpacity(0.3);
}
