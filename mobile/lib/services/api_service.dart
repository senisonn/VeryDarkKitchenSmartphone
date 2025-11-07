import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/plat.dart';
import '../models/auth.dart';
import '../models/reservation.dart';
import 'debug_service.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:8080/api';

  // Auth methods
  Future<AuthResponse> register(RegisterRequest request) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == 201) {
      final authResponse = AuthResponse.fromJson(jsonDecode(response.body));
      await _saveToken(authResponse.token);
      await _saveUserId(authResponse.userId);
      return authResponse;
    } else {
      throw Exception('Échec de l\'inscription');
    }
  }

  Future<AuthResponse> login(LoginRequest request) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == 200) {
      final authResponse = AuthResponse.fromJson(jsonDecode(response.body));
      await _saveToken(authResponse.token);
      await _saveUserId(authResponse.userId);
      return authResponse;
    } else {
      throw Exception('Échec de la connexion');
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
      throw Exception('Échec de la création de la réservation');
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
  }
}
