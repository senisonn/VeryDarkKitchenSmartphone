import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

/// Button variant types.
enum ButtonVariant {
  /// Filled button with primary color (default).
  primary,

  /// Filled button with secondary color.
  secondary,

  /// Outlined button.
  outlined,

  /// Text button without background.
  text,

  /// Elevated button with shadow.
  elevated,
}

/// Button size variants.
enum ButtonSize {
  /// Small button (height: 36px).
  small,

  /// Medium button (height: 44px) - default.
  medium,

  /// Large button (height: 52px).
  large,
}

/// Custom button widget with multiple variants and sizes.
///
/// Provides consistent button styling across the app following Material 3 design.
///
/// Example:
/// ```dart
/// CustomButton(
///   text: 'Submit',
///   onPressed: () => print('Pressed'),
///   variant: ButtonVariant.primary,
/// )
/// ```
class CustomButton extends StatelessWidget {
  const CustomButton({
    required this.text,
    required this.onPressed,
    this.variant = ButtonVariant.primary,
    this.size = ButtonSize.medium,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = false,
    this.backgroundColor,
    this.foregroundColor,
    super.key,
  });

  /// Button label text.
  final String text;

  /// Callback when button is pressed.
  final VoidCallback? onPressed;

  /// Button style variant.
  final ButtonVariant variant;

  /// Button size.
  final ButtonSize size;

  /// Optional leading icon.
  final IconData? icon;

  /// Shows loading indicator when true.
  final bool isLoading;

  /// Makes button take full width when true.
  final bool isFullWidth;

  /// Custom background color (overrides variant color).
  final Color? backgroundColor;

  /// Custom foreground/text color.
  final Color? foregroundColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Determine button height based on size
    final double height = switch (size) {
      ButtonSize.small => 36.0,
      ButtonSize.medium => 44.0,
      ButtonSize.large => 52.0,
    };

    // Determine font size based on button size
    final double fontSize = switch (size) {
      ButtonSize.small => 13.0,
      ButtonSize.medium => 15.0,
      ButtonSize.large => 16.0,
    };

    // Determine horizontal padding
    final double horizontalPadding = switch (size) {
      ButtonSize.small => 16.0,
      ButtonSize.medium => 24.0,
      ButtonSize.large => 32.0,
    };

    final EdgeInsets padding = EdgeInsets.symmetric(
      horizontal: horizontalPadding,
      vertical: 0,
    );

    // Build button content
    final Widget content = isLoading
        ? SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                foregroundColor ?? _getForegroundColor(colorScheme),
              ),
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: fontSize + 4),
                Gap(8),
              ],
              Text(
                text,
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          );

    // Build button based on variant
    final Widget button = switch (variant) {
      ButtonVariant.primary => FilledButton(
          onPressed: isLoading ? null : onPressed,
          style: FilledButton.styleFrom(
            minimumSize: Size(isFullWidth ? double.infinity : 0, height),
            padding: padding,
            backgroundColor: backgroundColor ?? colorScheme.primary,
            foregroundColor: foregroundColor ?? colorScheme.onPrimary,
            disabledBackgroundColor: colorScheme.surfaceContainerHighest,
            disabledForegroundColor: colorScheme.onSurfaceVariant,
          ),
          child: content,
        ),
      ButtonVariant.secondary => FilledButton(
          onPressed: isLoading ? null : onPressed,
          style: FilledButton.styleFrom(
            minimumSize: Size(isFullWidth ? double.infinity : 0, height),
            padding: padding,
            backgroundColor: backgroundColor ?? colorScheme.secondary,
            foregroundColor: foregroundColor ?? colorScheme.onSecondary,
            disabledBackgroundColor: colorScheme.surfaceContainerHighest,
            disabledForegroundColor: colorScheme.onSurfaceVariant,
          ),
          child: content,
        ),
      ButtonVariant.outlined => OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            minimumSize: Size(isFullWidth ? double.infinity : 0, height),
            padding: padding,
            foregroundColor: foregroundColor ?? colorScheme.primary,
            side: BorderSide(
              color: backgroundColor ?? colorScheme.outline,
              width: 1.5,
            ),
            disabledForegroundColor: colorScheme.onSurfaceVariant,
          ),
          child: content,
        ),
      ButtonVariant.text => TextButton(
          onPressed: isLoading ? null : onPressed,
          style: TextButton.styleFrom(
            minimumSize: Size(isFullWidth ? double.infinity : 0, height),
            padding: padding,
            foregroundColor: foregroundColor ?? colorScheme.primary,
            disabledForegroundColor: colorScheme.onSurfaceVariant,
          ),
          child: content,
        ),
      ButtonVariant.elevated => ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            minimumSize: Size(isFullWidth ? double.infinity : 0, height),
            padding: padding,
            backgroundColor: backgroundColor ?? colorScheme.surface,
            foregroundColor: foregroundColor ?? colorScheme.primary,
            elevation: 2,
            disabledBackgroundColor: colorScheme.surfaceContainerHighest,
            disabledForegroundColor: colorScheme.onSurfaceVariant,
          ),
          child: content,
        ),
    };

    return button;
  }

  /// Gets foreground color based on variant.
  Color _getForegroundColor(ColorScheme colorScheme) {
    return switch (variant) {
      ButtonVariant.primary => colorScheme.onPrimary,
      ButtonVariant.secondary => colorScheme.onSecondary,
      ButtonVariant.outlined => colorScheme.primary,
      ButtonVariant.text => colorScheme.primary,
      ButtonVariant.elevated => colorScheme.primary,
    };
  }
}

