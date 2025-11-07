import 'package:flutter/material.dart';

/// Dialog for confirming reservation validation.
class ValidationDialog extends StatelessWidget {
  const ValidationDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: Icon(
        Icons.check_circle_outline,
        size: 48,
        color: Theme.of(context).colorScheme.primary,
      ),
      title: const Text('Validate Reservation'),
      content: const Text(
        'Are you sure you want to validate this reservation? '
        'The customer will receive a confirmation email.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancel'),
        ),
        FilledButton.icon(
          onPressed: () => Navigator.pop(context, true),
          icon: const Icon(Icons.check),
          label: const Text('Validate'),
        ),
      ],
    );
  }
}

/// Dialog for refusing a reservation with optional reason.
class RefusalDialog extends StatefulWidget {
  const RefusalDialog({super.key});

  @override
  State<RefusalDialog> createState() => _RefusalDialogState();
}

class _RefusalDialogState extends State<RefusalDialog> {
  final _reasonController = TextEditingController();

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: Icon(
        Icons.cancel_outlined,
        size: 48,
        color: Theme.of(context).colorScheme.error,
      ),
      title: const Text('Refuse Reservation'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Are you sure you want to refuse this reservation? '
            'This action cannot be undone.',
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _reasonController,
            decoration: InputDecoration(
              labelText: 'Reason (Optional)',
              hintText: 'Enter the reason for refusal',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            maxLines: 3,
            maxLength: 200,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton.icon(
          onPressed: () {
            Navigator.pop(context, _reasonController.text.trim());
          },
          icon: const Icon(Icons.close),
          label: const Text('Refuse'),
          style: FilledButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        ),
      ],
    );
  }
}

/// Utility class for showing validation dialogs.
class ReservationDialogs {
  ReservationDialogs._();

  /// Show validation confirmation dialog.
  static Future<bool> showValidationDialog(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => const ValidationDialog(),
    );
    return result ?? false;
  }

  /// Show refusal dialog with optional reason input.
  static Future<String?> showRefusalDialog(BuildContext context) async {
    return showDialog<String>(
      context: context,
      builder: (context) => const RefusalDialog(),
    );
  }
}
