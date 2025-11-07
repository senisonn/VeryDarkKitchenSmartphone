import '../entities/reservation.dart';
import '../entities/time_slot.dart';

abstract class ReservationRepository {
  /// Returns reservations for the current user (or userId if provided).
  Future<List<Reservation>> getUserReservations({String? userId});

  /// Get a reservation by id.
  Future<Reservation> getReservationById(String id);

  /// Create a new reservation.
  Future<Reservation> createReservation(Map<String, dynamic> createRequest);

  /// Update an existing reservation.
  Future<Reservation> updateReservation(String id, Map<String, dynamic> updateRequest);

  /// Cancel a reservation.
  Future<void> cancelReservation(String id);

  /// Get available time slots for a given date.
  Future<List<TimeSlot>> getAvailableTimeSlots(DateTime date);
}
