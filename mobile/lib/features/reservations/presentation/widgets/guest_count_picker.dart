import 'package:flutter/material.dart';

/// Widget for selecting the number of guests for a reservation.
class GuestCountPicker extends StatelessWidget {
  const GuestCountPicker({
    super.key,
    required this.guestCount,
    required this.onChanged,
    this.minGuests = 1,
    this.maxGuests = 20,
  });

  final int guestCount;
  final ValueChanged<int> onChanged;
  final int minGuests;
  final int maxGuests;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.people,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 12),
                Text(
                  'Number of Guests',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Decrement Button
                IconButton.filled(
                  onPressed: guestCount > minGuests
                      ? () => onChanged(guestCount - 1)
                      : null,
                  icon: const Icon(Icons.remove),
                  style: IconButton.styleFrom(
                    backgroundColor: guestCount > minGuests
                        ? Theme.of(context).colorScheme.primaryContainer
                        : Theme.of(context)
                            .colorScheme
                            .surfaceContainerHighest,
                    foregroundColor: guestCount > minGuests
                        ? Theme.of(context).colorScheme.onPrimaryContainer
                        : Theme.of(context).colorScheme.outline,
                  ),
                ),
                const SizedBox(width: 24),

                // Guest Count Display
                Container(
                  width: 80,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '$guestCount',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                  ),
                ),
                const SizedBox(width: 24),

                // Increment Button
                IconButton.filled(
                  onPressed: guestCount < maxGuests
                      ? () => onChanged(guestCount + 1)
                      : null,
                  icon: const Icon(Icons.add),
                  style: IconButton.styleFrom(
                    backgroundColor: guestCount < maxGuests
                        ? Theme.of(context).colorScheme.primaryContainer
                        : Theme.of(context)
                            .colorScheme
                            .surfaceContainerHighest,
                    foregroundColor: guestCount < maxGuests
                        ? Theme.of(context).colorScheme.onPrimaryContainer
                        : Theme.of(context).colorScheme.outline,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Guest Count Info
            Center(
              child: Text(
                '${guestCount == 1 ? 'guest' : 'guests'}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.outline,
                    ),
              ),
            ),

            // Min/Max Info
            if (guestCount == minGuests || guestCount == maxGuests) ...[
              const SizedBox(height: 8),
              Center(
                child: Text(
                  guestCount == minGuests
                      ? 'Minimum: $minGuests guest'
                      : 'Maximum: $maxGuests guests',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.outline,
                        fontStyle: FontStyle.italic,
                      ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
