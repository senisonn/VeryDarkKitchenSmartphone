import '../../domain/entities/reservation.dart';
import '../../domain/entities/time_slot.dart';
import '../../domain/repositories/reservation_repository.dart';
import '../datasources/reservation_remote_datasource.dart';

/// Implementation of [ReservationRepository].
class ReservationRepositoryImpl implements ReservationRepository {
  final ReservationRemoteDataSource _remoteDataSource;

  ReservationRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<Reservation>> getUserReservations({String? userId}) async {
    final models = await _remoteDataSource.getUserReservations(userId: userId);
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<Reservation> getReservationById(String id) async {
    final model = await _remoteDataSource.getReservationById(id);
    return model.toEntity();
  }

  @override
  Future<Reservation> createReservation(Map<String, dynamic> createRequest) async {
    final model = await _remoteDataSource.createReservation(createRequest);
    return model.toEntity();
  }

  @override
  Future<Reservation> updateReservation(
    String id,
    Map<String, dynamic> updateRequest,
  ) async {
    final model = await _remoteDataSource.updateReservation(id, updateRequest);
    return model.toEntity();
  }

  @override
  Future<void> cancelReservation(String id) async {
    await _remoteDataSource.cancelReservation(id);
  }

  @override
  Future<List<TimeSlot>> getAvailableTimeSlots(DateTime date) async {
    final models = await _remoteDataSource.getAvailableTimeSlots(date);
    return models.map((model) => model.toEntity()).toList();
  }
}
