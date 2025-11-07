import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:shimmer/shimmer.dart';

/// Loading widget with shimmer effect.
///
/// Provides various loading states with shimmer animations following
/// Material 3 design principles.
///
/// Example:
/// ```dart
/// // Simple circular loader
/// LoadingWidget()
///
/// // With message
/// LoadingWidget.withMessage(message: 'Loading menu items...')
///
/// // Shimmer list
/// LoadingWidget.listShimmer(itemCount: 5)
/// ```
class LoadingWidget extends StatelessWidget {
  const LoadingWidget({
    this.size = 48.0,
    this.color,
    this.message,
    super.key,
  });

  /// Size of the loading indicator.
  final double size;

  /// Color of the loading indicator.
  final Color? color;

  /// Optional loading message.
  final String? message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: CircularProgressIndicator(
          strokeWidth: 3,
          valueColor: AlwaysStoppedAnimation<Color>(
            color ?? theme.colorScheme.primary,
          ),
        ),
      ),
    );
  }

  /// Loading widget with a message below the indicator.
  const LoadingWidget.withMessage({
    required String message,
    this.size = 48.0,
    this.color,
    super.key,
  }) : message = message;

  /// Alternative builder for withMessage constructor.
  Widget _buildWithMessage(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(
                color ?? theme.colorScheme.primary,
              ),
            ),
          ),
          if (message != null) ...[
            const Gap(16),
            Text(
              message!,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  /// Shimmer loading effect for list items.
  static Widget listShimmer({
    int itemCount = 3,
    double itemHeight = 80.0,
    EdgeInsets? padding,
  }) {
    return ListView.separated(
      padding: padding ?? const EdgeInsets.all(16),
      itemCount: itemCount,
      separatorBuilder: (_, __) => const Gap(12),
      itemBuilder: (context, index) {
        return ShimmerBox(
          height: itemHeight,
          borderRadius: BorderRadius.circular(12),
        );
      },
    );
  }

  /// Shimmer loading effect for card items.
  static Widget cardShimmer({
    int itemCount = 2,
    EdgeInsets? padding,
  }) {
    return ListView.separated(
      padding: padding ?? const EdgeInsets.all(16),
      itemCount: itemCount,
      separatorBuilder: (_, __) => const Gap(16),
      itemBuilder: (context, index) {
        return const ShimmerCard();
      },
    );
  }

  /// Shimmer loading effect for grid items.
  static Widget gridShimmer({
    int itemCount = 6,
    int crossAxisCount = 2,
    double childAspectRatio = 1.0,
    EdgeInsets? padding,
  }) {
    return GridView.builder(
      padding: padding ?? const EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: childAspectRatio,
      ),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return ShimmerBox(
          borderRadius: BorderRadius.circular(12),
        );
      },
    );
  }

  /// Shimmer loading for a single detail screen.
  static Widget detailShimmer({EdgeInsets? padding}) {
    return SingleChildScrollView(
      padding: padding ?? const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image placeholder
          ShimmerBox(
            height: 200,
            borderRadius: BorderRadius.circular(16),
          ),
          const Gap(24),
          // Title placeholder
          const ShimmerBox(height: 24, width: 200),
          const Gap(12),
          // Subtitle placeholder
          const ShimmerBox(height: 16, width: 150),
          const Gap(24),
          // Description placeholders
          const ShimmerBox(height: 12, width: double.infinity),
          const Gap(8),
          const ShimmerBox(height: 12, width: double.infinity),
          const Gap(8),
          const ShimmerBox(height: 12, width: 250),
          const Gap(24),
          // Button placeholders
          Row(
            children: [
              Expanded(
                child: ShimmerBox(
                  height: 48,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              const Gap(12),
              Expanded(
                child: ShimmerBox(
                  height: 48,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Shimmer box widget for creating custom shimmer effects.
///
/// Example:
/// ```dart
/// ShimmerBox(
///   height: 100,
///   width: 200,
///   borderRadius: BorderRadius.circular(8),
/// )
/// ```
class ShimmerBox extends StatelessWidget {
  const ShimmerBox({
    this.height,
    this.width,
    this.borderRadius,
    super.key,
  });

  /// Height of the box.
  final double? height;

  /// Width of the box.
  final double? width;

  /// Border radius of the box.
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Shimmer.fromColors(
      baseColor: isDark
          ? theme.colorScheme.surfaceContainerHighest
          : Colors.grey[300]!,
      highlightColor: isDark
          ? theme.colorScheme.surfaceContainerHigh
          : Colors.grey[100]!,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest,
          borderRadius: borderRadius ?? BorderRadius.circular(4),
        ),
      ),
    );
  }
}

/// Shimmer card widget with standard card layout.
///
/// Example:
/// ```dart
/// ShimmerCard()
/// ```
class ShimmerCard extends StatelessWidget {
  const ShimmerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Theme.of(context).colorScheme.outlineVariant,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image placeholder
            ShimmerBox(
              height: 80,
              width: 80,
              borderRadius: BorderRadius.circular(8),
            ),
            const Gap(16),
            // Content placeholder
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const ShimmerBox(height: 16, width: 150),
                  const Gap(8),
                  const ShimmerBox(height: 12, width: double.infinity),
                  const Gap(6),
                  const ShimmerBox(height: 12, width: 200),
                  const Gap(12),
                  Row(
                    children: [
                      const ShimmerBox(height: 12, width: 60),
                      const Gap(16),
                      ShimmerBox(
                        height: 12,
                        width: 60,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Linear loading indicator that can be placed at the top of a screen.
///
/// Example:
/// ```dart
/// LinearLoadingIndicator(isLoading: isLoadingState)
/// ```
class LinearLoadingIndicator extends StatelessWidget {
  const LinearLoadingIndicator({
    required this.isLoading,
    this.height = 3.0,
    this.color,
    super.key,
  });

  /// Whether to show the loading indicator.
  final bool isLoading;

  /// Height of the indicator.
  final double height;

  /// Color of the indicator.
  final Color? color;

  @override
  Widget build(BuildContext context) {
    if (!isLoading) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: height,
      child: LinearProgressIndicator(
        valueColor: color != null
            ? AlwaysStoppedAnimation<Color>(color!)
            : null,
      ),
    );
  }
}

/// Skeleton loader for text content.
///
/// Example:
/// ```dart
/// TextSkeleton(width: 150)
/// ```
class TextSkeleton extends StatelessWidget {
  const TextSkeleton({
    this.width,
    this.height = 12.0,
    super.key,
  });

  /// Width of the skeleton.
  final double? width;

  /// Height of the skeleton (defaults to text height).
  final double height;

  @override
  Widget build(BuildContext context) {
    return ShimmerBox(
      height: height,
      width: width,
      borderRadius: BorderRadius.circular(4),
    );
  }
}

/// Circular skeleton loader (for avatars, icons, etc).
///
/// Example:
/// ```dart
/// CircleSkeleton(size: 48)
/// ```
class CircleSkeleton extends StatelessWidget {
  const CircleSkeleton({
    required this.size,
    super.key,
  });

  /// Diameter of the circle.
  final double size;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Shimmer.fromColors(
      baseColor: isDark
          ? theme.colorScheme.surfaceContainerHighest
          : Colors.grey[300]!,
      highlightColor: isDark
          ? theme.colorScheme.surfaceContainerHigh
          : Colors.grey[100]!,
      child: Container(
        height: size,
        width: size,
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

/// Full screen loading overlay.
///
/// Example:
/// ```dart
/// LoadingOverlay(
///   isLoading: isSubmitting,
///   message: 'Creating reservation...',
///   child: YourContent(),
/// )
/// ```
class LoadingOverlay extends StatelessWidget {
  const LoadingOverlay({
    required this.isLoading,
    required this.child,
    this.message,
    super.key,
  });

  /// Whether to show the loading overlay.
  final bool isLoading;

  /// The child widget to display under the overlay.
  final Widget child;

  /// Optional loading message.
  final String? message;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Container(
            color: Colors.black54,
            child: Center(
              child: Card(
                margin: const EdgeInsets.all(32),
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircularProgressIndicator(),
                      if (message != null) ...[
                        const Gap(16),
                        Text(
                          message!,
                          style: Theme.of(context).textTheme.bodyLarge,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
