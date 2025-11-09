import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Status badge for reservations
class StatusBadge extends StatelessWidget {
  final String status;

  const StatusBadge({
    super.key,
    required this.status,
  });

  Color _getStatusColor() {
    switch (status) {
      case 'EN_ATTENTE':
        return Colors.orange;
      case 'CONFIRMEE':
        return Colors.green;
      case 'ANNULEE':
        return Colors.red;
      case 'TERMINEE':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText() {
    switch (status) {
      case 'EN_ATTENTE':
        return 'En attente';
      case 'CONFIRMEE':
        return 'Confirmée';
      case 'ANNULEE':
        return 'Annulée';
      case 'TERMINEE':
        return 'Terminée';
      default:
        return status;
    }
  }

  IconData _getStatusIcon() {
    switch (status) {
      case 'EN_ATTENTE':
        return Icons.schedule;
      case 'CONFIRMEE':
        return Icons.check_circle;
      case 'ANNULEE':
        return Icons.cancel;
      case 'TERMINEE':
        return Icons.done_all;
      default:
        return Icons.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getStatusColor();

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spaceMd,
        vertical: AppTheme.spaceSm,
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(AppTheme.radiusFull),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getStatusIcon(),
            size: AppTheme.iconSm,
            color: Colors.white,
          ),
          const SizedBox(width: AppTheme.spaceXs),
          Text(
            _getStatusText(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
