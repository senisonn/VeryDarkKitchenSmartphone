import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/reservation.dart';
import '../providers/reservation_providers.dart';
import '../widgets/status_badge.dart';

/// Detail screen for a single reservation.
class ReservationDetailScreen extends ConsumerWidget {
  const ReservationDetailScreen({
    super.key,
    required this.reservationId,
  });

  final String reservationId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reservationAsync = ref.watch(reservationProvider(reservationId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reservation Details'),
      ),
      body: reservationAsync.when(
        data: (reservation) => _buildContent(context, ref, reservation),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error: $error'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    WidgetRef ref,
    Reservation reservation,
  ) {
    final dateFormat = DateFormat.yMMMMd();
    final timeFormat = DateFormat.jm();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status
          Center(
            child: StatusBadge(status: reservation.status),
          ),
          const SizedBox(height: 24),

          // Reservation ID
          _buildInfoCard(
            context,
            icon: Icons.confirmation_number,
            title: 'Reservation ID',
            value: reservation.id,
          ),
          const SizedBox(height: 16),

          // Date & Time
          _buildInfoCard(
            context,
            icon: Icons.calendar_today,
            title: 'Date',
            value: dateFormat.format(reservation.date),
          ),
          const SizedBox(height: 16),

          _buildInfoCard(
            context,
            icon: Icons.access_time,
            title: 'Time',
            value: reservation.startTime != null && reservation.endTime != null
                ? '${timeFormat.format(reservation.startTime!)} - '
                    '${timeFormat.format(reservation.endTime!)}'
                : 'Time slot: ${reservation.timeSlotId}',
          ),
          const SizedBox(height: 16),

          // Guests
          _buildInfoCard(
            context,
            icon: Icons.people,
            title: 'Number of Guests',
            value: '${reservation.guests} ${reservation.guests == 1 ? 'guest' : 'guests'}',
          ),
          const SizedBox(height: 16),

          // Contact Info
          if (reservation.name != null) ...[
            _buildInfoCard(
              context,
              icon: Icons.person,
              title: 'Name',
              value: reservation.name!,
            ),
            const SizedBox(height: 16),
          ],

          if (reservation.phone != null) ...[
            _buildInfoCard(
              context,
              icon: Icons.phone,
              title: 'Phone',
              value: reservation.phone!,
            ),
            const SizedBox(height: 16),
          ],

          if (reservation.email != null) ...[
            _buildInfoCard(
              context,
              icon: Icons.email,
              title: 'Email',
              value: reservation.email!,
            ),
            const SizedBox(height: 16),
          ],

          // Notes
          if (reservation.notes != null && reservation.notes!.isNotEmpty) ...[
            _buildInfoCard(
              context,
              icon: Icons.note,
              title: 'Notes',
              value: reservation.notes!,
            ),
            const SizedBox(height: 16),
          ],

          // Timestamps
          _buildInfoCard(
            context,
            icon: Icons.schedule,
            title: 'Created',
            value: dateFormat.format(reservation.createdAt),
          ),
          const SizedBox(height: 32),

          // Actions
          if (reservation.status == ReservationStatus.pending ||
              reservation.status == ReservationStatus.confirmed) ...[
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _cancelReservation(context, ref, reservation),
                icon: const Icon(Icons.cancel),
                label: const Text('Cancel Reservation'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.error,
                  foregroundColor: Theme.of(context).colorScheme.onError,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _cancelReservation(
    BuildContext context,
    WidgetRef ref,
    Reservation reservation,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Reservation'),
        content: const Text(
          'Are you sure you want to cancel this reservation? '
          'This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('No'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Yes, Cancel'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      await ref
          .read(cancelReservationProvider.notifier)
          .cancel(reservation.id);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Reservation cancelled successfully'),
          ),
        );
        Navigator.pop(context);
      }
    }
  }
}
