import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/repositories/admin_repository.dart';

part 'reservation_stats_model.freezed.dart';
part 'reservation_stats_model.g.dart';

@freezed
class ReservationStatsModel with _$ReservationStatsModel {
  const factory ReservationStatsModel({
    required int totalReservations,
    required int pendingReservations,
    required int confirmedReservations,
    required int canceledReservations,
    required int completedReservations,
    required Map<String, int> reservationsByDate,
  }) = _ReservationStatsModel;

  factory ReservationStatsModel.fromJson(Map<String, dynamic> json) =>
      _$ReservationStatsModelFromJson(json);

  const ReservationStatsModel._();

  ReservationStats toEntity() => ReservationStats(
        totalReservations: totalReservations,
        pendingReservations: pendingReservations,
        confirmedReservations: confirmedReservations,
        canceledReservations: canceledReservations,
        completedReservations: completedReservations,
        reservationsByDate: reservationsByDate,
      );
}
