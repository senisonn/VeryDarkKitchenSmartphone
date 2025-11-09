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
      if (commentaire != null && commentaire!.isNotEmpty)
        'commentaire': commentaire,
    };
  }
}

class ReservationResponse {
  final int id;
  final int? userId;  // Changed from idClient and made nullable
  final String email;
  final String telephone;
  final DateTime dateReservation;
  final int nombrePersonnes;
  final String statut;
  final String? commentaire;
  final DateTime? dateCreation;  // Added field
  final List<dynamic>? plats;    // Added field for dishes

  ReservationResponse({
    required this.id,
    this.userId,  // Made optional
    required this.email,
    required this.telephone,
    required this.dateReservation,
    required this.nombrePersonnes,
    required this.statut,
    this.commentaire,
    this.dateCreation,
    this.plats,
  });

  // Backward compatibility getter
  int? get idClient => userId;

  factory ReservationResponse.fromJson(Map<String, dynamic> json) {
    return ReservationResponse(
      id: json['id'],
      userId: json['userId'] ?? json['idClient'],  // Support both field names
      email: json['email'],
      telephone: json['telephone'],
      dateReservation: DateTime.parse(json['dateReservation']),
      nombrePersonnes: json['nombrePersonnes'],
      statut: json['statut'],
      commentaire: json['commentaire'],
      dateCreation: json['dateCreation'] != null
          ? DateTime.parse(json['dateCreation'])
          : null,
      plats: json['plats'] as List<dynamic>?,
    );
  }
}

class UpdateReservationRequest {
  final String? email;
  final String? telephone;
  final DateTime? dateReservation;
  final int? nombrePersonnes;
  final List<int>? platIds;
  final String? commentaire;

  UpdateReservationRequest({
    this.email,
    this.telephone,
    this.dateReservation,
    this.nombrePersonnes,
    this.platIds,
    this.commentaire,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (email != null) data['email'] = email;
    if (telephone != null) data['telephone'] = telephone;
    if (dateReservation != null) {
      data['dateReservation'] = dateReservation!.toIso8601String();
    }
    if (nombrePersonnes != null) data['nombrePersonnes'] = nombrePersonnes;
    if (platIds != null) data['platIds'] = platIds;
    if (commentaire != null) data['commentaire'] = commentaire;
    return data;
  }
}

class AvailabilityRequest {
  final DateTime dateReservation;
  final int nombrePersonnes;

  AvailabilityRequest({
    required this.dateReservation,
    required this.nombrePersonnes,
  });

  Map<String, dynamic> toJson() {
    return {
      'dateReservation': dateReservation.toIso8601String(),
      'nombrePersonnes': nombrePersonnes,
    };
  }
}

class AvailabilityResponse {
  final DateTime dateReservation;
  final int totalCapacity;
  final int reservedSeats;
  final int availableSeats;
  final bool available;

  AvailabilityResponse({
    required this.dateReservation,
    required this.totalCapacity,
    required this.reservedSeats,
    required this.availableSeats,
    required this.available,
  });

  factory AvailabilityResponse.fromJson(Map<String, dynamic> json) {
    return AvailabilityResponse(
      dateReservation: DateTime.parse(json['dateReservation']),
      totalCapacity: json['totalCapacity'],
      reservedSeats: json['reservedSeats'],
      availableSeats: json['availableSeats'],
      available: json['available'],
    );
  }
}
