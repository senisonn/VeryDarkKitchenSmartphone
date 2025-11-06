import 'package:flutter/material.dart';

import '../../../../core/theme/app_dimensions.dart';
import '../../domain/entities/menu_item.dart';

/// Card widget to display a menu item.
class MenuItemCard extends StatelessWidget {
  final MenuItem item;
  final VoidCallback? onTap;

  const MenuItemCard({
    super.key,
    required this.item,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: item.isAvailable ? onTap : null,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            AspectRatio(
              aspectRatio: 16 / 9,
              child: item.imageUrl != null
                  ? Image.network(
                      item.imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          _buildPlaceholder(colorScheme),
                    )
                  : _buildPlaceholder(colorScheme),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(AppDimensions.spacing12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name and availability
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.name,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: item.isAvailable
                                ? colorScheme.onSurface
                                : colorScheme.onSurfaceVariant,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (!item.isAvailable)
                        Chip(
                          label: const Text('Unavailable'),
                          labelStyle: theme.textTheme.labelSmall,
                          backgroundColor: colorScheme.errorContainer,
                          side: BorderSide.none,
                          padding: EdgeInsets.zero,
                        ),
                    ],
                  ),
                  const SizedBox(height: AppDimensions.spacing8),

                  // Description
                  Text(
                    item.description,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppDimensions.spacing12),

                  // Dietary badges
                  if (item.isVegetarian || item.isVegan || item.isGlutenFree)
                    Wrap(
                      spacing: AppDimensions.spacing8,
                      runSpacing: AppDimensions.spacing4,
                      children: [
                        if (item.isVegan)
                          _DietaryBadge(
                            icon: Icons.spa_outlined,
                            label: 'Vegan',
                            color: Colors.green,
                          ),
                        if (item.isVegetarian && !item.isVegan)
                          _DietaryBadge(
                            icon: Icons.eco_outlined,
                            label: 'Vegetarian',
                            color: Colors.lightGreen,
                          ),
                        if (item.isGlutenFree)
                          _DietaryBadge(
                            icon: Icons.grain_outlined,
                            label: 'Gluten-Free',
                            color: Colors.orange,
                          ),
                      ],
                    ),
                  const SizedBox(height: AppDimensions.spacing12),

                  // Price and prep time
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${item.price.toStringAsFixed(2)}',
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 16,
                            color: colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(width: AppDimensions.spacing4),
                          Text(
                            '${item.preparationTime} min',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
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

  Widget _buildPlaceholder(ColorScheme colorScheme) {
    return Container(
      color: colorScheme.surfaceVariant,
      child: Icon(
        Icons.restaurant_menu,
        size: 64,
        color: colorScheme.onSurfaceVariant,
      ),
    );
  }
}

class _DietaryBadge extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _DietaryBadge({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spacing8,
        vertical: AppDimensions.spacing4,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: AppDimensions.spacing4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
