import 'package:flutter/material.dart';

import '../../domain/entities/reservation.dart';

/// Badge displaying reservation status with appropriate color.
class StatusBadge extends StatelessWidget {
  const StatusBadge({
    super.key,
    required this.status,
  });

  final ReservationStatus status;

  @override
  Widget build(BuildContext context) {
    final config = _getStatusConfig(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: config.backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            config.icon,
            size: 16,
            color: config.textColor,
          ),
          const SizedBox(width: 4),
          Text(
            config.label,
            style: TextStyle(
              color: config.textColor,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  _StatusConfig _getStatusConfig(BuildContext context) {
    switch (status) {
      case ReservationStatus.pending:
        return _StatusConfig(
          label: 'Pending',
          icon: Icons.schedule,
          backgroundColor: Colors.orange.shade100,
          textColor: Colors.orange.shade900,
        );
      case ReservationStatus.confirmed:
        return _StatusConfig(
          label: 'Confirmed',
          icon: Icons.check_circle,
          backgroundColor: Colors.green.shade100,
          textColor: Colors.green.shade900,
        );
      case ReservationStatus.canceled:
        return _StatusConfig(
          label: 'Canceled',
          icon: Icons.cancel,
          backgroundColor: Colors.red.shade100,
          textColor: Colors.red.shade900,
        );
      case ReservationStatus.completed:
        return _StatusConfig(
          label: 'Completed',
          icon: Icons.done_all,
          backgroundColor: Colors.blue.shade100,
          textColor: Colors.blue.shade900,
        );
    }
  }
}

class _StatusConfig {
  const _StatusConfig({
    required this.label,
    required this.icon,
    required this.backgroundColor,
    required this.textColor,
  });

  final String label;
  final IconData icon;
  final Color backgroundColor;
  final Color textColor;
}
