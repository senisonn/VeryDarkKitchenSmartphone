// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'time_slot_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TimeSlotModelImpl _$$TimeSlotModelImplFromJson(Map<String, dynamic> json) =>
    _$TimeSlotModelImpl(
      id: json['id'] as String,
      start: DateTime.parse(json['start'] as String),
      end: DateTime.parse(json['end'] as String),
      capacity: (json['capacity'] as num).toInt(),
      available: (json['available'] as num).toInt(),
    );

Map<String, dynamic> _$$TimeSlotModelImplToJson(_$TimeSlotModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'start': instance.start.toIso8601String(),
      'end': instance.end.toIso8601String(),
      'capacity': instance.capacity,
      'available': instance.available,
    };
