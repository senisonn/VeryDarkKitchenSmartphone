import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/time_slot.dart';

part 'time_slot_model.freezed.dart';
part 'time_slot_model.g.dart';

@freezed
class TimeSlotModel with _$TimeSlotModel {
  const factory TimeSlotModel({
    required String id,
    required DateTime start,
    required DateTime end,
    required int capacity,
    required int available,
  }) = _TimeSlotModel;

  factory TimeSlotModel.fromJson(Map<String, dynamic> json) => _$TimeSlotModelFromJson(json);

  const TimeSlotModel._();

  TimeSlot toEntity() => TimeSlot(
        id: id,
        start: start,
        end: end,
        capacity: capacity,
        available: available,
      );

  factory TimeSlotModel.fromEntity(TimeSlot entity) => TimeSlotModel(
        id: entity.id,
        start: entity.start,
        end: entity.end,
        capacity: entity.capacity,
        available: entity.available,
      );
}
