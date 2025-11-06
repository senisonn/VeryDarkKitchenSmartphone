import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/menu_category.dart';

part 'menu_category_model.g.dart';

/// Menu category model for data layer.
///
/// Handles JSON serialization/deserialization.
@JsonSerializable()
class MenuCategoryModel extends MenuCategory {
  const MenuCategoryModel({
    required super.id,
    required super.name,
    required super.description,
    required super.displayOrder,
    required super.isActive,
  });

  factory MenuCategoryModel.fromJson(Map<String, dynamic> json) =>
      _$MenuCategoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$MenuCategoryModelToJson(this);

  /// Converts model to domain entity.
  MenuCategory toEntity() => MenuCategory(
        id: id,
        name: name,
        description: description,
        displayOrder: displayOrder,
        isActive: isActive,
      );

  /// Creates model from domain entity.
  factory MenuCategoryModel.fromEntity(MenuCategory entity) =>
      MenuCategoryModel(
        id: entity.id,
        name: entity.name,
        description: entity.description,
        displayOrder: entity.displayOrder,
        isActive: entity.isActive,
      );
}
