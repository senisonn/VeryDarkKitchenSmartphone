import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../theme/app_theme.dart';

/// Shimmer loading effect for better loading states
class LoadingShimmer extends StatelessWidget {
  final double width;
  final double height;
  final BorderRadius? borderRadius;

  const LoadingShimmer({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Shimmer.fromColors(
      baseColor: isDark ? Colors.grey[800]! : Colors.grey[300]!,
      highlightColor: isDark ? Colors.grey[700]! : Colors.grey[100]!,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: borderRadius ?? BorderRadius.circular(AppTheme.radiusMd),
        ),
      ),
    );
  }
}

/// Grid loading shimmer for menu items
class MenuGridShimmer extends StatelessWidget {
  final int itemCount;

  const MenuGridShimmer({
    super.key,
    this.itemCount = 6,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(AppTheme.spaceMd),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: AppTheme.spaceMd,
        mainAxisSpacing: AppTheme.spaceMd,
      ),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: LoadingShimmer(
                  width: double.infinity,
                  height: double.infinity,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(AppTheme.radiusLg),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(AppTheme.spaceMd),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      LoadingShimmer(
                        width: double.infinity,
                        height: 16,
                      ),
                      const SizedBox(height: AppTheme.spaceSm),
                      LoadingShimmer(
                        width: 100,
                        height: 12,
                      ),
                      const Spacer(),
                      LoadingShimmer(
                        width: 60,
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// List loading shimmer for reservations
class ReservationListShimmer extends StatelessWidget {
  final int itemCount;

  const ReservationListShimmer({
    super.key,
    this.itemCount = 4,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(AppTheme.spaceMd),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.only(bottom: AppTheme.spaceMd),
          child: Padding(
            padding: const EdgeInsets.all(AppTheme.spaceMd),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    LoadingShimmer(width: 120, height: 20),
                    LoadingShimmer(width: 80, height: 24),
                  ],
                ),
                const SizedBox(height: AppTheme.spaceMd),
                LoadingShimmer(width: double.infinity, height: 14),
                const SizedBox(height: AppTheme.spaceSm),
                LoadingShimmer(width: 150, height: 14),
                const SizedBox(height: AppTheme.spaceSm),
                LoadingShimmer(width: 200, height: 14),
              ],
            ),
          ),
        );
      },
    );
  }
}
