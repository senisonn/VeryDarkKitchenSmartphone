import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:restaurant_reservation/shared/widgets/custom_button.dart';

/// Empty state widget for displaying when lists or content are empty.
///
/// Provides friendly empty state messages with optional actions following
/// Material 3 design principles.
///
/// Example:
/// ```dart
/// EmptyStateWidget(
///   icon: Icons.restaurant_menu,
///   title: 'No Menu Items',
///   message: 'There are no menu items available at the moment.',
///   actionText: 'Refresh',
///   onAction: () => ref.refresh(menuItemsProvider),
/// )
/// ```
class EmptyStateWidget extends StatelessWidget {
  const EmptyStateWidget({
    required this.icon,
    required this.title,
    required this.message,
    this.actionText,
    this.onAction,
    this.secondaryActionText,
    this.onSecondaryAction,
    this.illustration,
    super.key,
  });

  /// Icon to display.
  final IconData icon;

  /// Title text.
  final String title;

  /// Description message.
  final String message;

  /// Primary action button text.
  final String? actionText;

  /// Primary action callback.
  final VoidCallback? onAction;

  /// Secondary action button text.
  final String? secondaryActionText;

  /// Secondary action callback.
  final VoidCallback? onSecondaryAction;

  /// Optional custom illustration widget.
  final Widget? illustration;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Illustration or Icon
            if (illustration != null)
              illustration!
            else
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 64,
                  color: colorScheme.primary,
                ),
              ),
            const Gap(24),

            // Title
            Text(
              title,
              style: theme.textTheme.headlineSmall?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const Gap(12),

            // Message
            Text(
              message,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),

            // Actions
            if (actionText != null && onAction != null) ...[
              const Gap(24),
              CustomButton(
                text: actionText!,
                onPressed: onAction,
                variant: ButtonVariant.primary,
              ),
            ],
            if (secondaryActionText != null && onSecondaryAction != null) ...[
              const Gap(12),
              CustomButton(
                text: secondaryActionText!,
                onPressed: onSecondaryAction,
                variant: ButtonVariant.text,
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Compact empty state for smaller spaces.
  const EmptyStateWidget.compact({
    required this.icon,
    required this.message,
    super.key,
  })  : title = '',
        actionText = null,
        onAction = null,
        secondaryActionText = null,
        onSecondaryAction = null,
        illustration = null;

  /// Alternative builder for compact constructor.
  Widget _buildCompact(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 48,
              color: colorScheme.onSurfaceVariant,
            ),
            const Gap(12),
            Text(
              message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

/// Empty reservations state widget.
///
/// Example:
/// ```dart
/// EmptyReservationsWidget(
///   onCreateReservation: () => context.push(RouteNames.newReservation),
/// )
/// ```
class EmptyReservationsWidget extends StatelessWidget {
  const EmptyReservationsWidget({
    this.onCreateReservation,
    super.key,
  });

  /// Callback for create reservation action.
  final VoidCallback? onCreateReservation;

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      icon: Icons.calendar_today_outlined,
      title: 'No Reservations',
      message: 'You don\'t have any reservations yet.\nStart by creating your first reservation.',
      actionText: 'Create Reservation',
      onAction: onCreateReservation,
    );
  }
}

/// Empty menu items state widget.
///
/// Example:
/// ```dart
/// EmptyMenuWidget(
///   onRefresh: () => ref.refresh(menuItemsProvider),
/// )
/// ```
class EmptyMenuWidget extends StatelessWidget {
  const EmptyMenuWidget({
    this.onRefresh,
    super.key,
  });

  /// Callback for refresh action.
  final VoidCallback? onRefresh;

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      icon: Icons.restaurant_menu_outlined,
      title: 'No Menu Items',
      message: 'There are no menu items available at the moment.\nPlease check back later.',
      actionText: onRefresh != null ? 'Refresh' : null,
      onAction: onRefresh,
    );
  }
}

/// Empty search results state widget.
///
/// Example:
/// ```dart
/// EmptySearchWidget(
///   searchQuery: 'pizza',
///   onClearSearch: () => searchController.clear(),
/// )
/// ```
class EmptySearchWidget extends StatelessWidget {
  const EmptySearchWidget({
    required this.searchQuery,
    this.onClearSearch,
    super.key,
  });

  /// The search query that returned no results.
  final String searchQuery;

