// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'menu_category_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MenuCategoryModel _$MenuCategoryModelFromJson(Map<String, dynamic> json) =>
    MenuCategoryModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      displayOrder: (json['displayOrder'] as num).toInt(),
      isActive: json['isActive'] as bool,
    );

Map<String, dynamic> _$MenuCategoryModelToJson(MenuCategoryModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'displayOrder': instance.displayOrder,
      'isActive': instance.isActive,
    };
