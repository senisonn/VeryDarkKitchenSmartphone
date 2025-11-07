// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$adminRemoteDataSourceHash() =>
    r'21688136d73ac4b1b311ea91d5bc2ccaa78e1823';

/// See also [adminRemoteDataSource].
@ProviderFor(adminRemoteDataSource)
final adminRemoteDataSourceProvider =
    AutoDisposeProvider<AdminRemoteDataSource>.internal(
  adminRemoteDataSource,
  name: r'adminRemoteDataSourceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$adminRemoteDataSourceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AdminRemoteDataSourceRef
    = AutoDisposeProviderRef<AdminRemoteDataSource>;
String _$adminRepositoryHash() => r'766818c759b7df586f3f3f8e639cd33f72b5be41';

/// See also [adminRepository].
@ProviderFor(adminRepository)
final adminRepositoryProvider = AutoDisposeProvider<AdminRepository>.internal(
  adminRepository,
  name: r'adminRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$adminRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AdminRepositoryRef = AutoDisposeProviderRef<AdminRepository>;
String _$reservationStatsHash() => r'cdcbe1183c7cd62af00aa6a5873fa12b53286edd';

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

/// Provides reservation statistics for the dashboard.
///
/// Copied from [reservationStats].
@ProviderFor(reservationStats)
const reservationStatsProvider = ReservationStatsFamily();

/// Provides reservation statistics for the dashboard.
///
/// Copied from [reservationStats].
class ReservationStatsFamily extends Family<AsyncValue<ReservationStats>> {
  /// Provides reservation statistics for the dashboard.
  ///
  /// Copied from [reservationStats].
  const ReservationStatsFamily();

  /// Provides reservation statistics for the dashboard.
  ///
  /// Copied from [reservationStats].
  ReservationStatsProvider call({
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return ReservationStatsProvider(
      startDate: startDate,
      endDate: endDate,
    );
  }

  @override
  ReservationStatsProvider getProviderOverride(
    covariant ReservationStatsProvider provider,
  ) {
    return call(
      startDate: provider.startDate,
      endDate: provider.endDate,
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
  String? get name => r'reservationStatsProvider';
}

/// Provides reservation statistics for the dashboard.
///
/// Copied from [reservationStats].
class ReservationStatsProvider
    extends AutoDisposeFutureProvider<ReservationStats> {
  /// Provides reservation statistics for the dashboard.
  ///
  /// Copied from [reservationStats].
  ReservationStatsProvider({
    DateTime? startDate,
    DateTime? endDate,
  }) : this._internal(
          (ref) => reservationStats(
            ref as ReservationStatsRef,
            startDate: startDate,
            endDate: endDate,
          ),
          from: reservationStatsProvider,
          name: r'reservationStatsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$reservationStatsHash,
          dependencies: ReservationStatsFamily._dependencies,
          allTransitiveDependencies:
              ReservationStatsFamily._allTransitiveDependencies,
          startDate: startDate,
          endDate: endDate,
        );

  ReservationStatsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.startDate,
    required this.endDate,
  }) : super.internal();

  final DateTime? startDate;
  final DateTime? endDate;

  @override
  Override overrideWith(
    FutureOr<ReservationStats> Function(ReservationStatsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ReservationStatsProvider._internal(
        (ref) => create(ref as ReservationStatsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        startDate: startDate,
        endDate: endDate,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<ReservationStats> createElement() {
    return _ReservationStatsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ReservationStatsProvider &&
        other.startDate == startDate &&
        other.endDate == endDate;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, startDate.hashCode);
    hash = _SystemHash.combine(hash, endDate.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ReservationStatsRef on AutoDisposeFutureProviderRef<ReservationStats> {
  /// The parameter `startDate` of this provider.
  DateTime? get startDate;

  /// The parameter `endDate` of this provider.
  DateTime? get endDate;
}

class _ReservationStatsProviderElement
    extends AutoDisposeFutureProviderElement<ReservationStats>
    with ReservationStatsRef {
  _ReservationStatsProviderElement(super.provider);

  @override
  DateTime? get startDate => (origin as ReservationStatsProvider).startDate;
  @override
  DateTime? get endDate => (origin as ReservationStatsProvider).endDate;
}

String _$allReservationsHash() => r'0fe7f15cb298c41d7df2171013ec020d4cb0f8d7';

abstract class _$AllReservations
    extends BuildlessAutoDisposeAsyncNotifier<List<Reservation>> {
  late final DateTime? filterDate;
  late final ReservationStatus? filterStatus;

  FutureOr<List<Reservation>> build({
    DateTime? filterDate,
    ReservationStatus? filterStatus,
  });
}

/// Provides all reservations for admin view with optional filters.
///
/// Copied from [AllReservations].
@ProviderFor(AllReservations)
const allReservationsProvider = AllReservationsFamily();

/// Provides all reservations for admin view with optional filters.
///
/// Copied from [AllReservations].
class AllReservationsFamily extends Family<AsyncValue<List<Reservation>>> {
  /// Provides all reservations for admin view with optional filters.
  ///
  /// Copied from [AllReservations].
  const AllReservationsFamily();

  /// Provides all reservations for admin view with optional filters.
  ///
  /// Copied from [AllReservations].
  AllReservationsProvider call({
    DateTime? filterDate,
    ReservationStatus? filterStatus,
  }) {
    return AllReservationsProvider(
      filterDate: filterDate,
      filterStatus: filterStatus,
    );
  }

  @override
  AllReservationsProvider getProviderOverride(
    covariant AllReservationsProvider provider,
  ) {
    return call(
      filterDate: provider.filterDate,
      filterStatus: provider.filterStatus,
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
  String? get name => r'allReservationsProvider';
}

/// Provides all reservations for admin view with optional filters.
///
/// Copied from [AllReservations].
class AllReservationsProvider extends AutoDisposeAsyncNotifierProviderImpl<
    AllReservations, List<Reservation>> {
  /// Provides all reservations for admin view with optional filters.
  ///
  /// Copied from [AllReservations].
  AllReservationsProvider({
    DateTime? filterDate,
    ReservationStatus? filterStatus,
  }) : this._internal(
          () => AllReservations()
            ..filterDate = filterDate
            ..filterStatus = filterStatus,
          from: allReservationsProvider,
          name: r'allReservationsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$allReservationsHash,
          dependencies: AllReservationsFamily._dependencies,
          allTransitiveDependencies:
              AllReservationsFamily._allTransitiveDependencies,
          filterDate: filterDate,
          filterStatus: filterStatus,
        );

  AllReservationsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.filterDate,
    required this.filterStatus,
  }) : super.internal();

  final DateTime? filterDate;
  final ReservationStatus? filterStatus;

  @override
  FutureOr<List<Reservation>> runNotifierBuild(
    covariant AllReservations notifier,
  ) {
    return notifier.build(
      filterDate: filterDate,
      filterStatus: filterStatus,
    );
  }

  @override
  Override overrideWith(AllReservations Function() create) {
    return ProviderOverride(
      origin: this,
      override: AllReservationsProvider._internal(
        () => create()
          ..filterDate = filterDate
          ..filterStatus = filterStatus,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        filterDate: filterDate,
        filterStatus: filterStatus,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<AllReservations, List<Reservation>>
      createElement() {
    return _AllReservationsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AllReservationsProvider &&
        other.filterDate == filterDate &&
        other.filterStatus == filterStatus;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, filterDate.hashCode);
    hash = _SystemHash.combine(hash, filterStatus.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin AllReservationsRef
    on AutoDisposeAsyncNotifierProviderRef<List<Reservation>> {
  /// The parameter `filterDate` of this provider.
  DateTime? get filterDate;

  /// The parameter `filterStatus` of this provider.
  ReservationStatus? get filterStatus;
}

class _AllReservationsProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<AllReservations,
        List<Reservation>> with AllReservationsRef {
  _AllReservationsProviderElement(super.provider);

  @override
  DateTime? get filterDate => (origin as AllReservationsProvider).filterDate;
  @override
  ReservationStatus? get filterStatus =>
      (origin as AllReservationsProvider).filterStatus;
}

String _$dateFilterHash() => r'a88f13a55a408af020637949a34cb83b1890f6e3';

/// Provides the currently selected date filter.
///
/// Copied from [DateFilter].
@ProviderFor(DateFilter)
final dateFilterProvider =
    AutoDisposeNotifierProvider<DateFilter, DateTime?>.internal(
  DateFilter.new,
  name: r'dateFilterProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$dateFilterHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$DateFilter = AutoDisposeNotifier<DateTime?>;
String _$statusFilterHash() => r'cfc5836d9ae158bfce1e04aae4bc926404e56c03';

/// Provides the currently selected status filter.
///
/// Copied from [StatusFilter].
@ProviderFor(StatusFilter)
final statusFilterProvider =
    AutoDisposeNotifierProvider<StatusFilter, ReservationStatus?>.internal(
  StatusFilter.new,
  name: r'statusFilterProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$statusFilterHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$StatusFilter = AutoDisposeNotifier<ReservationStatus?>;
String _$validateReservationHash() =>
    r'0b9efa10f4d0b2e0ba30190454a52304b3fa28fe';

/// Provider for validating (confirming) a reservation.
///
/// Copied from [ValidateReservation].
@ProviderFor(ValidateReservation)
final validateReservationProvider = AutoDisposeAsyncNotifierProvider<
    ValidateReservation, Reservation?>.internal(
  ValidateReservation.new,
  name: r'validateReservationProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$validateReservationHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ValidateReservation = AutoDisposeAsyncNotifier<Reservation?>;
String _$refuseReservationHash() => r'30b943517acf6883170dafcd2f98d42470080c32';

/// Provider for refusing (rejecting) a reservation.
///
/// Copied from [RefuseReservation].
@ProviderFor(RefuseReservation)
final refuseReservationProvider =
    AutoDisposeAsyncNotifierProvider<RefuseReservation, Reservation?>.internal(
  RefuseReservation.new,
  name: r'refuseReservationProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$refuseReservationHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$RefuseReservation = AutoDisposeAsyncNotifier<Reservation?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