  /// Callback to clear search.
  final VoidCallback? onClearSearch;

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      icon: Icons.search_off,
      title: 'No Results Found',
      message: 'We couldn\'t find any results for "$searchQuery".\nTry a different search term.',
      actionText: 'Clear Search',
      onAction: onClearSearch,
    );
  }
}

/// Empty notifications state widget.
///
/// Example:
/// ```dart
/// EmptyNotificationsWidget()
/// ```
class EmptyNotificationsWidget extends StatelessWidget {
  const EmptyNotificationsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const EmptyStateWidget(
      icon: Icons.notifications_none_outlined,
      title: 'No Notifications',
      message: 'You\'re all caught up!\nYou have no new notifications.',
    );
  }
}

/// Empty favorites/bookmarks state widget.
///
/// Example:
/// ```dart
/// EmptyFavoritesWidget(
///   onBrowseMenu: () => context.push(RouteNames.menu),
/// )
/// ```
class EmptyFavoritesWidget extends StatelessWidget {
  const EmptyFavoritesWidget({
    this.onBrowseMenu,
    super.key,
  });

  /// Callback to browse menu.
  final VoidCallback? onBrowseMenu;

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      icon: Icons.favorite_border,
      title: 'No Favorites',
      message: 'You haven\'t added any favorites yet.\nStart browsing the menu to find your favorites.',
      actionText: 'Browse Menu',
      onAction: onBrowseMenu,
    );
  }
}

/// Empty history state widget.
///
/// Example:
/// ```dart
/// EmptyHistoryWidget()
/// ```
class EmptyHistoryWidget extends StatelessWidget {
  const EmptyHistoryWidget({
    this.message,
    super.key,
  });

  /// Custom message.
  final String? message;

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      icon: Icons.history,
      title: 'No History',
      message: message ?? 'You don\'t have any history yet.\nYour activity will appear here.',
    );
  }
}

/// Empty filtered results widget.
///
/// Example:
/// ```dart
/// EmptyFilteredResultsWidget(
///   onClearFilters: () => ref.read(filtersProvider.notifier).clear(),
/// )
/// ```
class EmptyFilteredResultsWidget extends StatelessWidget {
  const EmptyFilteredResultsWidget({
    this.onClearFilters,
    this.message,
    super.key,
  });

  /// Callback to clear filters.
  final VoidCallback? onClearFilters;

  /// Custom message.
  final String? message;

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      icon: Icons.filter_list_off,
      title: 'No Results',
      message: message ?? 'No items match your filters.\nTry adjusting your filter criteria.',
      actionText: 'Clear Filters',
      onAction: onClearFilters,
    );
  }
}

/// Generic "Coming Soon" placeholder widget.
///
/// Example:
/// ```dart
/// ComingSoonWidget(
///   title: 'Table Management',
///   message: 'This feature is coming soon!',
/// )
/// ```
class ComingSoonWidget extends StatelessWidget {
  const ComingSoonWidget({
    this.title = 'Coming Soon',
    this.message,
    super.key,
  });

  /// Title text.
  final String title;

  /// Description message.
  final String? message;

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      icon: Icons.schedule,
      title: title,
      message: message ?? 'This feature is currently under development.\nStay tuned for updates!',
    );
  }
}

/// Maintenance mode widget.
///
/// Example:
/// ```dart
/// MaintenanceWidget(
///   onRetry: () => ref.refresh(statusProvider),
/// )
/// ```
class MaintenanceWidget extends StatelessWidget {
  const MaintenanceWidget({
    this.onRetry,
    this.message,
    super.key,
  });

  /// Callback for retry action.
  final VoidCallback? onRetry;

  /// Custom message.
  final String? message;

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      icon: Icons.build_outlined,
      title: 'Under Maintenance',
      message: message ?? 'We\'re performing scheduled maintenance.\nPlease check back in a few minutes.',
      actionText: 'Retry',
      onAction: onRetry,
    );
  }
}

/// Inline empty state for lists.
///
/// Example:
/// ```dart
/// InlineEmptyState(
///   message: 'No items to display',
/// )
/// ```
class InlineEmptyState extends StatelessWidget {
  const InlineEmptyState({
    required this.message,
    this.icon,
    super.key,
  });

  /// Message to display.
  final String message;

  /// Optional icon.
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: 20,
              color: colorScheme.onSurfaceVariant,
            ),
            const Gap(8),
          ],
          Text(
            message,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
