import 'package:dio/dio.dart';

import '../../../../core/network/api_client.dart';
import '../models/menu_category_model.dart';
import '../models/menu_item_model.dart';

/// Remote data source for menu operations.
///
/// Handles all menu-related API calls.
class MenuRemoteDataSource {
  final ApiClient _apiClient;

  MenuRemoteDataSource(this._apiClient);

  /// Fetches all menu items from the API.
  Future<List<MenuItemModel>> getMenuItems() async {
    try {
      final response = await _apiClient.dio.get<Map<String, dynamic>>('/menu/items');
      
      final data = response.data;
      if (data == null) return [];
      
      final List<dynamic> items = data is Map 
          ? (data['data'] as List<dynamic>?) ?? [] 
          : [];
      
      return items
          .map((json) => MenuItemModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (_) {
      rethrow;
    }
  }

  /// Fetches a specific menu item by ID.
  Future<MenuItemModel> getMenuItemById(String id) async {
    try {
      final response = await _apiClient.dio.get<Map<String, dynamic>>('/menu/items/$id');
      
      final data = response.data;
      if (data == null) throw DioException(requestOptions: response.requestOptions);
      
      final itemData = data is Map ? (data['data'] ?? data) : data;
      
      return MenuItemModel.fromJson(itemData as Map<String, dynamic>);
    } on DioException catch (_) {
      rethrow;
    }
  }

  /// Fetches all menu categories from the API.
  Future<List<MenuCategoryModel>> getCategories() async {
    try {
      final response = await _apiClient.dio.get<Map<String, dynamic>>('/menu/categories');
      
      final data = response.data;
      if (data == null) return [];
      
      final List<dynamic> categories = data is Map 
          ? (data['data'] as List<dynamic>?) ?? [] 
          : [];
      
      return categories
          .map((json) =>
              MenuCategoryModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (_) {
      rethrow;
    }
  }

  /// Fetches menu items by category ID.
  Future<List<MenuItemModel>> getMenuItemsByCategory(String categoryId) async {
    try {
      final response = await _apiClient.dio.get<Map<String, dynamic>>(
        '/menu/items',
        queryParameters: {'categoryId': categoryId},
      );
      
      final data = response.data;
      if (data == null) return [];
      
      final List<dynamic> items = data is Map 
          ? (data['data'] as List<dynamic>?) ?? [] 
          : [];
      
      return items
          .map((json) => MenuItemModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (_) {
      rethrow;
    }
  }

  /// Searches menu items by query string.
  Future<List<MenuItemModel>> searchMenuItems(String query) async {
    try {
      final response = await _apiClient.dio.get<Map<String, dynamic>>(
        '/menu/items/search',
        queryParameters: {'q': query},
      );
      
      final data = response.data;
      if (data == null) return [];
      
      final List<dynamic> items = data is Map 
          ? (data['data'] as List<dynamic>?) ?? [] 
          : [];
      
      return items
          .map((json) => MenuItemModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (_) {
      rethrow;
    }
  }
}

