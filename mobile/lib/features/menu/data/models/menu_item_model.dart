import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/menu_item.dart';

part 'menu_item_model.g.dart';

/// Menu item model for data layer.
///
/// Handles JSON serialization/deserialization.
@JsonSerializable()
class MenuItemModel extends MenuItem {
  const MenuItemModel({
    required super.id,
    required super.name,
    required super.description,
    required super.price,
    super.imageUrl,
    required super.categoryId,
    required super.isAvailable,
    super.isVegetarian = false,
    super.isVegan = false,
    super.isGlutenFree = false,
    super.allergens = const [],
    required super.preparationTime,
    required super.createdAt,
    required super.updatedAt,
  });

  factory MenuItemModel.fromJson(Map<String, dynamic> json) =>
      _$MenuItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$MenuItemModelToJson(this);

  /// Converts model to domain entity.
  MenuItem toEntity() => MenuItem(
        id: id,
        name: name,
        description: description,
        price: price,
        imageUrl: imageUrl,
        categoryId: categoryId,
        isAvailable: isAvailable,
        isVegetarian: isVegetarian,
        isVegan: isVegan,
        isGlutenFree: isGlutenFree,
        allergens: allergens,
        preparationTime: preparationTime,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

  /// Creates model from domain entity.
  factory MenuItemModel.fromEntity(MenuItem entity) => MenuItemModel(
        id: entity.id,
        name: entity.name,
        description: entity.description,
        price: entity.price,
        imageUrl: entity.imageUrl,
        categoryId: entity.categoryId,
        isAvailable: entity.isAvailable,
        isVegetarian: entity.isVegetarian,
        isVegan: entity.isVegan,
        isGlutenFree: entity.isGlutenFree,
        allergens: entity.allergens,
        preparationTime: entity.preparationTime,
        createdAt: entity.createdAt,
        updatedAt: entity.updatedAt,
      );
}
