import 'package:dio/dio.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../reservations/data/models/reservation_model.dart';
import '../../../reservations/domain/entities/reservation.dart';
import '../models/reservation_stats_model.dart';

/// Remote datasource for admin/back office API calls.
class AdminRemoteDataSource {
  final Dio _dio;

  AdminRemoteDataSource(this._dio);

  /// Get all reservations with optional filters.
  Future<List<ReservationModel>> getAllReservations({
    DateTime? date,
    ReservationStatus? status,
  }) async {
    try {
      final queryParams = <String, dynamic>{};

      if (date != null) {
        queryParams['date'] = date.toIso8601String();
      }

      if (status != null) {
        queryParams['status'] = status.name;
      }

      final response = await _dio.get(
        ApiConstants.adminReservations,
        queryParameters: queryParams,
      );

      final dynamic responseData = response.data;
      final List<dynamic> data = (responseData is Map && responseData.containsKey('data'))
          ? (responseData['data'] as List<dynamic>)
          : (responseData as List<dynamic>);
      return data
          .map((json) => ReservationModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw Exception('Failed to load reservations: ${e.message}');
    }
  }

  /// Get reservation statistics.
  Future<ReservationStatsModel> getReservationStats({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final queryParams = <String, dynamic>{};

      if (startDate != null) {
        queryParams['startDate'] = startDate.toIso8601String();
      }

      if (endDate != null) {
        queryParams['endDate'] = endDate.toIso8601String();
      }

      final response = await _dio.get(
        ApiConstants.adminStats,
        queryParameters: queryParams,
      );

      return ReservationStatsModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw Exception('Failed to load stats: ${e.message}');
    }
  }

  /// Validate (confirm) a reservation.
  Future<ReservationModel> validateReservation(String reservationId) async {
    try {
      final response = await _dio.post(
        '${ApiConstants.adminReservations}/$reservationId/validate',
      );

      return ReservationModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw Exception('Failed to validate reservation: ${e.message}');
    }
  }

  /// Refuse (reject) a reservation.
  Future<ReservationModel> refuseReservation(
    String reservationId, {
    String? reason,
  }) async {
    try {
      final response = await _dio.post(
        '${ApiConstants.adminReservations}/$reservationId/refuse',
        data: {
          if (reason != null) 'reason': reason,
        },
      );

      return ReservationModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw Exception('Failed to refuse reservation: ${e.message}');
    }
  }

  /// Get reservations for a specific date.
  Future<List<ReservationModel>> getReservationsByDate(DateTime date) async {
    return getAllReservations(date: date);
  }
}
