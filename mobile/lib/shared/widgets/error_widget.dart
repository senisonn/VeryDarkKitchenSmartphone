import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:restaurant_reservation/shared/widgets/custom_button.dart';

/// Error widget with retry functionality.
///
/// Displays error messages with optional retry button and custom actions.
/// Follows Material 3 design principles for error states.
///
/// Example:
/// ```dart
/// CustomErrorWidget(
///   message: 'Failed to load menu items',
///   onRetry: () => ref.refresh(menuItemsProvider),
/// )
/// ```
class CustomErrorWidget extends StatelessWidget {
  const CustomErrorWidget({
    required this.message,
    this.onRetry,
    this.title,
    this.icon,
    this.retryText = 'Retry',
    this.showIcon = true,
    super.key,
  });

  /// Error message to display.
  final String message;

  /// Callback when retry button is pressed.
  final VoidCallback? onRetry;

  /// Optional error title.
  final String? title;

  /// Custom error icon.
  final IconData? icon;

  /// Text for retry button.
  final String retryText;

  /// Whether to show the error icon.
  final bool showIcon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Error Icon
            if (showIcon)
              Icon(
                icon ?? Icons.error_outline,
                size: 64,
                color: colorScheme.error,
              ),
            if (showIcon) const Gap(24),

            // Error Title
            if (title != null) ...[
              Text(
                title!,
                style: theme.textTheme.titleLarge?.copyWith(
                  color: colorScheme.error,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const Gap(12),
            ],

            // Error Message
            Text(
              message,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),

            // Retry Button
            if (onRetry != null) ...[
              const Gap(24),
              CustomButton(
                text: retryText,
                onPressed: onRetry,
                icon: Icons.refresh,
                variant: ButtonVariant.outlined,
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Compact error widget for inline display.
  const CustomErrorWidget.compact({
    required this.message,
    this.onRetry,
    this.retryText = 'Retry',
    super.key,
  })  : title = null,
        icon = null,
        showIcon = false;

  /// Alert-style error widget with card background.
  static Widget alert({
    required String message,
    String? title,
    VoidCallback? onDismiss,
    VoidCallback? onRetry,
    IconData? icon,
  }) {
    return Builder(
      builder: (context) {
        final theme = Theme.of(context);
        final colorScheme = theme.colorScheme;

        return Card(
          margin: const EdgeInsets.all(16),
          color: colorScheme.errorContainer,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      icon ?? Icons.error_outline,
                      color: colorScheme.onErrorContainer,
                      size: 24,
                    ),
                    const Gap(12),
                    Expanded(
                      child: Text(
                        title ?? 'Error',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: colorScheme.onErrorContainer,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    if (onDismiss != null)
                      IconButton(
                        icon: Icon(
                          Icons.close,
                          color: colorScheme.onErrorContainer,
                        ),
                        onPressed: onDismiss,
                        tooltip: 'Dismiss',
                      ),
                  ],
                ),
                const Gap(8),
                Text(
                  message,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onErrorContainer,
                  ),
                ),
                if (onRetry != null) ...[
                  const Gap(16),
                  CustomButton(
                    text: 'Retry',
                    onPressed: onRetry,
                    icon: Icons.refresh,
                    variant: ButtonVariant.text,
                    size: ButtonSize.small,
                    foregroundColor: colorScheme.onErrorContainer,
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  /// Banner-style error widget (thin, full width).
  static Widget banner({
    required String message,
    VoidCallback? onRetry,
    VoidCallback? onDismiss,
  }) {
    return Builder(
      builder: (context) {
        final theme = Theme.of(context);
        final colorScheme = theme.colorScheme;

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          color: colorScheme.errorContainer,
          child: Row(
            children: [
              Icon(
                Icons.error_outline,
                color: colorScheme.onErrorContainer,
                size: 20,
              ),
              const Gap(12),
              Expanded(
                child: Text(
                  message,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onErrorContainer,
                  ),
                ),
              ),
              if (onRetry != null)
                TextButton(
                  onPressed: onRetry,
                  style: TextButton.styleFrom(
                    foregroundColor: colorScheme.onErrorContainer,
                  ),
                  child: const Text('Retry'),
                ),
              if (onDismiss != null)
                IconButton(
                  icon: Icon(
                    Icons.close,
                    color: colorScheme.onErrorContainer,
                    size: 20,
                  ),
                  onPressed: onDismiss,
                  tooltip: 'Dismiss',
                ),
            ],
          ),
        );
      },
    );
  }
}

/// Network error widget with specific messaging.
///
/// Example:
/// ```dart
/// NetworkErrorWidget(
///   onRetry: () => ref.refresh(dataProvider),
/// )
/// ```
class NetworkErrorWidget extends StatelessWidget {
  const NetworkErrorWidget({
    this.onRetry,
    this.message,
    super.key,
  });

  /// Callback when retry button is pressed.
  final VoidCallback? onRetry;

  /// Custom error message (defaults to network error message).
  final String? message;

  @override
  Widget build(BuildContext context) {
    return CustomErrorWidget(
      title: 'Connection Error',
      message: message ?? 'Unable to connect to the server.\nPlease check your internet connection and try again.',
      icon: Icons.wifi_off_outlined,
      onRetry: onRetry,
    );
  }
}

/// Not found error widget (404).
///
/// Example:
/// ```dart
/// NotFoundErrorWidget(
///   message: 'The menu item you\'re looking for doesn\'t exist',
/// )
/// ```
class NotFoundErrorWidget extends StatelessWidget {
  const NotFoundErrorWidget({
    this.message,
    this.onGoBack,
    super.key,
  });

  /// Custom error message.
  final String? message;

  /// Callback when go back button is pressed.
  final VoidCallback? onGoBack;

  @override
  Widget build(BuildContext context) {
    return CustomErrorWidget(
      title: 'Not Found',
      message: message ?? 'The page or resource you\'re looking for doesn\'t exist.',
      icon: Icons.search_off,
      onRetry: onGoBack,
      retryText: 'Go Back',
    );
  }
}

/// Unauthorized error widget (401/403).
///
/// Example:
/// ```dart
/// UnauthorizedErrorWidget(
///   onLogin: () => context.push(RouteNames.login),
/// )
/// ```
class UnauthorizedErrorWidget extends StatelessWidget {
  const UnauthorizedErrorWidget({
    this.onLogin,
    this.message,
    super.key,
  });

  /// Callback when login button is pressed.
  final VoidCallback? onLogin;

  /// Custom error message.
  final String? message;

  @override
  Widget build(BuildContext context) {
    return CustomErrorWidget(
      title: 'Access Denied',
      message: message ?? 'You need to be logged in to access this content.',
      icon: Icons.lock_outline,
      onRetry: onLogin,
      retryText: 'Login',
    );
  }
}

/// Server error widget (500).
///
/// Example:
/// ```dart
/// ServerErrorWidget(
///   onRetry: () => ref.refresh(dataProvider),
/// )
/// ```
class ServerErrorWidget extends StatelessWidget {
  const ServerErrorWidget({
    this.onRetry,
    this.message,
    super.key,
  });

  /// Callback when retry button is pressed.
  final VoidCallback? onRetry;

  /// Custom error message.
  final String? message;

  @override
  Widget build(BuildContext context) {
    return CustomErrorWidget(
      title: 'Server Error',
      message: message ?? 'Something went wrong on our end.\nWe\'re working to fix it. Please try again later.',
      icon: Icons.cloud_off_outlined,
      onRetry: onRetry,
    );
  }
}

/// Generic error dialog.
///
/// Example:
/// ```dart
/// showErrorDialog(
///   context: context,
///   title: 'Reservation Failed',
///   message: 'Unable to create reservation',
/// )
/// ```
Future<void> showErrorDialog({
  required BuildContext context,
  String title = 'Error',
  required String message,
  String buttonText = 'OK',
  VoidCallback? onDismiss,
}) async {
  return showDialog(
    context: context,
    builder: (context) {
      final theme = Theme.of(context);
      final colorScheme = theme.colorScheme;

      return AlertDialog(
        icon: Icon(
          Icons.error_outline,
          color: colorScheme.error,
          size: 48,
        ),
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              onDismiss?.call();
            },
            child: Text(buttonText),
          ),
        ],
      );
    },
  );
}

/// Shows an error snackbar.
///
/// Example:
/// ```dart
/// showErrorSnackBar(
///   context: context,
///   message: 'Failed to save changes',
/// )
/// ```
void showErrorSnackBar({
  required BuildContext context,
  required String message,
  Duration duration = const Duration(seconds: 4),
  VoidCallback? onRetry,
}) {
  final colorScheme = Theme.of(context).colorScheme;

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          Icon(
            Icons.error_outline,
            color: colorScheme.onErrorContainer,
            size: 20,
          ),
          const Gap(12),
          Expanded(child: Text(message)),
        ],
      ),
      backgroundColor: colorScheme.errorContainer,
      behavior: SnackBarBehavior.floating,
      duration: duration,
      action: onRetry != null
          ? SnackBarAction(
              label: 'Retry',
              textColor: colorScheme.onErrorContainer,
              onPressed: onRetry,
            )
          : null,
    ),
  );
}
