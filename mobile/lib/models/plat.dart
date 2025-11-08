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
    // Handle prix as either String or num (FastAPI returns String, Spring Boot returns num)
    double parsePrix(dynamic prix) {
      if (prix is String) {
        return double.parse(prix);
      } else if (prix is num) {
        return prix.toDouble();
      }
      return 0.0;
    }

    return Plat(
      id: json['id'],
      nom: json['nom'],
      description: json['description'],
      prix: parsePrix(json['prix']),
      categorie: json['categorie'],
      imageUrl: json['imageUrl'],
      disponible: json['disponible'] ?? true,
    );
  }
}