/// Icon button with consistent styling.
///
/// Example:
/// ```dart
/// CustomIconButton(
///   icon: Icons.favorite,
///   onPressed: () => print('Pressed'),
/// )
/// ```
class CustomIconButton extends StatelessWidget {
  const CustomIconButton({
    required this.icon,
    required this.onPressed,
    this.size = ButtonSize.medium,
    this.variant = IconButtonVariant.standard,
    this.tooltip,
    this.backgroundColor,
    this.foregroundColor,
    super.key,
  });

  /// Button icon.
  final IconData icon;

  /// Callback when button is pressed.
  final VoidCallback? onPressed;

  /// Button size.
  final ButtonSize size;

  /// Button variant.
  final IconButtonVariant variant;

  /// Tooltip text.
  final String? tooltip;

  /// Custom background color.
  final Color? backgroundColor;

  /// Custom icon color.
  final Color? foregroundColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Determine icon size based on button size
    final double iconSize = switch (size) {
      ButtonSize.small => 20.0,
      ButtonSize.medium => 24.0,
      ButtonSize.large => 28.0,
    };

    final Widget button = switch (variant) {
      IconButtonVariant.standard => IconButton(
          onPressed: onPressed,
          icon: Icon(icon, size: iconSize),
          tooltip: tooltip,
          color: foregroundColor ?? colorScheme.onSurfaceVariant,
        ),
      IconButtonVariant.filled => IconButton.filled(
          onPressed: onPressed,
          icon: Icon(icon, size: iconSize),
          tooltip: tooltip,
          style: IconButton.styleFrom(
            backgroundColor: backgroundColor ?? colorScheme.primary,
            foregroundColor: foregroundColor ?? colorScheme.onPrimary,
          ),
        ),
      IconButtonVariant.filledTonal => IconButton.filledTonal(
          onPressed: onPressed,
          icon: Icon(icon, size: iconSize),
          tooltip: tooltip,
          style: IconButton.styleFrom(
            backgroundColor:
                backgroundColor ?? colorScheme.secondaryContainer,
            foregroundColor:
                foregroundColor ?? colorScheme.onSecondaryContainer,
          ),
        ),
      IconButtonVariant.outlined => IconButton.outlined(
          onPressed: onPressed,
          icon: Icon(icon, size: iconSize),
          tooltip: tooltip,
          style: IconButton.styleFrom(
            foregroundColor: foregroundColor ?? colorScheme.primary,
            side: BorderSide(
              color: colorScheme.outline,
              width: 1.5,
            ),
          ),
        ),
    };

    return button;
  }
}

/// Icon button variant types.
enum IconButtonVariant {
  /// Standard icon button.
  standard,

  /// Filled icon button with primary color.
  filled,

  /// Filled tonal icon button.
  filledTonal,

  /// Outlined icon button.
  outlined,
}
