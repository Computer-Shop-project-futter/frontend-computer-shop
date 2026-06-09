import 'package:intl/intl.dart';

/// Utility functions for formatting data
abstract class Formatters {
  /// Format currency value to USD format
  /// Example: 1499.99 -> "$1,499.99"
  static String formatCurrency(double value) {
    final formatter = NumberFormat.currency(
      symbol: '\$',
      decimalDigits: 2,
    );
    return formatter.format(value);
  }

  /// Format price as integer currency (no cents)
  /// Example: 1499 -> "$1,499"
  static String formatPriceInt(int value) {
    final formatter = NumberFormat.currency(
      symbol: '\$',
      decimalDigits: 0,
    );
    return formatter.format(value);
  }

  /// Format date to readable format
  /// Example: 2024-05-23 -> "23 May 2024"
  static String formatDate(DateTime date) {
    final formatter = DateFormat('dd MMM yyyy');
    return formatter.format(date);
  }

  /// Format date and time
  /// Example: 2024-05-23 14:30 -> "23 May 2024, 2:30 PM"
  static String formatDateTime(DateTime dateTime) {
    final formatter = DateFormat('dd MMM yyyy, h:mm a');
    return formatter.format(dateTime);
  }

  /// Format time only
  /// Example: 14:30 -> "2:30 PM"
  static String formatTime(DateTime dateTime) {
    final formatter = DateFormat('h:mm a');
    return formatter.format(dateTime);
  }

  /// Truncate text to specified length with ellipsis
  /// Example: truncateText('Hello World', 8) -> "Hello..."
  static String truncateText(String text, int maxLength,
      {String suffix = '...'}) {
    if (text.length <= maxLength) {
      return text;
    }
    return '${text.substring(0, maxLength - suffix.length)}$suffix';
  }

  /// Format large numbers with K, M, B suffix
  /// Example: formatNumber(1500) -> "1.5K"
  static String formatNumber(num value) {
    if (value >= 1000000000) {
      return '${(value / 1000000000).toStringAsFixed(1)}B';
    } else if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}M';
    } else if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(1)}K';
    }
    return value.toString();
  }

  /// Format rating to one decimal place
  static String formatRating(double rating) {
    return rating.toStringAsFixed(1);
  }

  /// Convert milliseconds to readable duration
  /// Example: 65000 -> "1:05"
  static String formatDuration(int milliseconds) {
    final seconds = milliseconds ~/ 1000;
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}
