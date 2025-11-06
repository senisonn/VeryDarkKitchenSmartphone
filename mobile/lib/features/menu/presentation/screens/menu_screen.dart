import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_dimensions.dart';
import '../widgets/category_filter_chip.dart';
import '../widgets/menu_item_card.dart';

/// Menu screen displaying all menu items with category filters.
class MenuScreen extends ConsumerWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => Scaffold(
      appBar: AppBar(
        title: const Text('Menu'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Implement search
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Category filters (placeholder for now)
          Container(
            height: 60,
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.spacing16,
            ),
            child: const Center(
              child: Text('Category filters will appear here'),
            ),
          ),

          // Menu items grid (placeholder for now)
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.restaurant_menu,
                    size: 64,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: AppDimensions.spacing16),
                  Text(
                    'Menu items will be displayed here',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: AppDimensions.spacing8),
                  const Text('Connect to API to load menu items'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
}
