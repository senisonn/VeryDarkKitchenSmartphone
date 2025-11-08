import 'package:flutter/material.dart';

/// Central place for small, reusable UI theme constants used across screens.
/// Keep this file minimal and low-risk: values here should be safe to reference
/// from widgets without changing app-wide ThemeData.
class AppTheme {
  // Rounded radii
  static const double radiusSmall = 8.0;
  static const double radius = 12.0;
  static const double radiusLarge = 16.0;

  // Default paddings
  static const double paddingSmall = 8.0;
  static const double padding = 16.0;
  static const double paddingLarge = 24.0;

  // Elevation defaults
  static const double cardElevation = 4.0;

  // Semantic colors derived from the current ColorScheme.
  // Use these helpers in widgets to pick colors that adapt to the app theme.
  static Color success(BuildContext context) => Theme.of(context).colorScheme.secondary;
  static Color danger(BuildContext context) => Theme.of(context).colorScheme.error;
  static Color warning(BuildContext context) => Theme.of(context).colorScheme.tertiary;
}
