import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/network/api_client_provider.dart';
import '../../data/datasources/menu_remote_datasource.dart';
import '../../data/repositories/menu_repository_impl.dart';
import '../../domain/entities/menu_category.dart';
import '../../domain/entities/menu_item.dart';
import '../../domain/repositories/menu_repository.dart';

part 'menu_providers.g.dart';

// =============================================================================
// Data Sources
// =============================================================================

@riverpod
MenuRemoteDataSource menuRemoteDataSource(MenuRemoteDataSourceRef ref) {
  return MenuRemoteDataSource(ref.watch(apiClientProvider));
}

// =============================================================================
// Repositories
// =============================================================================

@riverpod
MenuRepository menuRepository(MenuRepositoryRef ref) {
  return MenuRepositoryImpl(ref.watch(menuRemoteDataSourceProvider));
}

// =============================================================================
// Menu Items Providers
// =============================================================================

/// Provides all menu items.
@riverpod
Future<List<MenuItem>> menuItems(MenuItemsRef ref) async {
  final repository = ref.watch(menuRepositoryProvider);
  return repository.getMenuItems();
}

/// Provides a specific menu item by ID.
@riverpod
Future<MenuItem> menuItem(MenuItemRef ref, String id) async {
  final repository = ref.watch(menuRepositoryProvider);
  return repository.getMenuItemById(id);
}

/// Provides menu items filtered by category.
@riverpod
Future<List<MenuItem>> menuItemsByCategory(
  MenuItemsByCategoryRef ref,
  String? categoryId,
) async {
  final repository = ref.watch(menuRepositoryProvider);

  if (categoryId == null || categoryId.isEmpty) {
    return repository.getMenuItems();
  }

  return repository.getMenuItemsByCategory(categoryId);
}

/// Provides search results for menu items.
@riverpod
Future<List<MenuItem>> searchMenuItems(
  SearchMenuItemsRef ref,
  String query,
) async {
  if (query.trim().isEmpty) {
    return [];
  }

  final repository = ref.watch(menuRepositoryProvider);
  return repository.searchMenuItems(query);
}

// =============================================================================
// Category Providers
// =============================================================================

/// Provides all menu categories.
@riverpod
Future<List<MenuCategory>> menuCategories(MenuCategoriesRef ref) async {
  final repository = ref.watch(menuRepositoryProvider);
  return repository.getCategories();
}

/// Provides the currently selected category ID.
///
/// Returns null if "All" is selected.
@riverpod
class SelectedCategory extends _$SelectedCategory {
  @override
  String? build() => null;

  void select(String? categoryId) {
    state = categoryId;
  }

  void clear() {
    state = null;
  }
}

/// Provides filtered menu items based on selected category.
@riverpod
Future<List<MenuItem>> filteredMenuItems(FilteredMenuItemsRef ref) async {
  final selectedCategoryId = ref.watch(selectedCategoryProvider);
  final repository = ref.watch(menuRepositoryProvider);

  // If no category selected, return all items
  if (selectedCategoryId == null) {
    return repository.getMenuItems();
  }

  return repository.getMenuItemsByCategory(selectedCategoryId);
}

// =============================================================================
// UI State Providers
// =============================================================================

/// Provides the current search query.
@riverpod
class SearchQuery extends _$SearchQuery {
  @override
  String build() => '';

  void update(String query) {
    state = query;
  }

  void clear() {
    state = '';
  }
}

/// Provides search results or filtered items based on search state.
@riverpod
Future<List<MenuItem>> displayedMenuItems(DisplayedMenuItemsRef ref) async {
  final searchQuery = ref.watch(searchQueryProvider);
  final repository = ref.watch(menuRepositoryProvider);

  if (searchQuery.trim().isNotEmpty) {
    return repository.searchMenuItems(searchQuery);
  }

  final selectedCategoryId = ref.watch(selectedCategoryProvider);

  // If no category selected, return all items
  if (selectedCategoryId == null) {
    return repository.getMenuItems();
  }

  return repository.getMenuItemsByCategory(selectedCategoryId);
}

// =============================================================================
// Helper Providers
// =============================================================================

/// Provides available menu items count.
@riverpod
Future<int> availableItemsCount(AvailableItemsCountRef ref) async {
  final items = await ref.watch(filteredMenuItemsProvider.future);
  return items.where((item) => item.isAvailable).length;
}

/// Provides dietary filter options.
@riverpod
class DietaryFilters extends _$DietaryFilters {
  @override
  Set<DietaryFilter> build() => {};

  void toggle(DietaryFilter filter) {
    if (state.contains(filter)) {
      state = {...state}..remove(filter);
    } else {
      state = {...state, filter};
    }
  }

  void clear() {
    state = {};
  }
}

enum DietaryFilter {
  vegetarian,
  vegan,
  glutenFree,
}

/// Provides menu items with dietary filters applied.
@riverpod
Future<List<MenuItem>> filteredMenuItemsWithDietary(
  FilteredMenuItemsWithDietaryRef ref,
) async {
  final items = await ref.watch(displayedMenuItemsProvider.future);
  final filters = ref.watch(dietaryFiltersProvider);

  if (filters.isEmpty) return items;

  return items.where((item) {
    if (filters.contains(DietaryFilter.vegetarian) && !item.isVegetarian) {
      return false;
    }
    if (filters.contains(DietaryFilter.vegan) && !item.isVegan) {
      return false;
    }
    if (filters.contains(DietaryFilter.glutenFree) && !item.isGlutenFree) {
      return false;
    }
    return true;
  }).toList();
}
