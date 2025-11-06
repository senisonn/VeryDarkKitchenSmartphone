/// Menu item entity.
///
/// Represents a menu item in the domain layer.
class MenuItem {
  final String id;
  final String name;
  final String description;
  final double price;
  final String? imageUrl;
  final String categoryId;
  final bool isAvailable;
  final bool isVegetarian;
  final bool isVegan;
  final bool isGlutenFree;
  final List<String> allergens;
  final int preparationTime; // in minutes
  final DateTime createdAt;
  final DateTime updatedAt;

  const MenuItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.imageUrl,
    required this.categoryId,
    required this.isAvailable,
    this.isVegetarian = false,
    this.isVegan = false,
    this.isGlutenFree = false,
    this.allergens = const [],
    required this.preparationTime,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MenuItem && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'MenuItem(id: $id, name: $name, price: $price)';
}
