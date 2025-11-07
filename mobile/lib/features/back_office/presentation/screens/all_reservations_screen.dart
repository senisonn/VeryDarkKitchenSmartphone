import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_names.dart';
import '../providers/admin_providers.dart';
import '../widgets/reservation_admin_card.dart';
import '../widgets/reservation_filters.dart';
import '../widgets/validation_dialog.dart';

/// Screen displaying all reservations for admin management.
class AllReservationsScreen extends ConsumerWidget {
  const AllReservationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dateFilter = ref.watch(dateFilterProvider);
    final statusFilter = ref.watch(statusFilterProvider);

    final reservationsAsync = ref.watch(
      allReservationsProvider(
        filterDate: dateFilter,
        filterStatus: statusFilter,
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('All Reservations'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              _showFiltersBottomSheet(context);
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.invalidate(allReservationsProvider);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Active Filters Display
          if (dateFilter != null || statusFilter != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  if (dateFilter != null)
                    Chip(
                      label: Text('Date: ${dateFilter.toString().split(' ')[0]}'),
                      onDeleted: () {
                        ref.read(dateFilterProvider.notifier).clear();
                      },
                    ),
                  if (statusFilter != null)
                    Chip(
                      label: Text('Status: ${statusFilter.name}'),
                      onDeleted: () {
                        ref.read(statusFilterProvider.notifier).clear();
                      },
                    ),
                ],
              ),
            ),

          // Reservations List
          Expanded(
            child: reservationsAsync.when(
              data: (reservations) {
                if (reservations.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.event_busy,
                          size: 64,
                          color: Theme.of(context).colorScheme.outline,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No Reservations Found',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        const Text('Try adjusting your filters'),
                        const SizedBox(height: 24),
                        if (dateFilter != null || statusFilter != null)
                          OutlinedButton.icon(
                            onPressed: () {
                              ref.read(dateFilterProvider.notifier).clear();
                              ref.read(statusFilterProvider.notifier).clear();
                            },
                            icon: const Icon(Icons.clear_all),
                            label: const Text('Clear Filters'),
                          ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    ref.invalidate(allReservationsProvider);
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: reservations.length,
                    itemBuilder: (context, index) {
                      final reservation = reservations[index];

                      return ReservationAdminCard(
                        reservation: reservation,
                        onTap: () {
                          context.push(
                            RouteNames.reservationDetailsRoute(reservation.id),
                          );
                        },
                        onValidate: () async {
                          final confirmed = await ReservationDialogs
                              .showValidationDialog(context);

                          if (confirmed && context.mounted) {
                            await ref
                                .read(validateReservationProvider.notifier)
                                .validate(reservation.id);

                            if (context.mounted) {
                              final validationState =
                                  ref.read(validateReservationProvider);

                              validationState.when(
                                data: (_) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Reservation validated successfully',
                                      ),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                },
                                loading: () {},
                                error: (error, _) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Error: $error'),
                                      backgroundColor: Theme.of(context)
                                          .colorScheme
                                          .error,
                                    ),
                                  );
                                },
                              );
                            }
                          }
                        },
                        onRefuse: () async {
                          final reason = await ReservationDialogs
                              .showRefusalDialog(context);

                          if (reason != null && context.mounted) {
                            await ref
                                .read(refuseReservationProvider.notifier)
                                .refuse(
                                  reservation.id,
                                  reason: reason.isNotEmpty ? reason : null,
                                );

                            if (context.mounted) {
                              final refusalState =
                                  ref.read(refuseReservationProvider);

                              refusalState.when(
                                data: (_) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Reservation refused successfully',
                                      ),
                                      backgroundColor: Colors.orange,
                                    ),
                                  );
                                },
                                loading: () {},
                                error: (error, _) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Error: $error'),
                                      backgroundColor: Theme.of(context)
                                          .colorScheme
                                          .error,
                                    ),
                                  );
                                },
                              );
                            }
                          }
                        },
                      );
                    },
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 64, color: Colors.red),
                    const SizedBox(height: 16),
                    Text(
                      'Error Loading Reservations',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Text(
                        error.toString(),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 24),
                    FilledButton.icon(
                      onPressed: () {
                        ref.invalidate(allReservationsProvider);
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showFiltersBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => const ReservationFilters(),
    );
  }
}
