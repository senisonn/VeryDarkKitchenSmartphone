import '../entities/menu_category.dart';
import '../entities/menu_item.dart';

/// Abstract repository for menu operations.
///
/// Defines the contract for menu data operations.
abstract class MenuRepository {
  /// Fetches all available menu items.
  Future<List<MenuItem>> getMenuItems();

  /// Fetches a specific menu item by ID.
  Future<MenuItem> getMenuItemById(String id);

  /// Fetches all menu categories.
  Future<List<MenuCategory>> getCategories();

  /// Fetches menu items by category.
  Future<List<MenuItem>> getMenuItemsByCategory(String categoryId);

  /// Searches menu items by name or description.
  Future<List<MenuItem>> searchMenuItems(String query);
}
