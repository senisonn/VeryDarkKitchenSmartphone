import 'package:flutter/material.dart';

import '../../../../core/theme/app_dimensions.dart';
import '../../domain/entities/menu_category.dart';

/// Filter chip widget for menu categories.
class CategoryFilterChip extends StatelessWidget {
  final MenuCategory? category;
  final bool isSelected;
  final VoidCallback onSelected;
  final bool isAllCategory;

  const CategoryFilterChip({
    super.key,
    this.category,
    required this.isSelected,
    required this.onSelected,
    this.isAllCategory = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final label = isAllCategory ? 'All' : category?.name ?? '';

    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onSelected(),
      selectedColor: colorScheme.primaryContainer,
      backgroundColor: colorScheme.surface,
      side: BorderSide(
        color: isSelected
            ? colorScheme.primary
            : colorScheme.outlineVariant,
      ),
      labelStyle: theme.textTheme.labelLarge?.copyWith(
        color: isSelected
            ? colorScheme.onPrimaryContainer
            : colorScheme.onSurface,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spacing12,
        vertical: AppDimensions.spacing8,
      ),
      showCheckmark: false,
    );
  }
}
