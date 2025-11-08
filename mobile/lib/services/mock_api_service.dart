import 'package:shared_preferences/shared_preferences.dart';
import '../models/plat.dart';
import '../models/auth.dart';
import '../models/reservation.dart';
import 'debug_service.dart';

class MockApiService {
  // Simulated network delay
  Future<void> _delay() => Future.delayed(const Duration(milliseconds: 500));

  // Mock menu data
  final List<Plat> _mockPlats = [
    Plat(
      id: 1,
      nom: 'Burger Classique',
      description: 'Pain artisanal, steak haché 180g, cheddar, salade, tomate, oignons',
      prix: 12.90,
      categorie: 'BURGER',
      imageUrl: null,
      disponible: true,
    ),
    Plat(
      id: 2,
      nom: 'Burger Bacon',
      description: 'Pain artisanal, steak 180g, bacon croustillant, cheddar, sauce BBQ',
      prix: 14.90,
      categorie: 'BURGER',
      imageUrl: null,
      disponible: true,
    ),
    Plat(
      id: 3,
      nom: 'Burger Végétarien',
      description: 'Pain complet, galette végétale, avocat, tomates, roquette',
      prix: 11.90,
      categorie: 'BURGER',
      imageUrl: null,
      disponible: true,
    ),
    Plat(
      id: 4,
      nom: 'Pizza Margherita',
      description: 'Base tomate, mozzarella, basilic frais',
      prix: 9.90,
      categorie: 'PIZZA',
      imageUrl: null,
      disponible: true,
    ),
    Plat(
      id: 5,
      nom: 'Pizza 4 Fromages',
      description: 'Mozzarella, gorgonzola, chèvre, parmesan',
      prix: 13.90,
      categorie: 'PIZZA',
      imageUrl: null,
      disponible: true,
    ),
    Plat(
      id: 6,
      nom: 'Pizza Pepperoni',
      description: 'Base tomate, mozzarella, pepperoni, origan',
      prix: 12.90,
      categorie: 'PIZZA',
      imageUrl: null,
      disponible: true,
    ),
    Plat(
      id: 7,
      nom: 'Salade César',
      description: 'Laitue, poulet grillé, croûtons, parmesan, sauce césar',
      prix: 10.90,
      categorie: 'SALADE',
      imageUrl: null,
      disponible: true,
    ),
    Plat(
      id: 8,
      nom: 'Salade Méditerranéenne',
      description: 'Tomates, concombres, feta, olives, oignons rouges',
      prix: 9.90,
      categorie: 'SALADE',
      imageUrl: null,
      disponible: true,
    ),
    Plat(
      id: 9,
      nom: 'Pâtes Carbonara',
      description: 'Spaghetti, lardons, crème, parmesan, jaune d\'œuf',
      prix: 11.90,
      categorie: 'PATES',
      imageUrl: null,
      disponible: true,
    ),
    Plat(
      id: 10,
      nom: 'Pâtes Bolognaise',
      description: 'Tagliatelles, sauce bolognaise maison, parmesan',
      prix: 10.90,
      categorie: 'PATES',
      imageUrl: null,
      disponible: true,
    ),
    Plat(
      id: 11,
      nom: 'Tiramisu',
      description: 'Biscuits, mascarpone, café, cacao',
      prix: 6.50,
      categorie: 'DESSERT',
      imageUrl: null,
      disponible: true,
    ),
    Plat(
      id: 12,
      nom: 'Tarte au Citron',
      description: 'Pâte sablée, crème au citron, meringue',
      prix: 5.90,
      categorie: 'DESSERT',
      imageUrl: null,
      disponible: true,
    ),
    Plat(
      id: 13,
      nom: 'Fondant au Chocolat',
      description: 'Gâteau coulant au chocolat noir, glace vanille',
      prix: 6.90,
      categorie: 'DESSERT',
      imageUrl: null,
      disponible: true,
    ),
    Plat(
      id: 14,
      nom: 'Coca-Cola',
      description: 'Canette 33cl',
      prix: 2.50,
      categorie: 'BOISSON',
      imageUrl: null,
      disponible: true,
    ),
    Plat(
      id: 15,
      nom: 'Eau Minérale',
      description: 'Bouteille 50cl',
      prix: 2.00,
      categorie: 'BOISSON',
      imageUrl: null,
      disponible: true,
    ),
  ];

  // Mock users database (in memory)
  final List<Map<String, dynamic>> _mockUsers = [];
  int _userIdCounter = 1;
  int _reservationIdCounter = 1;

  // Auth methods
  Future<AuthResponse> register(RegisterRequest request) async {
    await _delay();

    // Check if user already exists
    final existingUser = _mockUsers.firstWhere(
      (u) => u['username'] == request.username,
      orElse: () => {},
    );

    if (existingUser.isNotEmpty) {
      throw Exception('Utilisateur déjà existant');
    }

    // Create new user
    final userId = _userIdCounter++;
    final user = {
      'id': userId,
      'username': request.username,
      'email': request.email,
      'password': request.password,
      'role': request.role,
    };
    _mockUsers.add(user);

    // Generate mock token
    final token = 'mock_token_${DateTime.now().millisecondsSinceEpoch}';

    final authResponse = AuthResponse(
      token: token,
      role: request.role,
      userId: userId,
      username: request.username,
    );

    await _saveToken(token);
    await _saveUserId(userId);

    return authResponse;
  }

  Future<AuthResponse> login(LoginRequest request) async {
    await _delay();

    // Find user
    final user = _mockUsers.firstWhere(
      (u) => u['username'] == request.username && u['password'] == request.password,
      orElse: () => {},
    );

    if (user.isEmpty) {
      throw Exception('Identifiants incorrects');
    }

    // Generate mock token
    final token = 'mock_token_${DateTime.now().millisecondsSinceEpoch}';

    final authResponse = AuthResponse(
      token: token,
      role: user['role'],
      userId: user['id'],
      username: user['username'],
    );

    await _saveToken(token);
    await _saveUserId(user['id']);

    return authResponse;
  }

  // Menu methods
  Future<List<Plat>> getMenu() async {
    await _delay();
    return _mockPlats;
  }

  // Reservation methods
  Future<ReservationResponse> createReservation(ReservationRequest request) async {
    await _delay();

    final reservationId = _reservationIdCounter++;

    final response = ReservationResponse(
      id: reservationId,
      userId: request.idClient,  // Changed from idClient to userId
      email: request.email,
      telephone: request.telephone,
      dateReservation: request.dateReservation,
      nombrePersonnes: request.nombrePersonnes,
      statut: 'EN_ATTENTE',
      commentaire: request.commentaire,
    );

    return response;
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
