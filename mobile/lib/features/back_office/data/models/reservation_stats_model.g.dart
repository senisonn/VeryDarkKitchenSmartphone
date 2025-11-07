// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reservation_stats_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ReservationStatsModelImpl _$$ReservationStatsModelImplFromJson(
        Map<String, dynamic> json) =>
    _$ReservationStatsModelImpl(
      totalReservations: (json['totalReservations'] as num).toInt(),
      pendingReservations: (json['pendingReservations'] as num).toInt(),
      confirmedReservations: (json['confirmedReservations'] as num).toInt(),
      canceledReservations: (json['canceledReservations'] as num).toInt(),
      completedReservations: (json['completedReservations'] as num).toInt(),
      reservationsByDate:
          Map<String, int>.from(json['reservationsByDate'] as Map),
    );

Map<String, dynamic> _$$ReservationStatsModelImplToJson(
        _$ReservationStatsModelImpl instance) =>
    <String, dynamic>{
      'totalReservations': instance.totalReservations,
      'pendingReservations': instance.pendingReservations,
      'confirmedReservations': instance.confirmedReservations,
      'canceledReservations': instance.canceledReservations,
      'completedReservations': instance.completedReservations,
      'reservationsByDate': instance.reservationsByDate,
    };
