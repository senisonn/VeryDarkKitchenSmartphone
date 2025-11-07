import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../reservations/domain/entities/reservation.dart';
import '../providers/admin_providers.dart';

/// Filter widget for admin reservations view.
class ReservationFilters extends ConsumerWidget {
  const ReservationFilters({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dateFilter = ref.watch(dateFilterProvider);
    final statusFilter = ref.watch(statusFilterProvider);

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Icon(
                  Icons.filter_list,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 12),
                Text(
                  'Filters',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const Spacer(),
                if (dateFilter != null || statusFilter != null)
                  TextButton.icon(
                    onPressed: () {
                      ref.read(dateFilterProvider.notifier).clear();
                      ref.read(statusFilterProvider.notifier).clear();
                    },
                    icon: const Icon(Icons.clear_all, size: 18),
                    label: const Text('Clear'),
                  ),
              ],
            ),
            const SizedBox(height: 16),

            // Date Filter
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _selectDate(context, ref),
                    icon: const Icon(Icons.calendar_today, size: 18),
                    label: Text(
                      dateFilter != null
                          ? DateFormat.yMMMMd().format(dateFilter)
                          : 'Select Date',
                    ),
                  ),
                ),
                if (dateFilter != null) ...[
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: () {
                      ref.read(dateFilterProvider.notifier).clear();
                    },
                    icon: const Icon(Icons.clear),
                    tooltip: 'Clear date filter',
                  ),
                ],
              ],
            ),
            const SizedBox(height: 12),

            // Status Filter
            Text(
              'Status',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _StatusFilterChip(
                  label: 'All',
                  isSelected: statusFilter == null,
                  onSelected: () {
                    ref.read(statusFilterProvider.notifier).clear();
                  },
                ),
                ...ReservationStatus.values.map(
                  (status) => _StatusFilterChip(
                    label: _formatStatus(status),
                    isSelected: statusFilter == status,
                    onSelected: () {
                      ref.read(statusFilterProvider.notifier).select(status);
                    },
                    color: _getStatusColor(context, status),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context, WidgetRef ref) async {
    final currentDate = ref.read(dateFilterProvider);

    final selectedDate = await showDatePicker(
      context: context,
      initialDate: currentDate ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (selectedDate != null) {
      ref.read(dateFilterProvider.notifier).select(selectedDate);
    }
  }

  String _formatStatus(ReservationStatus status) {
    switch (status) {
      case ReservationStatus.pending:
        return 'Pending';
      case ReservationStatus.confirmed:
        return 'Confirmed';
      case ReservationStatus.canceled:
        return 'Canceled';
      case ReservationStatus.completed:
        return 'Completed';
    }
  }

  Color? _getStatusColor(BuildContext context, ReservationStatus status) {
    switch (status) {
      case ReservationStatus.pending:
        return Colors.orange;
      case ReservationStatus.confirmed:
        return Colors.green;
      case ReservationStatus.canceled:
        return Colors.red;
      case ReservationStatus.completed:
        return Colors.blue;
    }
  }
}

class _StatusFilterChip extends StatelessWidget {
  const _StatusFilterChip({
    required this.label,
    required this.isSelected,
    required this.onSelected,
    this.color,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onSelected;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onSelected(),
      backgroundColor: color?.withOpacity(0.1),
      selectedColor: color?.withOpacity(0.3) ??
          Theme.of(context).colorScheme.primaryContainer,
      checkmarkColor: color ?? Theme.of(context).colorScheme.primary,
    );
  }
}
