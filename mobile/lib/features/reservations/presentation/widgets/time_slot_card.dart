import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/time_slot.dart';

/// Card for selecting a time slot.
class TimeSlotCard extends StatelessWidget {
  const TimeSlotCard({
    super.key,
    required this.slot,
    required this.isSelected,
    required this.onTap,
  });

  final TimeSlot slot;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final timeFormat = DateFormat.jm();
    final isAvailable = slot.isAvailable;
    final canTap = isAvailable && onTap != null;

    return Card(
      elevation: isSelected ? 4 : 1,
      color: isSelected
          ? Theme.of(context).colorScheme.primaryContainer
          : isAvailable
              ? null
              : Theme.of(context).colorScheme.surfaceContainerHighest,
      child: InkWell(
        onTap: canTap ? onTap : null,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Time Range
              Text(
                '${timeFormat.format(slot.startTime)} - '
                '${timeFormat.format(slot.endTime)}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isSelected
                          ? Theme.of(context).colorScheme.onPrimaryContainer
                          : isAvailable
                              ? null
                              : Theme.of(context).colorScheme.outline,
                    ),
              ),
              const SizedBox(height: 8),

              // Availability Badge
              if (!isAvailable)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.errorContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Full',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onErrorContainer,
                    ),
                  ),
                )
              else if (slot.capacity != null && slot.bookedCount != null) ...[
                // Capacity Info
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.people,
                      size: 16,
                      color: isSelected
                          ? Theme.of(context).colorScheme.onPrimaryContainer
                          : Theme.of(context).colorScheme.outline,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${slot.capacity! - slot.bookedCount!} spots left',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: isSelected
                                ? Theme.of(context)
                                    .colorScheme
                                    .onPrimaryContainer
                                : Theme.of(context).colorScheme.outline,
                          ),
                    ),
                  ],
                ),
              ],

              // Selected Indicator
              if (isSelected) ...[
                const SizedBox(height: 8),
                Icon(
                  Icons.check_circle,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                  size: 20,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
