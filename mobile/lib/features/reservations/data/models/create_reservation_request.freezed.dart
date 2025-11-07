// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_reservation_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CreateReservationRequest _$CreateReservationRequestFromJson(
    Map<String, dynamic> json) {
  return _CreateReservationRequest.fromJson(json);
}

/// @nodoc
mixin _$CreateReservationRequest {
  DateTime get date => throw _privateConstructorUsedError;
  String get timeSlotId => throw _privateConstructorUsedError;
  int get guests => throw _privateConstructorUsedError;
  String? get name => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;

  /// Serializes this CreateReservationRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CreateReservationRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CreateReservationRequestCopyWith<CreateReservationRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateReservationRequestCopyWith<$Res> {
  factory $CreateReservationRequestCopyWith(CreateReservationRequest value,
          $Res Function(CreateReservationRequest) then) =
      _$CreateReservationRequestCopyWithImpl<$Res, CreateReservationRequest>;
  @useResult
  $Res call(
      {DateTime date,
      String timeSlotId,
      int guests,
      String? name,
      String? phone,
      String? email,
      String? notes});
}

/// @nodoc
class _$CreateReservationRequestCopyWithImpl<$Res,
        $Val extends CreateReservationRequest>
    implements $CreateReservationRequestCopyWith<$Res> {
  _$CreateReservationRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CreateReservationRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? timeSlotId = null,
    Object? guests = null,
    Object? name = freezed,
    Object? phone = freezed,
    Object? email = freezed,
    Object? notes = freezed,
  }) {
    return _then(_value.copyWith(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      timeSlotId: null == timeSlotId
          ? _value.timeSlotId
          : timeSlotId // ignore: cast_nullable_to_non_nullable
              as String,
      guests: null == guests
          ? _value.guests
          : guests // ignore: cast_nullable_to_non_nullable
              as int,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CreateReservationRequestImplCopyWith<$Res>
    implements $CreateReservationRequestCopyWith<$Res> {
  factory _$$CreateReservationRequestImplCopyWith(
          _$CreateReservationRequestImpl value,
          $Res Function(_$CreateReservationRequestImpl) then) =
      __$$CreateReservationRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {DateTime date,
      String timeSlotId,
      int guests,
      String? name,
      String? phone,
      String? email,
      String? notes});
}

/// @nodoc
class __$$CreateReservationRequestImplCopyWithImpl<$Res>
    extends _$CreateReservationRequestCopyWithImpl<$Res,
        _$CreateReservationRequestImpl>
    implements _$$CreateReservationRequestImplCopyWith<$Res> {
  __$$CreateReservationRequestImplCopyWithImpl(
      _$CreateReservationRequestImpl _value,
      $Res Function(_$CreateReservationRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of CreateReservationRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? timeSlotId = null,
    Object? guests = null,
    Object? name = freezed,
    Object? phone = freezed,
    Object? email = freezed,
    Object? notes = freezed,
  }) {
    return _then(_$CreateReservationRequestImpl(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      timeSlotId: null == timeSlotId
          ? _value.timeSlotId
          : timeSlotId // ignore: cast_nullable_to_non_nullable
              as String,
      guests: null == guests
          ? _value.guests
          : guests // ignore: cast_nullable_to_non_nullable
              as int,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CreateReservationRequestImpl implements _CreateReservationRequest {
  const _$CreateReservationRequestImpl(
      {required this.date,
      required this.timeSlotId,
      required this.guests,
      this.name,
      this.phone,
      this.email,
      this.notes});

  factory _$CreateReservationRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$CreateReservationRequestImplFromJson(json);

  @override
  final DateTime date;
  @override
  final String timeSlotId;
  @override
  final int guests;
  @override
  final String? name;
  @override
  final String? phone;
  @override
  final String? email;
  @override
  final String? notes;

  @override
  String toString() {
    return 'CreateReservationRequest(date: $date, timeSlotId: $timeSlotId, guests: $guests, name: $name, phone: $phone, email: $email, notes: $notes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateReservationRequestImpl &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.timeSlotId, timeSlotId) ||
                other.timeSlotId == timeSlotId) &&
            (identical(other.guests, guests) || other.guests == guests) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.notes, notes) || other.notes == notes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, date, timeSlotId, guests, name, phone, email, notes);

  /// Create a copy of CreateReservationRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateReservationRequestImplCopyWith<_$CreateReservationRequestImpl>
      get copyWith => __$$CreateReservationRequestImplCopyWithImpl<
          _$CreateReservationRequestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CreateReservationRequestImplToJson(
      this,
    );
  }
}

abstract class _CreateReservationRequest implements CreateReservationRequest {
  const factory _CreateReservationRequest(
      {required final DateTime date,
      required final String timeSlotId,
      required final int guests,
      final String? name,
      final String? phone,
      final String? email,
      final String? notes}) = _$CreateReservationRequestImpl;

  factory _CreateReservationRequest.fromJson(Map<String, dynamic> json) =
      _$CreateReservationRequestImpl.fromJson;

  @override
  DateTime get date;
  @override
  String get timeSlotId;
  @override
  int get guests;
  @override
  String? get name;
  @override
  String? get phone;
  @override
  String? get email;
  @override
  String? get notes;

  /// Create a copy of CreateReservationRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreateReservationRequestImplCopyWith<_$CreateReservationRequestImpl>
      get copyWith => throw _privateConstructorUsedError;
}
