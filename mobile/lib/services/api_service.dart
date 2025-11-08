import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/plat.dart';
import '../models/auth.dart';
import '../models/reservation.dart';
import '../config/api_config.dart';
import 'debug_service.dart';

class ApiService {
  // Get base URL from configuration
  static String get baseUrl => ApiConfig.baseUrl;

  // Helper method to extract error message from response
  String _extractErrorMessage(http.Response response, String defaultMessage) {
    try {
      final errorBody = jsonDecode(response.body);
      // FastAPI returns errors in 'detail' field
      // Spring Boot returns errors in 'message' field
      return errorBody['detail'] ?? errorBody['message'] ?? defaultMessage;
    } catch (e) {
      return defaultMessage;
    }
  }

  // Auth methods
  Future<AuthResponse> register(RegisterRequest request) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode == 201) {
        final authResponse = AuthResponse.fromJson(jsonDecode(response.body));
        await _saveToken(authResponse.token);
        await _saveUserId(authResponse.userId);
        await _saveUserInfo(
          authResponse.username,
          request.email,
          authResponse.role,
        );
        return authResponse;
      } else {
        throw Exception(_extractErrorMessage(response, 'Échec de l\'inscription'));
      }
    } catch (e) {
      throw Exception('Erreur de connexion au serveur ${ApiConfig.backendName}: $e');
    }
  }

  Future<AuthResponse> login(LoginRequest request) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode == 200) {
        final authResponse = AuthResponse.fromJson(jsonDecode(response.body));
        await _saveToken(authResponse.token);
        await _saveUserId(authResponse.userId);
        await _saveUserInfo(
          authResponse.username,
          '',  // Email not returned by login endpoint
          authResponse.role,
        );
        return authResponse;
      } else {
        throw Exception(_extractErrorMessage(response, 'Échec de la connexion'));
      }
    } catch (e) {
      if (e.toString().contains('Échec de la connexion')) {
        rethrow;
      }
      throw Exception('Erreur de connexion au serveur ${ApiConfig.backendName}: $e');
    }
  }

  // Menu methods
  Future<List<Plat>> getMenu() async {
    final response = await http.get(Uri.parse('$baseUrl/plats'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Plat.fromJson(json)).toList();
    } else {
      throw Exception('Échec du chargement du menu');
    }
  }

  // Reservation methods
  Future<ReservationResponse> createReservation(ReservationRequest request) async {
    try {
      final token = await _getToken();
      final response = await http.post(
        Uri.parse('$baseUrl/reservations'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode == 201) {
        return ReservationResponse.fromJson(jsonDecode(response.body));
      } else {
        throw Exception(_extractErrorMessage(response, 'Échec de la création de la réservation'));
      }
    } catch (e) {
      if (e.toString().contains('Échec de la création')) {
        rethrow;
      }
      throw Exception('Erreur de connexion au serveur: $e');
    }
  }

  Future<List<ReservationResponse>> getUserReservations() async {
    final token = await _getToken();
    final userId = await getUserId();

    if (userId == null) {
      throw Exception('Utilisateur non connecté');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/reservations/user/$userId'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => ReservationResponse.fromJson(json)).toList();
    } else {
      throw Exception('Échec du chargement des réservations');
    }
  }

  Future<ReservationResponse> updateReservation(
      int reservationId, UpdateReservationRequest request) async {
    try {
      final token = await _getToken();
      final response = await http.put(
        Uri.parse('$baseUrl/reservations/$reservationId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode == 200) {
        return ReservationResponse.fromJson(jsonDecode(response.body));
      } else {
        throw Exception(_extractErrorMessage(response, 'Échec de la mise à jour'));
      }
    } catch (e) {
      if (e.toString().contains('Échec de la mise à jour')) {
        rethrow;
      }
      throw Exception('Erreur de connexion au serveur: $e');
    }
  }

  Future<void> cancelReservation(int reservationId) async {
    final token = await _getToken();
    final response = await http.delete(
      Uri.parse('$baseUrl/reservations/$reservationId'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 204) {
      throw Exception('Échec de l\'annulation de la réservation');
    }
  }

  Future<AvailabilityResponse> checkAvailability(AvailabilityRequest request) async {
    final token = await _getToken();
    final response = await http.post(
      Uri.parse('$baseUrl/reservations/availability'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == 200) {
      return AvailabilityResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Échec de la vérification de disponibilité');
    }
  }

  // Admin methods
  Future<List<ReservationResponse>> getPendingReservations() async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/reservations/pending'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => ReservationResponse.fromJson(json)).toList();
    } else {
      throw Exception('Échec du chargement des réservations en attente');
    }
  }

  Future<ReservationResponse> approveReservation(int reservationId) async {
    final token = await _getToken();
    final response = await http.put(
      Uri.parse('$baseUrl/reservations/$reservationId/approve'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return ReservationResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Échec de l\'approbation de la réservation');
    }
  }

  Future<ReservationResponse> rejectReservation(int reservationId) async {
    final token = await _getToken();
    final response = await http.put(
      Uri.parse('$baseUrl/reservations/$reservationId/reject'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return ReservationResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Échec du rejet de la réservation');
    }
  }

  // Token management
  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<void> _saveUserId(int userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('userId', userId);
  }

  Future<void> _saveUserInfo(String username, String email, String role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', username);
    if (email.isNotEmpty) {
      await prefs.setString('email', email);
    }
    await prefs.setString('role', role);
  }

  Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('userId');
  }

  Future<bool> isLoggedIn() async {
    // If debug override is enabled, consider user as logged in
    final debug = await DebugService.isDebugEnabled();
    if (debug) return true;

    final token = await _getToken();
    return token != null;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('userId');
    await prefs.remove('username');
    await prefs.remove('email');
    await prefs.remove('role');
  }
}
