import '../../../reservations/domain/entities/reservation.dart';
import '../../domain/repositories/admin_repository.dart';
import '../datasources/admin_remote_datasource.dart';

/// Implementation of [AdminRepository].
class AdminRepositoryImpl implements AdminRepository {
  final AdminRemoteDataSource _remoteDataSource;

  AdminRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<Reservation>> getAllReservations({
    DateTime? date,
    ReservationStatus? status,
  }) async {
    final models = await _remoteDataSource.getAllReservations(
      date: date,
      status: status,
    );
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<ReservationStats> getReservationStats({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final model = await _remoteDataSource.getReservationStats(
      startDate: startDate,
      endDate: endDate,
    );
    return model.toEntity();
  }

  @override
  Future<Reservation> validateReservation(String reservationId) async {
    final model = await _remoteDataSource.validateReservation(reservationId);
    return model.toEntity();
  }

  @override
  Future<Reservation> refuseReservation(
    String reservationId, {
    String? reason,
  }) async {
    final model = await _remoteDataSource.refuseReservation(
      reservationId,
      reason: reason,
    );
    return model.toEntity();
  }

  @override
  Future<List<Reservation>> getReservationsByDate(DateTime date) async {
    final models = await _remoteDataSource.getReservationsByDate(date);
    return models.map((model) => model.toEntity()).toList();
  }
}
