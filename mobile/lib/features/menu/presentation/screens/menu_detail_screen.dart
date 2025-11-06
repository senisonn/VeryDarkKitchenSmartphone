import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_dimensions.dart';
import '../../domain/entities/menu_item.dart';

/// Menu item detail screen.
class MenuDetailScreen extends ConsumerWidget {
  final String itemId;

  const MenuDetailScreen({
    super.key,
    required this.itemId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: Load menu item from provider
    // final menuItemAsync = ref.watch(menuItemProvider(itemId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu Item'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.restaurant,
              size: 64,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: AppDimensions.spacing16),
            Text(
              'Menu item details for ID: $itemId',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.spacing8),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: AppDimensions.spacing24),
              child: Text(
                'Connect to API to load menu item details',
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
