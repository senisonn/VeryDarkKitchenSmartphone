import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/network/api_client_provider.dart';
import '../../../reservations/domain/entities/reservation.dart';
import '../../data/datasources/admin_remote_datasource.dart';
import '../../data/repositories/admin_repository_impl.dart';
import '../../domain/repositories/admin_repository.dart';

part 'admin_providers.g.dart';

// =============================================================================
// Data Sources
// =============================================================================

@riverpod
AdminRemoteDataSource adminRemoteDataSource(AdminRemoteDataSourceRef ref) {
  return AdminRemoteDataSource(ref.watch(apiClientProvider).dio);
}

// =============================================================================
// Repositories
// =============================================================================

@riverpod
AdminRepository adminRepository(AdminRepositoryRef ref) {
  return AdminRepositoryImpl(
    ref.watch(adminRemoteDataSourceProvider),
  );
}

// =============================================================================
// Reservation Providers
// =============================================================================

/// Provides all reservations for admin view with optional filters.
@riverpod
class AllReservations extends _$AllReservations {
  @override
  Future<List<Reservation>> build({
    DateTime? filterDate,
    ReservationStatus? filterStatus,
  }) async {
    final repository = ref.watch(adminRepositoryProvider);
    return repository.getAllReservations(
      date: filterDate,
      status: filterStatus,
    );
  }

  /// Refresh the reservations list.
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(adminRepositoryProvider);
      return repository.getAllReservations(
        date: filterDate,
        status: filterStatus,
      );
    });
  }
}

// =============================================================================
// Statistics Providers
// =============================================================================

/// Provides reservation statistics for the dashboard.
@riverpod
Future<ReservationStats> reservationStats(
  ReservationStatsRef ref, {
  DateTime? startDate,
  DateTime? endDate,
}) async {
  final repository = ref.watch(adminRepositoryProvider);
  return repository.getReservationStats(
    startDate: startDate,
    endDate: endDate,
  );
}

// =============================================================================
// Filter State Providers
// =============================================================================

/// Provides the currently selected date filter.
@riverpod
class DateFilter extends _$DateFilter {
  @override
  DateTime? build() => null;

  void select(DateTime? date) {
    state = date;
  }

  void clear() {
    state = null;
  }
}

/// Provides the currently selected status filter.
@riverpod
class StatusFilter extends _$StatusFilter {
  @override
  ReservationStatus? build() => null;

  void select(ReservationStatus? status) {
    state = status;
  }

  void clear() {
    state = null;
  }
}

// =============================================================================
// Validation Actions
// =============================================================================

/// Provider for validating (confirming) a reservation.
@riverpod
class ValidateReservation extends _$ValidateReservation {
  @override
  FutureOr<Reservation?> build() => null;

  Future<void> validate(String reservationId) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final repository = ref.read(adminRepositoryProvider);
      final reservation = await repository.validateReservation(reservationId);

      // Refresh the reservations list
      ref.invalidate(allReservationsProvider);

      return reservation;
    });
  }
}

/// Provider for refusing (rejecting) a reservation.
@riverpod
class RefuseReservation extends _$RefuseReservation {
  @override
  FutureOr<Reservation?> build() => null;

  Future<void> refuse(String reservationId, {String? reason}) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final repository = ref.read(adminRepositoryProvider);
      final reservation = await repository.refuseReservation(
        reservationId,
        reason: reason,
      );

      // Refresh the reservations list
      ref.invalidate(allReservationsProvider);

      return reservation;
    });
  }
}
