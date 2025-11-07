import 'package:freezed_annotation/freezed_annotation.dart';

part 'time_slot.freezed.dart';
part 'time_slot.g.dart';

@freezed
class TimeSlot with _$TimeSlot {
  const factory TimeSlot({
    required String id,
    required DateTime start,
    required DateTime end,
    required int capacity,
    required int available,
  }) = _TimeSlot;

  const TimeSlot._();

  factory TimeSlot.fromJson(Map<String, dynamic> json) => _$TimeSlotFromJson(json);

  /// Convenience getters for compatibility with widget
  DateTime get startTime => start;
  DateTime get endTime => end;
  bool get isAvailable => available > 0;
  int get bookedCount => capacity - available;
}
