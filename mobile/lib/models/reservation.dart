class ReservationRequest {
  final int idClient;
  final String email;
  final String telephone;
  final DateTime dateReservation;
  final int nombrePersonnes;
  final List<int> platIds;
  final String? commentaire;

  ReservationRequest({
    required this.idClient,
    required this.email,
    required this.telephone,
    required this.dateReservation,
    required this.nombrePersonnes,
    required this.platIds,
    this.commentaire,
  });

  Map<String, dynamic> toJson() {
    return {
      'idClient': idClient,
      'email': email,
      'telephone': telephone,
      'dateReservation': dateReservation.toIso8601String(),
      'nombrePersonnes': nombrePersonnes,
      'platIds': platIds,
      'commentaire': commentaire,
    };
  }
}

class ReservationResponse {
  final int id;
  final int idClient;
  final String email;
  final String telephone;
  final DateTime dateReservation;
  final int nombrePersonnes;
  final String statut;
  final String? commentaire;

  ReservationResponse({
    required this.id,
    required this.idClient,
    required this.email,
    required this.telephone,
    required this.dateReservation,
    required this.nombrePersonnes,
    required this.statut,
    this.commentaire,
  });

  factory ReservationResponse.fromJson(Map<String, dynamic> json) {
    return ReservationResponse(
      id: json['id'],
      idClient: json['idClient'],
      email: json['email'],
      telephone: json['telephone'],
      dateReservation: DateTime.parse(json['dateReservation']),
      nombrePersonnes: json['nombrePersonnes'],
      statut: json['statut'],
      commentaire: json['commentaire'],
    );
  }
}
