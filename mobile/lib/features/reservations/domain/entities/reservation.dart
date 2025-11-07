import 'package:freezed_annotation/freezed_annotation.dart';

part 'reservation.freezed.dart';
part 'reservation.g.dart';

enum ReservationStatus { pending, confirmed, canceled, completed }

@freezed
class Reservation with _$Reservation {
  const factory Reservation({
    required String id,
    required String userId,
    required DateTime date,
    required String timeSlotId,
    required int guests,
    required ReservationStatus status,
    String? name,
    String? phone,
    String? email,
    String? notes,
    DateTime? startTime,
    DateTime? endTime,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Reservation;

  const Reservation._();

  factory Reservation.fromJson(Map<String, dynamic> json) => _$ReservationFromJson(json);
}
