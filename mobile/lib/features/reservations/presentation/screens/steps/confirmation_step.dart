import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../../core/router/route_names.dart';
import '../../providers/reservation_providers.dart';

/// Step 4: Review and confirm reservation.
class ConfirmationStep extends ConsumerWidget {
  const ConfirmationStep({
    super.key,
    required this.onBack,
  });

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDate = ref.watch(selectedDateProvider);
    final selectedSlot = ref.watch(selectedTimeSlotProvider);
    final guestCount = ref.watch(guestCountProvider);
    final guestName = ref.watch(guestNameProvider);
    final guestPhone = ref.watch(guestPhoneProvider);
    final guestEmail = ref.watch(guestEmailProvider);
    final notes = ref.watch(reservationNotesProvider);
    final createState = ref.watch(createReservationProvider);

    final dateFormat = DateFormat.yMMMMEEEEd();
    final timeFormat = DateFormat.jm();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Text(
            'Review Your Reservation',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Please review your reservation details before confirming',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.outline,
                ),
          ),
          const SizedBox(height: 24),

          // Reservation Details Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Date
                  _buildInfoRow(
                    context,
                    icon: Icons.calendar_today,
                    label: 'Date',
                    value: selectedDate != null
                        ? dateFormat.format(selectedDate)
                        : 'Not selected',
                  ),
                  const Divider(height: 24),

                  // Time
                  _buildInfoRow(
                    context,
                    icon: Icons.access_time,
                    label: 'Time',
                    value: selectedSlot != null
                        ? '${timeFormat.format(selectedSlot.start)} - '
                            '${timeFormat.format(selectedSlot.end)}'
                        : 'Not selected',
                  ),
                  const Divider(height: 24),

                  // Guests
                  _buildInfoRow(
                    context,
                    icon: Icons.people,
                    label: 'Guests',
                    value: '$guestCount ${guestCount == 1 ? 'guest' : 'guests'}',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Contact Information Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Contact Information',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),

                  _buildInfoRow(
                    context,
                    icon: Icons.person,
                    label: 'Name',
                    value: guestName.isEmpty ? 'Not provided' : guestName,
                  ),
                  const Divider(height: 24),

                  _buildInfoRow(
                    context,
                    icon: Icons.phone,
                    label: 'Phone',
                    value: guestPhone.isEmpty ? 'Not provided' : guestPhone,
                  ),
                  const Divider(height: 24),

                  _buildInfoRow(
                    context,
                    icon: Icons.email,
                    label: 'Email',
                    value: guestEmail.isEmpty ? 'Not provided' : guestEmail,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Special Requests Card
          if (notes.isNotEmpty) ...[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.note,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Special Requests',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      notes,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Info Box
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'You will receive a confirmation email once your reservation is confirmed by the restaurant.',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Error Display
          createState.when(
            data: (reservation) {
              if (reservation != null) {
                // Success! Navigate to confirmation
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  context.go(RouteNames.reservations);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Reservation created successfully!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                  // Reset form
                  ref.read(createReservationProvider.notifier).reset();
                });
              }
              return const SizedBox.shrink();
            },
            loading: () => const SizedBox.shrink(),
            error: (error, stack) => Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.errorContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.error_outline,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Error Creating Reservation',
                          style:
                              Theme.of(context).textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).colorScheme.error,
                                  ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          error.toString(),
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Theme.of(context).colorScheme.error,
                                  ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Confirm Button
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: createState.isLoading
                  ? null
                  : () {
                      ref.read(createReservationProvider.notifier).create();
                    },
              icon: createState.isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.check),
              label: Text(
                createState.isLoading
                    ? 'Creating Reservation...'
                    : 'Confirm Reservation',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: Theme.of(context).colorScheme.outline,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.outline,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
