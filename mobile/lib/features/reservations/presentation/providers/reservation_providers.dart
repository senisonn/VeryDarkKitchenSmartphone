import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/network/api_client_provider.dart';
import '../../data/datasources/reservation_remote_datasource.dart';
import '../../data/repositories/reservation_repository_impl.dart';
import '../../domain/entities/reservation.dart';
import '../../domain/entities/time_slot.dart';
import '../../domain/repositories/reservation_repository.dart';

part 'reservation_providers.g.dart';

// =============================================================================
// Data Sources
// =============================================================================

@riverpod
ReservationRemoteDataSource reservationRemoteDataSource(
  ReservationRemoteDataSourceRef ref,
) {
  return ReservationRemoteDataSource(ref.watch(apiClientProvider));
}

// =============================================================================
// Repositories
// =============================================================================

@riverpod
ReservationRepository reservationRepository(ReservationRepositoryRef ref) {
  return ReservationRepositoryImpl(
    ref.watch(reservationRemoteDataSourceProvider),
  );
}

// =============================================================================
// Reservation Providers
// =============================================================================

/// Provides user's reservations list with auto-refresh capability.
@riverpod
class UserReservations extends _$UserReservations {
  @override
  Future<List<Reservation>> build({String? userId}) async {
    final repository = ref.watch(reservationRepositoryProvider);
    return repository.getUserReservations(userId: userId);
  }

  /// Refresh the reservations list.
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(reservationRepositoryProvider);
      return repository.getUserReservations(userId: null);
    });
  }
}

/// Provides a single reservation by ID.
@riverpod
Future<Reservation> reservation(ReservationRef ref, String id) async {
  final repository = ref.watch(reservationRepositoryProvider);
  return repository.getReservationById(id);
}

// =============================================================================
// Time Slot Providers
// =============================================================================

/// Provides available time slots for a given date.
@riverpod
Future<List<TimeSlot>> availableTimeSlots(
  AvailableTimeSlotsRef ref,
  DateTime date,
) async {
  final repository = ref.watch(reservationRepositoryProvider);
  return repository.getAvailableTimeSlots(date);
}

/// Provides the currently selected date for slot viewing.
@riverpod
class SelectedDate extends _$SelectedDate {
  @override
  DateTime? build() => null;

  void select(DateTime date) {
    state = date;
  }

  void clear() {
    state = null;
  }
}

/// Provides the currently selected time slot.
@riverpod
class SelectedTimeSlot extends _$SelectedTimeSlot {
  @override
  TimeSlot? build() => null;

  void select(TimeSlot slot) {
    state = slot;
  }

  void clear() {
    state = null;
  }
}

// =============================================================================
// Reservation Form Providers
// =============================================================================

/// Provides guest count state.
@riverpod
class GuestCount extends _$GuestCount {
  @override
  int build() => 2; // Default to 2 guests

  void set(int count) {
    if (count > 0 && count <= 20) {
      // Max 20 guests
      state = count;
    }
  }

  void increment() {
    if (state < 20) {
      state++;
    }
  }

  void decrement() {
    if (state > 1) {
      state--;
    }
  }
}

/// Provides guest name state.
@riverpod
class GuestName extends _$GuestName {
  @override
  String build() => '';

  void update(String name) {
    state = name;
  }
}

/// Provides guest phone state.
@riverpod
class GuestPhone extends _$GuestPhone {
  @override
  String build() => '';

  void update(String phone) {
    state = phone;
  }
}

/// Provides guest email state.
@riverpod
class GuestEmail extends _$GuestEmail {
  @override
  String build() => '';

  void update(String email) {
    state = email;
  }
}

/// Provides reservation notes state.
@riverpod
class ReservationNotes extends _$ReservationNotes {
  @override
  String build() => '';

  void update(String notes) {
    state = notes;
  }
}

// =============================================================================
// Reservation Creation Provider
// =============================================================================

/// Provides reservation creation state and actions.
@riverpod
class CreateReservation extends _$CreateReservation {
  @override
  FutureOr<Reservation?> build() => null;

  /// Create a new reservation with current form state.
  Future<void> create() async {
    state = const AsyncValue.loading();

    final selectedDate = ref.read(selectedDateProvider);
    final selectedSlot = ref.read(selectedTimeSlotProvider);
    final guests = ref.read(guestCountProvider);
    final name = ref.read(guestNameProvider);
    final phone = ref.read(guestPhoneProvider);
    final email = ref.read(guestEmailProvider);
    final notes = ref.read(reservationNotesProvider);

    if (selectedDate == null || selectedSlot == null) {
      state = AsyncValue.error(
        'Please select a date and time slot',
        StackTrace.current,
      );
      return;
    }

    state = await AsyncValue.guard(() async {
      final repository = ref.read(reservationRepositoryProvider);

      final request = {
        'date': selectedDate.toIso8601String(),
        'timeSlotId': selectedSlot.id,
        'guests': guests,
        if (name.isNotEmpty) 'name': name,
        if (phone.isNotEmpty) 'phone': phone,
        if (email.isNotEmpty) 'email': email,
        if (notes.isNotEmpty) 'notes': notes,
      };

      final reservation = await repository.createReservation(request);

      // Refresh user reservations list
      ref.invalidate(userReservationsProvider);

      return reservation;
    });
  }

  /// Reset form state.
  void reset() {
    ref.read(selectedDateProvider.notifier).clear();
    ref.read(selectedTimeSlotProvider.notifier).clear();
    ref.read(guestCountProvider.notifier).set(2);
    ref.read(guestNameProvider.notifier).update('');
    ref.read(guestPhoneProvider.notifier).update('');
    ref.read(guestEmailProvider.notifier).update('');
    ref.read(reservationNotesProvider.notifier).update('');
    state = const AsyncValue.data(null);
  }
}

// =============================================================================
// Reservation Update/Cancel Providers
// =============================================================================

/// Cancel a reservation.
@riverpod
class CancelReservation extends _$CancelReservation {
  @override
  FutureOr<void> build() => null;

  Future<void> cancel(String reservationId) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final repository = ref.read(reservationRepositoryProvider);
      await repository.cancelReservation(reservationId);

      // Refresh user reservations list
      ref.invalidate(userReservationsProvider);
    });
  }
}
