import '../../../reservations/domain/entities/reservation.dart';

/// Repository for admin/back office operations.
abstract class AdminRepository {
  /// Get all reservations (admin view) with optional filters.
  Future<List<Reservation>> getAllReservations({
    DateTime? date,
    ReservationStatus? status,
  });

  /// Get reservation statistics for dashboard.
  Future<ReservationStats> getReservationStats({
    DateTime? startDate,
    DateTime? endDate,
  });

  /// Validate (confirm) a reservation.
  Future<Reservation> validateReservation(String reservationId);

  /// Refuse (reject) a reservation.
  Future<Reservation> refuseReservation(String reservationId, {String? reason});

  /// Get reservations for a specific date.
  Future<List<Reservation>> getReservationsByDate(DateTime date);
}

/// Statistics data for admin dashboard.
class ReservationStats {
  final int totalReservations;
  final int pendingReservations;
  final int confirmedReservations;
  final int canceledReservations;
  final int completedReservations;
  final Map<String, int> reservationsByDate;

  const ReservationStats({
    required this.totalReservations,
    required this.pendingReservations,
    required this.confirmedReservations,
    required this.canceledReservations,
    required this.completedReservations,
    required this.reservationsByDate,
  });
}
