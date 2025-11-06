import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:restaurant_reservation/core/theme/app_colors.dart';
import 'package:restaurant_reservation/core/theme/app_dimensions.dart';
import 'package:restaurant_reservation/core/theme/app_text_styles.dart';

/// Application theme configuration for Material 3.
///
/// Provides light and dark theme data with consistent styling.
class AppTheme {
  AppTheme._();

  /// Light theme configuration
  static ThemeData get lightTheme => ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: _lightColorScheme,
      scaffoldBackgroundColor: AppColors.backgroundLight,
      appBarTheme: _lightAppBarTheme,
      // cardTheme: _cardTheme,
      elevatedButtonTheme: _elevatedButtonTheme,
      outlinedButtonTheme: _outlinedButtonTheme,
      textButtonTheme: _textButtonTheme,
      inputDecorationTheme: _lightInputDecorationTheme,
      floatingActionButtonTheme: _floatingActionButtonTheme,
      bottomNavigationBarTheme: _lightBottomNavigationBarTheme,
      chipTheme: _chipTheme,
      // dialogTheme: _dialogTheme,
      snackBarTheme: _snackBarTheme,
      bottomSheetTheme: _bottomSheetTheme,
      dividerTheme: _lightDividerTheme,
      textTheme: _textTheme,
      iconTheme: _lightIconTheme,
      listTileTheme: _listTileTheme,
      switchTheme: _switchTheme,
      checkboxTheme: _checkboxTheme,
      radioTheme: _radioTheme,
    );

  /// Dark theme configuration
  static ThemeData get darkTheme => ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: _darkColorScheme,
      scaffoldBackgroundColor: AppColors.backgroundDark,
      appBarTheme: _darkAppBarTheme,
      // cardTheme: _cardTheme,
      elevatedButtonTheme: _elevatedButtonTheme,
      outlinedButtonTheme: _outlinedButtonTheme,
      textButtonTheme: _textButtonTheme,
      inputDecorationTheme: _darkInputDecorationTheme,
      floatingActionButtonTheme: _floatingActionButtonTheme,
      bottomNavigationBarTheme: _darkBottomNavigationBarTheme,
      chipTheme: _chipTheme,
      // dialogTheme: _dialogTheme,
      snackBarTheme: _snackBarTheme,
      bottomSheetTheme: _bottomSheetTheme,
      dividerTheme: _darkDividerTheme,
      textTheme: _textTheme,
      iconTheme: _darkIconTheme,
      listTileTheme: _listTileTheme,
      switchTheme: _switchTheme,
      checkboxTheme: _checkboxTheme,
      radioTheme: _radioTheme,
    );

  // Color Schemes
  static const ColorScheme _lightColorScheme = ColorScheme.light(
    primary: AppColors.primary,
    onPrimary: AppColors.white,
    primaryContainer: AppColors.primaryLight,
    onPrimaryContainer: AppColors.primaryDark,
    secondary: AppColors.secondary,
    onSecondary: AppColors.white,
    secondaryContainer: AppColors.secondaryLight,
    onSecondaryContainer: AppColors.secondaryDark,
    tertiary: AppColors.tertiary,
    onTertiary: AppColors.white,
    tertiaryContainer: AppColors.tertiaryLight,
    onTertiaryContainer: AppColors.tertiaryDark,
    error: AppColors.error,
    onError: AppColors.white,
    surface: AppColors.surfaceLight,
    onSurface: AppColors.textPrimaryLight,
    surfaceContainerHighest: AppColors.grey200,
    outline: AppColors.grey400,
    outlineVariant: AppColors.grey300,
    shadow: AppColors.shadowLight,
  );

  static const ColorScheme _darkColorScheme = ColorScheme.dark(
    primary: AppColors.primaryLight,
    onPrimary: AppColors.black,
    primaryContainer: AppColors.primary,
    onPrimaryContainer: AppColors.primaryLight,
    secondary: AppColors.secondaryLight,
    onSecondary: AppColors.black,
    secondaryContainer: AppColors.secondary,
    onSecondaryContainer: AppColors.secondaryLight,
    tertiary: AppColors.tertiaryLight,
    onTertiary: AppColors.black,
    tertiaryContainer: AppColors.tertiary,
    onTertiaryContainer: AppColors.tertiaryLight,
    error: AppColors.error,
    onError: AppColors.black,
    surface: AppColors.surfaceDark,
    onSurface: AppColors.textPrimaryDark,
    surfaceContainerHighest: AppColors.grey800,
    outline: AppColors.grey600,
    outlineVariant: AppColors.grey700,
    shadow: AppColors.shadowDark,
  );

  // App Bar Theme
  static const AppBarTheme _lightAppBarTheme = AppBarTheme(
    elevation: AppDimensions.appBarElevation,
    centerTitle: true,
    backgroundColor: AppColors.surfaceLight,
    foregroundColor: AppColors.textPrimaryLight,
    surfaceTintColor: AppColors.transparent,
    titleTextStyle: AppTextStyles.appBarTitle,
    systemOverlayStyle: SystemUiOverlayStyle.dark,
  );

  static const AppBarTheme _darkAppBarTheme = AppBarTheme(
    elevation: AppDimensions.appBarElevation,
    centerTitle: true,
    backgroundColor: AppColors.surfaceDark,
    foregroundColor: AppColors.textPrimaryDark,
    surfaceTintColor: AppColors.transparent,
    titleTextStyle: AppTextStyles.appBarTitle,
    systemOverlayStyle: SystemUiOverlayStyle.light,
  );

  // Card Theme
  static final CardTheme _cardTheme = CardTheme(
    elevation: AppDimensions.elevationSm,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
    ),
    margin: const EdgeInsets.all(AppDimensions.marginSm),
  );

  // Button Themes
  static final ElevatedButtonThemeData _elevatedButtonTheme =
      ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: AppDimensions.elevationSm,
      minimumSize: const Size(
        double.infinity,
        AppDimensions.buttonHeightMd,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      ),
      textStyle: AppTextStyles.button,
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingLg,
        vertical: AppDimensions.paddingMd,
      ),
    ),
  );

  static final OutlinedButtonThemeData _outlinedButtonTheme =
      OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      minimumSize: const Size(
        double.infinity,
        AppDimensions.buttonHeightMd,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      ),
      textStyle: AppTextStyles.button,
      side: const BorderSide(
        width: AppDimensions.borderWidthNormal,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingLg,
        vertical: AppDimensions.paddingMd,
      ),
    ),
  );

  static final TextButtonThemeData _textButtonTheme = TextButtonThemeData(
    style: TextButton.styleFrom(
      minimumSize: const Size(
        double.infinity,
        AppDimensions.buttonHeightMd,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      ),
      textStyle: AppTextStyles.button,
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingLg,
        vertical: AppDimensions.paddingMd,
      ),
    ),
  );

  // Input Decoration Theme
  static final InputDecorationTheme _lightInputDecorationTheme =
      InputDecorationTheme(
    filled: true,
    fillColor: AppColors.surfaceLight,
    contentPadding: const EdgeInsets.symmetric(
      horizontal: AppDimensions.paddingMd,
      vertical: AppDimensions.paddingMd,
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      borderSide: const BorderSide(
        color: AppColors.grey300,
        width: AppDimensions.borderWidthNormal,
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      borderSide: const BorderSide(
        color: AppColors.grey300,
        width: AppDimensions.borderWidthNormal,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      borderSide: const BorderSide(
        color: AppColors.primary,
        width: AppDimensions.borderWidthThick,
      ),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      borderSide: const BorderSide(
        color: AppColors.error,
        width: AppDimensions.borderWidthNormal,
      ),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      borderSide: const BorderSide(
        color: AppColors.error,
        width: AppDimensions.borderWidthThick,
      ),
    ),
    labelStyle: AppTextStyles.inputLabel,
    hintStyle: AppTextStyles.inputHint.copyWith(
      color: AppColors.textSecondaryLight,
    ),
    errorStyle: AppTextStyles.inputError,
  );

  static final InputDecorationTheme _darkInputDecorationTheme =
      InputDecorationTheme(
    filled: true,
    fillColor: AppColors.surfaceDark,
    contentPadding: const EdgeInsets.symmetric(
      horizontal: AppDimensions.paddingMd,
      vertical: AppDimensions.paddingMd,
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      borderSide: const BorderSide(
        color: AppColors.grey700,
        width: AppDimensions.borderWidthNormal,
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      borderSide: const BorderSide(
        color: AppColors.grey700,
        width: AppDimensions.borderWidthNormal,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      borderSide: const BorderSide(
        color: AppColors.primaryLight,
        width: AppDimensions.borderWidthThick,
      ),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      borderSide: const BorderSide(
        color: AppColors.error,
        width: AppDimensions.borderWidthNormal,
      ),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      borderSide: const BorderSide(
        color: AppColors.error,
        width: AppDimensions.borderWidthThick,
      ),
    ),
    labelStyle: AppTextStyles.inputLabel,
    hintStyle: AppTextStyles.inputHint.copyWith(
      color: AppColors.textSecondaryDark,
    ),
    errorStyle: AppTextStyles.inputError,
  );

  // Floating Action Button Theme
  static const FloatingActionButtonThemeData _floatingActionButtonTheme =
      FloatingActionButtonThemeData(
    elevation: AppDimensions.elevationMd,
    shape: CircleBorder(),
  );

  // Bottom Navigation Bar Theme
  static const BottomNavigationBarThemeData _lightBottomNavigationBarTheme =
      BottomNavigationBarThemeData(
    type: BottomNavigationBarType.fixed,
    elevation: AppDimensions.bottomNavElevation,
    backgroundColor: AppColors.surfaceLight,
    selectedItemColor: AppColors.primary,
    unselectedItemColor: AppColors.textSecondaryLight,
  );

  static const BottomNavigationBarThemeData _darkBottomNavigationBarTheme =
      BottomNavigationBarThemeData(
    type: BottomNavigationBarType.fixed,
    elevation: AppDimensions.bottomNavElevation,
    backgroundColor: AppColors.surfaceDark,
    selectedItemColor: AppColors.primaryLight,
    unselectedItemColor: AppColors.textSecondaryDark,
  );

  // Chip Theme
  static final ChipThemeData _chipTheme = ChipThemeData(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
    ),
    padding: const EdgeInsets.symmetric(
      horizontal: AppDimensions.paddingMd,
      vertical: AppDimensions.paddingXs,
    ),
  );

  // Dialog Theme
  static final DialogTheme _dialogTheme = DialogTheme(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppDimensions.dialogBorderRadius),
    ),
    elevation: AppDimensions.elevationLg,
  );

  // Snackbar Theme
  static final SnackBarThemeData _snackBarTheme = SnackBarThemeData(
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppDimensions.snackbarBorderRadius),
    ),
  );

  // Bottom Sheet Theme
  static final BottomSheetThemeData _bottomSheetTheme = BottomSheetThemeData(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(AppDimensions.bottomSheetBorderRadius),
      ),
    ),
    elevation: AppDimensions.elevationLg,
  );

  // Divider Theme
  static const DividerThemeData _lightDividerTheme = DividerThemeData(
    color: AppColors.dividerLight,
    thickness: AppDimensions.dividerThin,
    space: AppDimensions.spacing16,
  );

  static const DividerThemeData _darkDividerTheme = DividerThemeData(
    color: AppColors.dividerDark,
    thickness: AppDimensions.dividerThin,
    space: AppDimensions.spacing16,
  );

  // Text Theme
  static const TextTheme _textTheme = TextTheme(
    displayLarge: AppTextStyles.displayLarge,
    displayMedium: AppTextStyles.displayMedium,
    displaySmall: AppTextStyles.displaySmall,
    headlineLarge: AppTextStyles.headlineLarge,
    headlineMedium: AppTextStyles.headlineMedium,
    headlineSmall: AppTextStyles.headlineSmall,
    titleLarge: AppTextStyles.titleLarge,
    titleMedium: AppTextStyles.titleMedium,
    titleSmall: AppTextStyles.titleSmall,
    bodyLarge: AppTextStyles.bodyLarge,
    bodyMedium: AppTextStyles.bodyMedium,
    bodySmall: AppTextStyles.bodySmall,
    labelLarge: AppTextStyles.labelLarge,
    labelMedium: AppTextStyles.labelMedium,
    labelSmall: AppTextStyles.labelSmall,
  );

  // Icon Theme
  static const IconThemeData _lightIconTheme = IconThemeData(
    color: AppColors.textPrimaryLight,
    size: AppDimensions.iconMd,
  );

  static const IconThemeData _darkIconTheme = IconThemeData(
    color: AppColors.textPrimaryDark,
    size: AppDimensions.iconMd,
  );

  // List Tile Theme
  static const ListTileThemeData _listTileTheme = ListTileThemeData(
    contentPadding: EdgeInsets.symmetric(
      horizontal: AppDimensions.listTileHorizontalPadding,
      vertical: AppDimensions.listTileVerticalPadding,
    ),
  );

  // Switch Theme
  static const SwitchThemeData _switchTheme = SwitchThemeData();

  // Checkbox Theme
  static final CheckboxThemeData _checkboxTheme = CheckboxThemeData(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppDimensions.radiusXs),
    ),
  );

  // Radio Theme
  static const RadioThemeData _radioTheme = RadioThemeData();
}
