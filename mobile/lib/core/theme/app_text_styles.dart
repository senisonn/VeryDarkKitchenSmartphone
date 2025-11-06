import 'package:flutter/material.dart';
import 'package:restaurant_reservation/core/theme/app_colors.dart';

/// Application text styles following Material 3 typography.
///
/// Provides consistent typography for both light and dark themes.
class AppTextStyles {
  AppTextStyles._();

  // Base Font Family
  static const String fontFamily = 'Roboto';

  // Font Weights
  static const FontWeight light = FontWeight.w300;
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;

  // Display Styles (Large text)
  static const TextStyle displayLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 57.0,
    fontWeight: regular,
    letterSpacing: -0.25,
    height: 1.12,
  );

  static const TextStyle displayMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 45.0,
    fontWeight: regular,
    letterSpacing: 0.0,
    height: 1.16,
  );

  static const TextStyle displaySmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 36.0,
    fontWeight: regular,
    letterSpacing: 0.0,
    height: 1.22,
  );

  // Headline Styles
  static const TextStyle headlineLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 32.0,
    fontWeight: regular,
    letterSpacing: 0.0,
    height: 1.25,
  );

  static const TextStyle headlineMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 28.0,
    fontWeight: regular,
    letterSpacing: 0.0,
    height: 1.29,
  );

  static const TextStyle headlineSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24.0,
    fontWeight: regular,
    letterSpacing: 0.0,
    height: 1.33,
  );

  // Title Styles
  static const TextStyle titleLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 22.0,
    fontWeight: medium,
    letterSpacing: 0.0,
    height: 1.27,
  );

  static const TextStyle titleMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16.0,
    fontWeight: medium,
    letterSpacing: 0.15,
    height: 1.50,
  );

  static const TextStyle titleSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14.0,
    fontWeight: medium,
    letterSpacing: 0.1,
    height: 1.43,
  );

  // Body Styles
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16.0,
    fontWeight: regular,
    letterSpacing: 0.5,
    height: 1.50,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14.0,
    fontWeight: regular,
    letterSpacing: 0.25,
    height: 1.43,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12.0,
    fontWeight: regular,
    letterSpacing: 0.4,
    height: 1.33,
  );

  // Label Styles (Buttons, etc.)
  static const TextStyle labelLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14.0,
    fontWeight: medium,
    letterSpacing: 0.1,
    height: 1.43,
  );

  static const TextStyle labelMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12.0,
    fontWeight: medium,
    letterSpacing: 0.5,
    height: 1.33,
  );

  static const TextStyle labelSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 11.0,
    fontWeight: medium,
    letterSpacing: 0.5,
    height: 1.45,
  );

  // Custom Styles (App-specific)
  static const TextStyle button = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16.0,
    fontWeight: medium,
    letterSpacing: 0.5,
  );

  static const TextStyle buttonSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14.0,
    fontWeight: medium,
    letterSpacing: 0.5,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12.0,
    fontWeight: regular,
    letterSpacing: 0.4,
    height: 1.33,
  );

  static const TextStyle overline = TextStyle(
    fontFamily: fontFamily,
    fontSize: 10.0,
    fontWeight: medium,
    letterSpacing: 1.5,
    height: 1.60,
  );

  // Input Styles
  static const TextStyle inputText = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16.0,
    fontWeight: regular,
    letterSpacing: 0.5,
  );

  static const TextStyle inputLabel = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12.0,
    fontWeight: regular,
    letterSpacing: 0.4,
  );

  static const TextStyle inputHint = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16.0,
    fontWeight: regular,
    letterSpacing: 0.5,
  );

  static const TextStyle inputError = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12.0,
    fontWeight: regular,
    letterSpacing: 0.4,
    color: AppColors.error,
  );

  // App Bar Styles
  static const TextStyle appBarTitle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 20.0,
    fontWeight: medium,
    letterSpacing: 0.15,
  );

  // Card Styles
  static const TextStyle cardTitle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18.0,
    fontWeight: medium,
    letterSpacing: 0.15,
  );

  static const TextStyle cardSubtitle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14.0,
    fontWeight: regular,
    letterSpacing: 0.25,
  );

  // Price Styles
  static const TextStyle priceSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14.0,
    fontWeight: semiBold,
    letterSpacing: 0.1,
  );

  static const TextStyle priceMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18.0,
    fontWeight: semiBold,
    letterSpacing: 0.15,
  );

  static const TextStyle priceLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24.0,
    fontWeight: bold,
    letterSpacing: 0.0,
  );

  // Status Badge Styles
  static const TextStyle badge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 11.0,
    fontWeight: medium,
    letterSpacing: 0.5,
  );

  // Link Style
  static const TextStyle link = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14.0,
    fontWeight: medium,
    letterSpacing: 0.25,
    decoration: TextDecoration.underline,
  );
}
