import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/reservation.dart';

part 'reservation_model.freezed.dart';
part 'reservation_model.g.dart';

@freezed
class ReservationModel with _$ReservationModel {
  const factory ReservationModel({
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
  }) = _ReservationModel;

  factory ReservationModel.fromJson(Map<String, dynamic> json) => _$ReservationModelFromJson(json);

  const ReservationModel._();

  Reservation toEntity() => Reservation(
        id: id,
        userId: userId,
        date: date,
        timeSlotId: timeSlotId,
        guests: guests,
        status: status,
        name: name,
        phone: phone,
        email: email,
        notes: notes,
        startTime: startTime,
        endTime: endTime,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

  factory ReservationModel.fromEntity(Reservation entity) => ReservationModel(
        id: entity.id,
        userId: entity.userId,
        date: entity.date,
        timeSlotId: entity.timeSlotId,
        guests: entity.guests,
        status: entity.status,
        name: entity.name,
        phone: entity.phone,
        email: entity.email,
        notes: entity.notes,
        startTime: entity.startTime,
        endTime: entity.endTime,
        createdAt: entity.createdAt,
        updatedAt: entity.updatedAt,
      );
}
