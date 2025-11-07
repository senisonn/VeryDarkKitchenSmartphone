import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

/// Card variant types.
enum CardVariant {
  /// Elevated card with shadow (default).
  elevated,

  /// Filled card with background color.
  filled,

  /// Outlined card with border.
  outlined,
}

/// Custom card widget with consistent styling.
///
/// Provides reusable card component following Material 3 design principles.
///
/// Example:
/// ```dart
/// CustomCard(
///   child: Padding(
///     padding: EdgeInsets.all(16),
///     child: Text('Card content'),
///   ),
///   onTap: () => print('Card tapped'),
/// )
/// ```
class CustomCard extends StatelessWidget {
  const CustomCard({
    required this.child,
    this.onTap,
    this.variant = CardVariant.elevated,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.borderColor,
    this.elevation,
    this.borderRadius,
    super.key,
  });

  /// Card content.
  final Widget child;

  /// Tap callback.
  final VoidCallback? onTap;

  /// Card style variant.
  final CardVariant variant;

  /// Internal padding.
  final EdgeInsetsGeometry? padding;

  /// External margin.
  final EdgeInsetsGeometry? margin;

  /// Background color.
  final Color? backgroundColor;

  /// Border color (for outlined variant).
  final Color? borderColor;

  /// Elevation (for elevated variant).
  final double? elevation;

  /// Border radius.
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final BorderRadius effectiveBorderRadius =
        borderRadius ?? BorderRadius.circular(12);

    // Determine card styling based on variant
    final Color effectiveBackgroundColor = backgroundColor ??
        (variant == CardVariant.filled
            ? colorScheme.surfaceContainerHighest
            : colorScheme.surface);

    final double effectiveElevation = elevation ??
        (variant == CardVariant.elevated ? 1 : 0);

    final BorderSide? border = variant == CardVariant.outlined
        ? BorderSide(
            color: borderColor ?? colorScheme.outlineVariant,
            width: 1,
          )
        : null;

    final Widget cardContent = Container(
      padding: padding,
      child: child,
    );

    if (onTap != null) {
      return Card(
        margin: margin,
        elevation: effectiveElevation,
        color: effectiveBackgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: effectiveBorderRadius,
          side: border ?? BorderSide.none,
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          borderRadius: effectiveBorderRadius,
          child: cardContent,
        ),
      );
    }

    return Card(
      margin: margin,
      elevation: effectiveElevation,
      color: effectiveBackgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: effectiveBorderRadius,
        side: border ?? BorderSide.none,
      ),
      clipBehavior: Clip.antiAlias,
      child: cardContent,
    );
  }
}

/// Info card with icon and content.
///
/// Example:
/// ```dart
/// InfoCard(
///   icon: Icons.info_outline,
///   title: 'Important',
///   message: 'Please arrive 15 minutes early.',
/// )
/// ```
class InfoCard extends StatelessWidget {
  const InfoCard({
    required this.icon,
    required this.title,
    required this.message,
    this.iconColor,
    this.backgroundColor,
    this.onTap,
    this.actions,
    super.key,
  });

  /// Card icon.
  final IconData icon;

  /// Card title.
  final String title;

  /// Card message.
  final String message;

  /// Icon color.
  final Color? iconColor;

  /// Background color.
  final Color? backgroundColor;

  /// Tap callback.
  final VoidCallback? onTap;

  /// Optional action buttons.
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return CustomCard(
      variant: CardVariant.filled,
      backgroundColor:
          backgroundColor ?? colorScheme.primaryContainer.withOpacity(0.3),
      onTap: onTap,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: iconColor ?? colorScheme.primary,
                size: 24,
              ),
              const Gap(12),
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
            ],
          ),
          const Gap(8),
          Text(
            message,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          if (actions != null && actions!.isNotEmpty) ...[
            const Gap(12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: actions!,
            ),
          ],
        ],
      ),
    );
  }

  /// Success variant.
  static Widget success({
    required String title,
    required String message,
    VoidCallback? onTap,
    List<Widget>? actions,
  }) {
    return Builder(
      builder: (context) {
        final colorScheme = Theme.of(context).colorScheme;
        return InfoCard(
          icon: Icons.check_circle_outline,
          title: title,
          message: message,
          iconColor: colorScheme.primary,
          backgroundColor: colorScheme.primaryContainer.withOpacity(0.3),
          onTap: onTap,
          actions: actions,
        );
      },
    );
  }

  /// Warning variant.
  static Widget warning({
    required String title,
    required String message,
    VoidCallback? onTap,
    List<Widget>? actions,
  }) {
    return Builder(
      builder: (context) {
        return InfoCard(
          icon: Icons.warning_amber_outlined,
          title: title,
          message: message,
          iconColor: Colors.orange,
          backgroundColor: Colors.orange.withOpacity(0.1),
          onTap: onTap,
          actions: actions,
        );
      },
    );
  }

  /// Error variant.
  static Widget error({
    required String title,
    required String message,
    VoidCallback? onTap,
    List<Widget>? actions,
  }) {
    return Builder(
      builder: (context) {
        final colorScheme = Theme.of(context).colorScheme;
        return InfoCard(
          icon: Icons.error_outline,
          title: title,
          message: message,
          iconColor: colorScheme.error,
          backgroundColor: colorScheme.errorContainer.withOpacity(0.3),
          onTap: onTap,
          actions: actions,
        );
      },
    );
  }
}

