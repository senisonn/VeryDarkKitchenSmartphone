class Plat {
  final int id;
  final String nom;
  final String description;
  final double prix;
  final String categorie;
  final String? imageUrl;
  final bool disponible;

  Plat({
    required this.id,
    required this.nom,
    required this.description,
    required this.prix,
    required this.categorie,
    this.imageUrl,
    required this.disponible,
  });

  factory Plat.fromJson(Map<String, dynamic> json) {
    return Plat(
      id: json['id'],
      nom: json['nom'],
      description: json['description'],
      prix: (json['prix'] as num).toDouble(),
      categorie: json['categorie'],
      imageUrl: json['imageUrl'],
      disponible: json['disponible'] ?? true,
    );
  }
}
