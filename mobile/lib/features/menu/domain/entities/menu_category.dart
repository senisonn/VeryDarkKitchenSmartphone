/// Menu category entity.
///
/// Represents a menu category in the domain layer.
class MenuCategory {
  final String id;
  final String name;
  final String description;
  final int displayOrder;
  final bool isActive;

  const MenuCategory({
    required this.id,
    required this.name,
    required this.description,
    required this.displayOrder,
    required this.isActive,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MenuCategory &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'MenuCategory(id: $id, name: $name)';
}
