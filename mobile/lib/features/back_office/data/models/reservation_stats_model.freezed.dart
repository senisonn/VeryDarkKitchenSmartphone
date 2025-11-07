// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reservation_stats_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ReservationStatsModel _$ReservationStatsModelFromJson(
    Map<String, dynamic> json) {
  return _ReservationStatsModel.fromJson(json);
}

/// @nodoc
mixin _$ReservationStatsModel {
  int get totalReservations => throw _privateConstructorUsedError;
  int get pendingReservations => throw _privateConstructorUsedError;
  int get confirmedReservations => throw _privateConstructorUsedError;
  int get canceledReservations => throw _privateConstructorUsedError;
  int get completedReservations => throw _privateConstructorUsedError;
  Map<String, int> get reservationsByDate => throw _privateConstructorUsedError;

  /// Serializes this ReservationStatsModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ReservationStatsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReservationStatsModelCopyWith<ReservationStatsModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReservationStatsModelCopyWith<$Res> {
  factory $ReservationStatsModelCopyWith(ReservationStatsModel value,
          $Res Function(ReservationStatsModel) then) =
      _$ReservationStatsModelCopyWithImpl<$Res, ReservationStatsModel>;
  @useResult
  $Res call(
      {int totalReservations,
      int pendingReservations,
      int confirmedReservations,
      int canceledReservations,
      int completedReservations,
      Map<String, int> reservationsByDate});
}