/// Image card with overlay text.
///
/// Example:
/// ```dart
/// ImageCard(
///   imageUrl: 'https://example.com/image.jpg',
///   title: 'Delicious Pasta',
///   subtitle: 'Italian Cuisine',
///   onTap: () => navigateToDetails(),
/// )
/// ```
class ImageCard extends StatelessWidget {
  const ImageCard({
    required this.imageUrl,
    required this.title,
    this.subtitle,
    this.onTap,
    this.height = 200.0,
    this.imageWidget,
    this.overlayGradient = true,
    super.key,
  });

  /// Image URL.
  final String imageUrl;

  /// Card title (displayed over image).
  final String title;

  /// Optional subtitle.
  final String? subtitle;

  /// Tap callback.
  final VoidCallback? onTap;

  /// Card height.
  final double height;

  /// Custom image widget (overrides imageUrl).
  final Widget? imageWidget;

  /// Whether to show gradient overlay.
  final bool overlayGradient;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return CustomCard(
      onTap: onTap,
      padding: EdgeInsets.zero,
      child: SizedBox(
        height: height,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Image
            imageWidget ??
                Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: theme.colorScheme.surfaceContainerHighest,
                      child: Icon(
                        Icons.broken_image_outlined,
                        size: 48,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    );
                  },
                ),

            // Gradient overlay
            if (overlayGradient)
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.7),
                    ],
                  ),
                ),
              ),

            // Text overlay
            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.5),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),
                  if (subtitle != null) ...[
                    const Gap(4),
                    Text(
                      subtitle!,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withOpacity(0.9),
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.5),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Stat card for displaying metrics.
///
/// Example:
/// ```dart
/// StatCard(
///   title: 'Total Reservations',
///   value: '24',
///   icon: Icons.calendar_today,
///   trend: '+12%',
///   trendPositive: true,
/// )
/// ```
class StatCard extends StatelessWidget {
  const StatCard({
    required this.title,
    required this.value,
    this.icon,
    this.trend,
    this.trendPositive,
    this.onTap,
    super.key,
  });

  /// Stat title.
  final String title;

  /// Stat value.
  final String value;

  /// Optional icon.
  final IconData? icon;

  /// Optional trend indicator.
  final String? trend;

  /// Whether trend is positive.
  final bool? trendPositive;

  /// Tap callback.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return CustomCard(
      variant: CardVariant.outlined,
      onTap: onTap,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              if (icon != null)
                Icon(
                  icon,
                  color: colorScheme.primary,
                  size: 20,
                ),
            ],
          ),
          const Gap(8),
          Text(
            value,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          if (trend != null) ...[
            const Gap(4),
            Row(
              children: [
                Icon(
                  trendPositive == true
                      ? Icons.trending_up
                      : Icons.trending_down,
                  size: 16,
                  color: trendPositive == true ? Colors.green : Colors.red,
                ),
                const Gap(4),
                Text(
                  trend!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: trendPositive == true ? Colors.green : Colors.red,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

/// Action card with title, description, and action button.
///
/// Example:
/// ```dart
/// ActionCard(
///   icon: Icons.calendar_today,
///   title: 'Create Reservation',
///   description: 'Book a table at your favorite restaurant',
///   actionText: 'Get Started',
///   onAction: () => context.push(RouteNames.newReservation),
/// )
/// ```
class ActionCard extends StatelessWidget {
  const ActionCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.actionText,
    required this.onAction,
    this.iconColor,
    super.key,
  });

  /// Card icon.
  final IconData icon;

  /// Card title.
  final String title;

  /// Card description.
  final String description;

  /// Action button text.
  final String actionText;

  /// Action callback.
  final VoidCallback onAction;

  /// Icon color.
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return CustomCard(
      variant: CardVariant.outlined,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 40,
            color: iconColor ?? colorScheme.primary,
          ),
          const Gap(16),
          Text(
            title,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const Gap(8),
          Text(
            description,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const Gap(16),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: onAction,
              child: Text(actionText),
            ),
          ),
        ],
      ),
    );
  }
}
