import '../../domain/entities/menu_category.dart';
import '../../domain/entities/menu_item.dart';
import '../../domain/repositories/menu_repository.dart';
import '../datasources/menu_remote_datasource.dart';

/// Implementation of [MenuRepository].
///
/// Handles menu data operations using remote data source.
class MenuRepositoryImpl implements MenuRepository {
  final MenuRemoteDataSource _remoteDataSource;

  MenuRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<MenuItem>> getMenuItems() async {
    final models = await _remoteDataSource.getMenuItems();
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<MenuItem> getMenuItemById(String id) async {
    final model = await _remoteDataSource.getMenuItemById(id);
    return model.toEntity();
  }

  @override
  Future<List<MenuCategory>> getCategories() async {
    final models = await _remoteDataSource.getCategories();
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<List<MenuItem>> getMenuItemsByCategory(String categoryId) async {
    final models = await _remoteDataSource.getMenuItemsByCategory(categoryId);
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<List<MenuItem>> searchMenuItems(String query) async {
    final models = await _remoteDataSource.searchMenuItems(query);
    return models.map((model) => model.toEntity()).toList();
  }
}
