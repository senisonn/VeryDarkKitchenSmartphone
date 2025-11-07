// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reservation_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$reservationRemoteDataSourceHash() =>
    r'e4da87d4c6a035acb6ea4a5384a9473e11ebcce5';

/// See also [reservationRemoteDataSource].
@ProviderFor(reservationRemoteDataSource)
final reservationRemoteDataSourceProvider =
    AutoDisposeProvider<ReservationRemoteDataSource>.internal(
  reservationRemoteDataSource,
  name: r'reservationRemoteDataSourceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$reservationRemoteDataSourceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ReservationRemoteDataSourceRef
    = AutoDisposeProviderRef<ReservationRemoteDataSource>;
String _$reservationRepositoryHash() =>
    r'58c4b16405e971a557575f4aa6bf6be58d10edb4';

/// See also [reservationRepository].
@ProviderFor(reservationRepository)
final reservationRepositoryProvider =
    AutoDisposeProvider<ReservationRepository>.internal(
  reservationRepository,
  name: r'reservationRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$reservationRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ReservationRepositoryRef
    = AutoDisposeProviderRef<ReservationRepository>;
String _$reservationHash() => r'7173d502bfc93c3a55a3f3578b3fc4e9cf860ab4';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// Provides a single reservation by ID.
///
/// Copied from [reservation].
@ProviderFor(reservation)
const reservationProvider = ReservationFamily();

/// Provides a single reservation by ID.
///
/// Copied from [reservation].
class ReservationFamily extends Family<AsyncValue<Reservation>> {
  /// Provides a single reservation by ID.
  ///
  /// Copied from [reservation].
  const ReservationFamily();

  /// Provides a single reservation by ID.
  ///
  /// Copied from [reservation].
  ReservationProvider call(
    String id,
  ) {
    return ReservationProvider(
      id,
    );
  }

  @override
  ReservationProvider getProviderOverride(
    covariant ReservationProvider provider,
  ) {
    return call(
      provider.id,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'reservationProvider';
}

/// Provides a single reservation by ID.
///
/// Copied from [reservation].
class ReservationProvider extends AutoDisposeFutureProvider<Reservation> {
  /// Provides a single reservation by ID.
  ///
  /// Copied from [reservation].
  ReservationProvider(
    String id,
  ) : this._internal(
          (ref) => reservation(
            ref as ReservationRef,
            id,
          ),
          from: reservationProvider,
          name: r'reservationProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$reservationHash,
          dependencies: ReservationFamily._dependencies,
          allTransitiveDependencies:
              ReservationFamily._allTransitiveDependencies,
          id: id,
        );

  ReservationProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final String id;

  @override
  Override overrideWith(
    FutureOr<Reservation> Function(ReservationRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ReservationProvider._internal(
        (ref) => create(ref as ReservationRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Reservation> createElement() {
    return _ReservationProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ReservationProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ReservationRef on AutoDisposeFutureProviderRef<Reservation> {
  /// The parameter `id` of this provider.
  String get id;
}

class _ReservationProviderElement
    extends AutoDisposeFutureProviderElement<Reservation> with ReservationRef {
  _ReservationProviderElement(super.provider);

  @override
  String get id => (origin as ReservationProvider).id;
}

String _$availableTimeSlotsHash() =>
    r'aa8b357d61c5d6dce0cba9014e30f67741717495';

/// Provides available time slots for a given date.
///
/// Copied from [availableTimeSlots].
@ProviderFor(availableTimeSlots)
const availableTimeSlotsProvider = AvailableTimeSlotsFamily();

/// Provides available time slots for a given date.
///
/// Copied from [availableTimeSlots].
class AvailableTimeSlotsFamily extends Family<AsyncValue<List<TimeSlot>>> {
  /// Provides available time slots for a given date.
  ///
  /// Copied from [availableTimeSlots].
  const AvailableTimeSlotsFamily();

  /// Provides available time slots for a given date.
  ///
  /// Copied from [availableTimeSlots].
  AvailableTimeSlotsProvider call(
    DateTime date,
  ) {
    return AvailableTimeSlotsProvider(
      date,
    );
  }

  @override
  AvailableTimeSlotsProvider getProviderOverride(
    covariant AvailableTimeSlotsProvider provider,
  ) {
    return call(
      provider.date,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'availableTimeSlotsProvider';
}

/// Provides available time slots for a given date.
///
/// Copied from [availableTimeSlots].
class AvailableTimeSlotsProvider
    extends AutoDisposeFutureProvider<List<TimeSlot>> {
  /// Provides available time slots for a given date.
  ///
  /// Copied from [availableTimeSlots].
  AvailableTimeSlotsProvider(
    DateTime date,
  ) : this._internal(
          (ref) => availableTimeSlots(
            ref as AvailableTimeSlotsRef,
            date,
          ),
          from: availableTimeSlotsProvider,
          name: r'availableTimeSlotsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$availableTimeSlotsHash,
          dependencies: AvailableTimeSlotsFamily._dependencies,
          allTransitiveDependencies:
              AvailableTimeSlotsFamily._allTransitiveDependencies,
          date: date,
        );

  AvailableTimeSlotsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.date,
  }) : super.internal();

  final DateTime date;

  @override
  Override overrideWith(
    FutureOr<List<TimeSlot>> Function(AvailableTimeSlotsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AvailableTimeSlotsProvider._internal(
        (ref) => create(ref as AvailableTimeSlotsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        date: date,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<TimeSlot>> createElement() {
    return _AvailableTimeSlotsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AvailableTimeSlotsProvider && other.date == date;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, date.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin AvailableTimeSlotsRef on AutoDisposeFutureProviderRef<List<TimeSlot>> {
  /// The parameter `date` of this provider.
  DateTime get date;
}

class _AvailableTimeSlotsProviderElement
    extends AutoDisposeFutureProviderElement<List<TimeSlot>>
    with AvailableTimeSlotsRef {
  _AvailableTimeSlotsProviderElement(super.provider);

  @override
  DateTime get date => (origin as AvailableTimeSlotsProvider).date;
}

String _$userReservationsHash() => r'9a31ee05fb3b11a2fd0c60cb7170c868c673e271';

abstract class _$UserReservations
    extends BuildlessAutoDisposeAsyncNotifier<List<Reservation>> {
  late final String? userId;

  FutureOr<List<Reservation>> build({
    String? userId,
  });
}

/// Provides user's reservations list with auto-refresh capability.
///
/// Copied from [UserReservations].
@ProviderFor(UserReservations)
const userReservationsProvider = UserReservationsFamily();

/// Provides user's reservations list with auto-refresh capability.
///
/// Copied from [UserReservations].
class UserReservationsFamily extends Family<AsyncValue<List<Reservation>>> {
  /// Provides user's reservations list with auto-refresh capability.
  ///
  /// Copied from [UserReservations].
  const UserReservationsFamily();

  /// Provides user's reservations list with auto-refresh capability.
  ///
  /// Copied from [UserReservations].
  UserReservationsProvider call({
    String? userId,
  }) {
    return UserReservationsProvider(
      userId: userId,
    );
  }

  @override
  UserReservationsProvider getProviderOverride(
    covariant UserReservationsProvider provider,
  ) {
    return call(
      userId: provider.userId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'userReservationsProvider';
}

/// Provides user's reservations list with auto-refresh capability.
///
/// Copied from [UserReservations].
class UserReservationsProvider extends AutoDisposeAsyncNotifierProviderImpl<
    UserReservations, List<Reservation>> {
  /// Provides user's reservations list with auto-refresh capability.
  ///
  /// Copied from [UserReservations].
  UserReservationsProvider({
    String? userId,
  }) : this._internal(
          () => UserReservations()..userId = userId,
          from: userReservationsProvider,
          name: r'userReservationsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$userReservationsHash,
          dependencies: UserReservationsFamily._dependencies,
          allTransitiveDependencies:
              UserReservationsFamily._allTransitiveDependencies,
          userId: userId,
        );

  UserReservationsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.userId,
  }) : super.internal();

  final String? userId;

  @override
  FutureOr<List<Reservation>> runNotifierBuild(
    covariant UserReservations notifier,
  ) {
    return notifier.build(
      userId: userId,
    );
  }

  @override
  Override overrideWith(UserReservations Function() create) {
    return ProviderOverride(
      origin: this,
      override: UserReservationsProvider._internal(
        () => create()..userId = userId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        userId: userId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<UserReservations, List<Reservation>>
      createElement() {
    return _UserReservationsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UserReservationsProvider && other.userId == userId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, userId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin UserReservationsRef
    on AutoDisposeAsyncNotifierProviderRef<List<Reservation>> {
  /// The parameter `userId` of this provider.
  String? get userId;
}

class _UserReservationsProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<UserReservations,
        List<Reservation>> with UserReservationsRef {
  _UserReservationsProviderElement(super.provider);

  @override
  String? get userId => (origin as UserReservationsProvider).userId;
}

String _$selectedDateHash() => r'6f11094978ba25cafc54fcf61e0a5ad630a17425';

/// Provides the currently selected date for slot viewing.
///
/// Copied from [SelectedDate].
@ProviderFor(SelectedDate)
final selectedDateProvider =
    AutoDisposeNotifierProvider<SelectedDate, DateTime?>.internal(
  SelectedDate.new,
  name: r'selectedDateProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$selectedDateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SelectedDate = AutoDisposeNotifier<DateTime?>;
String _$selectedTimeSlotHash() => r'02dbdf2ab6ecf4bf3bd15994572b69a6a9b5c91c';

/// Provides the currently selected time slot.
///
/// Copied from [SelectedTimeSlot].
@ProviderFor(SelectedTimeSlot)
final selectedTimeSlotProvider =
    AutoDisposeNotifierProvider<SelectedTimeSlot, TimeSlot?>.internal(
  SelectedTimeSlot.new,
  name: r'selectedTimeSlotProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$selectedTimeSlotHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SelectedTimeSlot = AutoDisposeNotifier<TimeSlot?>;
String _$guestCountHash() => r'eca70337fefdd7358eeb54a7d6569ce26e6a4b68';

/// Provides guest count state.
///
/// Copied from [GuestCount].
@ProviderFor(GuestCount)
final guestCountProvider =
    AutoDisposeNotifierProvider<GuestCount, int>.internal(
  GuestCount.new,
  name: r'guestCountProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$guestCountHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$GuestCount = AutoDisposeNotifier<int>;
String _$guestNameHash() => r'7b23061072c5ebd31a7436778e5761e68354aec4';

/// Provides guest name state.
///
/// Copied from [GuestName].
@ProviderFor(GuestName)
final guestNameProvider =
    AutoDisposeNotifierProvider<GuestName, String>.internal(
  GuestName.new,
  name: r'guestNameProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$guestNameHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$GuestName = AutoDisposeNotifier<String>;
String _$guestPhoneHash() => r'bfcf09f29f3cd36e496e5473a3ea26a812db9683';

/// Provides guest phone state.
///
/// Copied from [GuestPhone].
@ProviderFor(GuestPhone)
final guestPhoneProvider =
    AutoDisposeNotifierProvider<GuestPhone, String>.internal(
  GuestPhone.new,
  name: r'guestPhoneProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$guestPhoneHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$GuestPhone = AutoDisposeNotifier<String>;
String _$guestEmailHash() => r'aa09710e22bc3cc704b028ca8e9cf01a00df7af9';

/// Provides guest email state.
///
/// Copied from [GuestEmail].
@ProviderFor(GuestEmail)
final guestEmailProvider =
    AutoDisposeNotifierProvider<GuestEmail, String>.internal(
  GuestEmail.new,
  name: r'guestEmailProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$guestEmailHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$GuestEmail = AutoDisposeNotifier<String>;
String _$reservationNotesHash() => r'5b7304b23413289f03b75af658067ca3a1594817';

/// Provides reservation notes state.
///
/// Copied from [ReservationNotes].
@ProviderFor(ReservationNotes)
final reservationNotesProvider =
    AutoDisposeNotifierProvider<ReservationNotes, String>.internal(
  ReservationNotes.new,
  name: r'reservationNotesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$reservationNotesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ReservationNotes = AutoDisposeNotifier<String>;
String _$createReservationHash() => r'e5468a86aae759dd990f9e7957d07e324bb63c16';

/// Provides reservation creation state and actions.
///
/// Copied from [CreateReservation].
@ProviderFor(CreateReservation)
final createReservationProvider =
    AutoDisposeAsyncNotifierProvider<CreateReservation, Reservation?>.internal(
  CreateReservation.new,
  name: r'createReservationProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$createReservationHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CreateReservation = AutoDisposeAsyncNotifier<Reservation?>;
String _$cancelReservationHash() => r'7dcf5cbdf0115c52cc9b263aaa81d3e1e2960374';

/// Cancel a reservation.
///
/// Copied from [CancelReservation].
@ProviderFor(CancelReservation)
final cancelReservationProvider =
    AutoDisposeAsyncNotifierProvider<CancelReservation, void>.internal(
  CancelReservation.new,
  name: r'cancelReservationProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$cancelReservationHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CancelReservation = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