/// @nodoc
class _$ReservationStatsModelCopyWithImpl<$Res,
        $Val extends ReservationStatsModel>
    implements $ReservationStatsModelCopyWith<$Res> {
  _$ReservationStatsModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ReservationStatsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalReservations = null,
    Object? pendingReservations = null,
    Object? confirmedReservations = null,
    Object? canceledReservations = null,
    Object? completedReservations = null,
    Object? reservationsByDate = null,
  }) {
    return _then(_value.copyWith(
      totalReservations: null == totalReservations
          ? _value.totalReservations
          : totalReservations // ignore: cast_nullable_to_non_nullable
              as int,
      pendingReservations: null == pendingReservations
          ? _value.pendingReservations
          : pendingReservations // ignore: cast_nullable_to_non_nullable
              as int,
      confirmedReservations: null == confirmedReservations
          ? _value.confirmedReservations
          : confirmedReservations // ignore: cast_nullable_to_non_nullable
              as int,
      canceledReservations: null == canceledReservations
          ? _value.canceledReservations
          : canceledReservations // ignore: cast_nullable_to_non_nullable
              as int,
      completedReservations: null == completedReservations
          ? _value.completedReservations
          : completedReservations // ignore: cast_nullable_to_non_nullable
              as int,
      reservationsByDate: null == reservationsByDate
          ? _value.reservationsByDate
          : reservationsByDate // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ReservationStatsModelImplCopyWith<$Res>
    implements $ReservationStatsModelCopyWith<$Res> {
  factory _$$ReservationStatsModelImplCopyWith(
          _$ReservationStatsModelImpl value,
          $Res Function(_$ReservationStatsModelImpl) then) =
      __$$ReservationStatsModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int totalReservations,
      int pendingReservations,
      int confirmedReservations,
      int canceledReservations,
      int completedReservations,
      Map<String, int> reservationsByDate});
}

/// @nodoc
class __$$ReservationStatsModelImplCopyWithImpl<$Res>
    extends _$ReservationStatsModelCopyWithImpl<$Res,
        _$ReservationStatsModelImpl>
    implements _$$ReservationStatsModelImplCopyWith<$Res> {
  __$$ReservationStatsModelImplCopyWithImpl(_$ReservationStatsModelImpl _value,
      $Res Function(_$ReservationStatsModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of ReservationStatsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalReservations = null,
    Object? pendingReservations = null,
    Object? confirmedReservations = null,
    Object? canceledReservations = null,
    Object? completedReservations = null,
    Object? reservationsByDate = null,
  }) {
    return _then(_$ReservationStatsModelImpl(
      totalReservations: null == totalReservations
          ? _value.totalReservations
          : totalReservations // ignore: cast_nullable_to_non_nullable
              as int,
      pendingReservations: null == pendingReservations
          ? _value.pendingReservations
          : pendingReservations // ignore: cast_nullable_to_non_nullable
              as int,
      confirmedReservations: null == confirmedReservations
          ? _value.confirmedReservations
          : confirmedReservations // ignore: cast_nullable_to_non_nullable
              as int,
      canceledReservations: null == canceledReservations
          ? _value.canceledReservations
          : canceledReservations // ignore: cast_nullable_to_non_nullable
              as int,
      completedReservations: null == completedReservations
          ? _value.completedReservations
          : completedReservations // ignore: cast_nullable_to_non_nullable
              as int,
      reservationsByDate: null == reservationsByDate
          ? _value._reservationsByDate
          : reservationsByDate // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ReservationStatsModelImpl extends _ReservationStatsModel {
  const _$ReservationStatsModelImpl(
      {required this.totalReservations,
      required this.pendingReservations,
      required this.confirmedReservations,
      required this.canceledReservations,
      required this.completedReservations,
      required final Map<String, int> reservationsByDate})
      : _reservationsByDate = reservationsByDate,
        super._();

  factory _$ReservationStatsModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReservationStatsModelImplFromJson(json);

  @override
  final int totalReservations;
  @override
  final int pendingReservations;
  @override
  final int confirmedReservations;
  @override
  final int canceledReservations;
  @override
  final int completedReservations;
  final Map<String, int> _reservationsByDate;
  @override
  Map<String, int> get reservationsByDate {
    if (_reservationsByDate is EqualUnmodifiableMapView)
      return _reservationsByDate;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_reservationsByDate);
  }

  @override
  String toString() {
    return 'ReservationStatsModel(totalReservations: $totalReservations, pendingReservations: $pendingReservations, confirmedReservations: $confirmedReservations, canceledReservations: $canceledReservations, completedReservations: $completedReservations, reservationsByDate: $reservationsByDate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReservationStatsModelImpl &&
            (identical(other.totalReservations, totalReservations) ||
                other.totalReservations == totalReservations) &&
            (identical(other.pendingReservations, pendingReservations) ||
                other.pendingReservations == pendingReservations) &&
            (identical(other.confirmedReservations, confirmedReservations) ||
                other.confirmedReservations == confirmedReservations) &&
            (identical(other.canceledReservations, canceledReservations) ||
                other.canceledReservations == canceledReservations) &&
            (identical(other.completedReservations, completedReservations) ||
                other.completedReservations == completedReservations) &&
            const DeepCollectionEquality()
                .equals(other._reservationsByDate, _reservationsByDate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      totalReservations,
      pendingReservations,
      confirmedReservations,
      canceledReservations,
      completedReservations,
      const DeepCollectionEquality().hash(_reservationsByDate));

  /// Create a copy of ReservationStatsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReservationStatsModelImplCopyWith<_$ReservationStatsModelImpl>
      get copyWith => __$$ReservationStatsModelImplCopyWithImpl<
          _$ReservationStatsModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReservationStatsModelImplToJson(
      this,
    );
  }
}

abstract class _ReservationStatsModel extends ReservationStatsModel {
  const factory _ReservationStatsModel(
          {required final int totalReservations,
          required final int pendingReservations,
          required final int confirmedReservations,
          required final int canceledReservations,
          required final int completedReservations,
          required final Map<String, int> reservationsByDate}) =
      _$ReservationStatsModelImpl;
  const _ReservationStatsModel._() : super._();

  factory _ReservationStatsModel.fromJson(Map<String, dynamic> json) =
      _$ReservationStatsModelImpl.fromJson;

  @override
  int get totalReservations;
  @override
  int get pendingReservations;
  @override
  int get confirmedReservations;
  @override
  int get canceledReservations;
  @override
  int get completedReservations;
  @override
  Map<String, int> get reservationsByDate;

  /// Create a copy of ReservationStatsModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReservationStatsModelImplCopyWith<_$ReservationStatsModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
