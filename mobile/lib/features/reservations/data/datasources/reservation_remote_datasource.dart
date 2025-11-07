import 'package:dio/dio.dart';

import '../../../../core/network/api_client.dart';
import '../models/reservation_model.dart';
import '../models/time_slot_model.dart';

/// Remote data source for reservation operations.
class ReservationRemoteDataSource {
  final ApiClient _apiClient;

  ReservationRemoteDataSource(this._apiClient);

  /// Get user's reservations.
  Future<List<ReservationModel>> getUserReservations({String? userId}) async {
    try {
      final response = await _apiClient.dio.get<Map<String, dynamic>>(
        '/reservations',
        queryParameters: userId != null ? {'userId': userId} : null,
      );

      final data = response.data;
      if (data == null) return [];

      final List<dynamic> items = data is Map ? (data['data'] as List<dynamic>?) ?? [] : [];

      return items
          .map((json) => ReservationModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (_) {
      rethrow;
    }
  }

  /// Get a reservation by ID.
  Future<ReservationModel> getReservationById(String id) async {
    try {
      final response = await _apiClient.dio.get<Map<String, dynamic>>(
        '/reservations/$id',
      );

      final data = response.data;
      if (data == null) throw DioException(requestOptions: response.requestOptions);

      final itemData = data is Map ? (data['data'] ?? data) : data;

      return ReservationModel.fromJson(itemData as Map<String, dynamic>);
    } on DioException catch (_) {
      rethrow;
    }
  }

  /// Create a new reservation.
  Future<ReservationModel> createReservation(Map<String, dynamic> createRequest) async {
    try {
      final response = await _apiClient.dio.post<Map<String, dynamic>>(
        '/reservations',
        data: createRequest,
      );

      final data = response.data;
      if (data == null) throw DioException(requestOptions: response.requestOptions);

      final itemData = data is Map ? (data['data'] ?? data) : data;

      return ReservationModel.fromJson(itemData as Map<String, dynamic>);
    } on DioException catch (_) {
      rethrow;
    }
  }

  /// Update an existing reservation.
  Future<ReservationModel> updateReservation(
    String id,
    Map<String, dynamic> updateRequest,
  ) async {
    try {
      final response = await _apiClient.dio.put<Map<String, dynamic>>(
        '/reservations/$id',
        data: updateRequest,
      );

      final data = response.data;
      if (data == null) throw DioException(requestOptions: response.requestOptions);

      final itemData = data is Map ? (data['data'] ?? data) : data;

      return ReservationModel.fromJson(itemData as Map<String, dynamic>);
    } on DioException catch (_) {
      rethrow;
    }
  }

  /// Cancel a reservation.
  Future<void> cancelReservation(String id) async {
    try {
      await _apiClient.dio.delete('/reservations/$id');
    } on DioException catch (_) {
      rethrow;
    }
  }

  /// Get available time slots for a date.
  Future<List<TimeSlotModel>> getAvailableTimeSlots(DateTime date) async {
    try {
      final response = await _apiClient.dio.get<Map<String, dynamic>>(
        '/reservations/available-slots',
        queryParameters: {
          'date': date.toIso8601String(),
        },
      );

      final data = response.data;
      if (data == null) return [];

      final List<dynamic> items = data is Map ? (data['data'] as List<dynamic>?) ?? [] : [];

      return items
          .map((json) => TimeSlotModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (_) {
      rethrow;
    }
  }
}
