// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_reservation_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CreateReservationRequestImpl _$$CreateReservationRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$CreateReservationRequestImpl(
      date: DateTime.parse(json['date'] as String),
      timeSlotId: json['timeSlotId'] as String,
      guests: (json['guests'] as num).toInt(),
      name: json['name'] as String?,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$$CreateReservationRequestImplToJson(
        _$CreateReservationRequestImpl instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'timeSlotId': instance.timeSlotId,
      'guests': instance.guests,
      'name': instance.name,
      'phone': instance.phone,
      'email': instance.email,
      'notes': instance.notes,
    };
