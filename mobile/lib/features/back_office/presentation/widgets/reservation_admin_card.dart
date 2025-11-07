import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../reservations/domain/entities/reservation.dart';
import '../../../reservations/presentation/widgets/status_badge.dart';

/// Admin view card for displaying a reservation with action buttons.
class ReservationAdminCard extends StatelessWidget {
  const ReservationAdminCard({
    super.key,
    required this.reservation,
    this.onTap,
    this.onValidate,
    this.onRefuse,
  });

  final Reservation reservation;
  final VoidCallback? onTap;
  final VoidCallback? onValidate;
  final VoidCallback? onRefuse;

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat.yMMMMd();
    final timeFormat = DateFormat.jm();

    final canValidate = reservation.status == ReservationStatus.pending;
    final canRefuse = reservation.status == ReservationStatus.pending ||
        reservation.status == ReservationStatus.confirmed;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Status & Date
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  StatusBadge(status: reservation.status),
                  Text(
                    dateFormat.format(reservation.date),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
              const Divider(height: 24),

              // Reservation Details
              Row(
                children: [
                  // Time
                  Expanded(
                    child: Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 18,
                          color: Theme.of(context).colorScheme.outline,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            reservation.startTime != null &&
                                    reservation.endTime != null
                                ? '${timeFormat.format(reservation.startTime!)} - '
                                    '${timeFormat.format(reservation.endTime!)}'
                                : reservation.timeSlotId,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 16),

                  // Guests
                  Row(
                    children: [
                      Icon(
                        Icons.people,
                        size: 18,
                        color: Theme.of(context).colorScheme.outline,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${reservation.guests}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Contact Info
              if (reservation.name != null) ...[
                Row(
                  children: [
                    Icon(
                      Icons.person,
                      size: 18,
                      color: Theme.of(context).colorScheme.outline,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        reservation.name!,
                        style: Theme.of(context).textTheme.bodyMedium,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
              ],

              if (reservation.phone != null) ...[
                Row(
                  children: [
                    Icon(
                      Icons.phone,
                      size: 18,
                      color: Theme.of(context).colorScheme.outline,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      reservation.phone!,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
              ],

              // Reservation ID
              Row(
                children: [
                  Icon(
                    Icons.confirmation_number,
                    size: 18,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'ID: ${reservation.id}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontFamily: 'monospace',
                            color: Theme.of(context).colorScheme.outline,
                          ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),

              // Action Buttons
              if (canValidate || canRefuse) ...[
                const Divider(height: 24),
                Row(
                  children: [
                    if (canValidate) ...[
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: onValidate,
                          icon: const Icon(Icons.check, size: 18),
                          label: const Text('Validate'),
                          style: FilledButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                    ],
                    if (canValidate && canRefuse) const SizedBox(width: 12),
                    if (canRefuse) ...[
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: onRefuse,
                          icon: const Icon(Icons.close, size: 18),
                          label: const Text('Refuse'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Theme.of(context).colorScheme.error,
                            side: BorderSide(
                              color: Theme.of(context).colorScheme.error,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
