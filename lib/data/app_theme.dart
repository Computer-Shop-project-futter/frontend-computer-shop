// ─────────────────────────────────────────────
//  G14 Admin — Theme & Constants
// ─────────────────────────────────────────────

import 'package:computer_shop/models/models.dart';
import 'package:flutter/material.dart';

class AppTheme {
  // Sidebar colors
  static const Color sidebarBg      = Color(0xFF0F1117);
  static const Color sidebarText    = Color(0xFFC8CCD6);
  static const Color sidebarMuted   = Color(0xFF5A6070);
  static const Color sidebarBorder  = Color(0xFF1E2230);
  static const Color sidebarActive  = Color(0xFF1E2230);
  static const Color sidebarAvatar  = Color(0xFF2D3249);

  // Brand / accent
  static const Color accent         = Color(0xFF3B82F6);
  static const Color accentDark     = Color(0xFF2563EB);

  // App surface
  static const Color bgPage         = Color(0xFFF4F5F7);
  static const Color surface        = Color(0xFFFFFFFF);
  static const Color borderColor    = Color(0xFFE5E7EB);

  // Text
  static const Color textPrimary    = Color(0xFF111827);
  static const Color textSecondary  = Color(0xFF6B7280);
  static const Color textMuted      = Color(0xFF9CA3AF);

  // Semantic
  static const Color green          = Color(0xFF10B981);
  static const Color red            = Color(0xFFEF4444);
  static const Color orange         = Color(0xFFF59E0B);

  // Status badge colors
  static const Color paidBg         = Color(0xFFD1FAE5);
  static const Color paidText       = Color(0xFF065F46);
  static const Color pendingBg      = Color(0xFFFEF3C7);
  static const Color pendingText    = Color(0xFF92400E);

  static ThemeData get lightTheme => ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: bgPage,
        fontFamily: 'Inter',
        colorScheme: const ColorScheme.light(
          primary: accent,
          surface: surface,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: surface,
          foregroundColor: textPrimary,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
        ),
        dividerTheme: const DividerThemeData(
          color: borderColor,
          thickness: 1,
          space: 0,
        ),
      );

  static Color statusFg(OrderStatus s) {
    switch (s) {
      case OrderStatus.paid:
        return paidText;
      case OrderStatus.pending:
        return pendingText;
      case OrderStatus.cancelled:
        return red;
      case OrderStatus.processing:
        return orange;
      case OrderStatus.delivered:
        return green;
      case OrderStatus.shipped:
        return accent;
    }
  }

  static Color statusBg(OrderStatus s) {
    switch (s) {
      case OrderStatus.paid:
        return paidBg;
      case OrderStatus.pending:
        return pendingBg;
      case OrderStatus.cancelled:
        return const Color(0xFFFEE2E2);
      case OrderStatus.processing:
        return const Color(0xFFFFF7ED);
      case OrderStatus.delivered:
        return const Color(0xFFD1FAE5);
      case OrderStatus.shipped:
        return const Color(0xFFDBEAFE);
    }
  }
}

// ignore: unused_element
class C {
  static const Color accent        = Color(0xFF3B82F6);
  static const Color bg            = Color(0xFFF4F5F7);
  static const Color border        = Color(0xFFE5E7EB);
  static const Color textPrimary   = Color(0xFF111827);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textMuted     = Color(0xFF9CA3AF);
  static const Color red           = Color(0xFFEF4444);
  static const Color green         = Color(0xFF10B981);
}
