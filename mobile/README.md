# Very Dark Kitchen - Application Mobile

Application Flutter simple et fonctionnelle pour le restaurant Very Dark Kitchen.

## Fonctionnalités Implémentées

### 1. Affichage du Menu (Sans Connexion)
- Accès au menu complet sans authentification
- Liste des plats avec nom, description, prix et catégorie
- Indication de disponibilité des plats
- Sélection multiple de plats pour réservation
- Pull-to-refresh pour actualiser le menu

### 2. Authentification Utilisateur
- **Inscription**: Formulaire avec username, email et mot de passe
  - Validation des champs (longueur min, format email)
  - Création automatique avec rôle USER
- **Connexion**: Username et mot de passe
- Stockage sécurisé du token JWT
- Possibilité de naviguer sans connexion

### 3. Réservation
- Formulaire complet avec:
  - Informations de contact (email, téléphone)
  - Sélection de date (date picker)
  - Sélection d'heure (time picker)
  - Nombre de personnes (1-20)
  - Commentaire optionnel
- Plats pré-sélectionnés depuis le menu
- Validation des champs obligatoires
- Nécessite une connexion

## Architecture

```
lib/
├── models/          # Modèles de données
│   ├── auth.dart    # AuthResponse, LoginRequest, RegisterRequest
│   ├── plat.dart    # Plat
│   └── reservation.dart  # ReservationRequest, ReservationResponse
├── services/
│   └── api_service.dart  # Communication avec l'API
├── screens/         # Écrans de l'application
│   ├── menu_screen.dart
│   ├── login_screen.dart
│   ├── register_screen.dart
│   └── reservation_screen.dart
└── main.dart        # Point d'entrée et navigation
```

## Configuration de l'API

**L'application utilise actuellement un service API mocké (`MockApiService`) qui fonctionne complètement hors ligne avec des données fictives.**

### Mode Mock (Actuel)
- Aucune connexion backend nécessaire
- 15 plats pré-chargés (burgers, pizzas, pâtes, desserts, boissons)
- Authentification simulée (toute inscription/connexion fonctionne)
- Réservations simulées avec succès

### Mode Réel (Si besoin)
Pour utiliser la vraie API, remplacez `MockApiService` par `ApiService` dans tous les fichiers screens:
- `lib/screens/login_screen.dart`
- `lib/screens/register_screen.dart`
- `lib/screens/menu_screen.dart`
- `lib/screens/reservation_screen.dart`

L'URL de base de l'API réelle est: `http://localhost:8080/api`
- Android Emulator: `http://10.0.2.2:8080/api`
- Appareil physique: `http://192.168.x.x:8080/api`

## Endpoints Utilisés

- `POST /api/auth/register` - Inscription
- `POST /api/auth/login` - Connexion
- `GET /api/plats` - Liste des plats
- `POST /api/reservations` - Création de réservation

## Dépendances

- **http**: ^1.2.0 - Requêtes HTTP
- **shared_preferences**: ^2.2.2 - Stockage local du token
- **intl**: ^0.19.0 - Formatage des dates

## Lancement de l'Application

```bash
# Installer les dépendances
flutter pub get

# Lancer l'application
flutter run

# Pour un appareil spécifique
flutter run -d <device_id>
```

## Navigation

- `/menu` - Page d'accueil (menu du restaurant)
- `/login` - Page de connexion
- `/register` - Page d'inscription
- `/reservation` - Formulaire de réservation

## Flux Utilisateur

1. L'utilisateur arrive sur le menu (accessible sans connexion)
2. Il peut parcourir les plats et en sélectionner plusieurs
3. Pour réserver, il doit se connecter ou s'inscrire
4. Une fois connecté, il remplit le formulaire de réservation
5. La réservation est envoyée à l'API avec le token JWT

## Points d'Attention

- Le token JWT est stocké localement avec SharedPreferences
- La validation des formulaires est effectuée côté client
- Les erreurs API sont affichées via des SnackBar
- L'application fonctionne en mode Material 3

## Données Mock Disponibles

### Menu (15 plats)
**Burgers:**
- Burger Classique (12.90€)
- Burger Bacon (14.90€)
- Burger Végétarien (11.90€)

**Pizzas:**
- Pizza Margherita (9.90€)
- Pizza 4 Fromages (13.90€)
- Pizza Pepperoni (12.90€)

**Salades:**
- Salade César (10.90€)
- Salade Méditerranéenne (9.90€)

**Pâtes:**
- Pâtes Carbonara (11.90€)
- Pâtes Bolognaise (10.90€)

**Desserts:**
- Tiramisu (6.50€)
- Tarte au Citron (5.90€)
- Fondant au Chocolat (6.90€)

**Boissons:**
- Coca-Cola (2.50€)
- Eau Minérale (2.00€)

### Authentification Mock
- N'importe quel username/password fonctionne pour l'inscription
- Une fois inscrit, utilisez les mêmes identifiants pour vous connecter
- Les utilisateurs sont stockés en mémoire (disparaissent au redémarrage)
