import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Helper class for showing consistent snackbars
class CustomSnackbar {
  static void show(
    BuildContext context, {
    required String message,
    SnackbarType type = SnackbarType.info,
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
  }) {
    Color backgroundColor;
    IconData icon;

    switch (type) {
      case SnackbarType.success:
        backgroundColor = AppTheme.success(context);
        icon = Icons.check_circle;
        break;
      case SnackbarType.error:
        backgroundColor = AppTheme.danger(context);
        icon = Icons.error_outline;
        break;
      case SnackbarType.warning:
        backgroundColor = AppTheme.warning(context);
        icon = Icons.warning_amber;
        break;
      case SnackbarType.info:
        backgroundColor = AppTheme.info(context);
        icon = Icons.info_outline;
        break;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: AppTheme.spaceMd),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: backgroundColor,
        duration: duration,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        ),
        action: action,
      ),
    );
  }

  static void success(BuildContext context, String message) {
    show(context, message: message, type: SnackbarType.success);
  }

  static void error(BuildContext context, String message) {
    show(context, message: message, type: SnackbarType.error);
  }

  static void warning(BuildContext context, String message) {
    show(context, message: message, type: SnackbarType.warning);
  }

  static void info(BuildContext context, String message) {
    show(context, message: message, type: SnackbarType.info);
  }
}

enum SnackbarType {
  success,
  error,
  warning,
  info,
}
