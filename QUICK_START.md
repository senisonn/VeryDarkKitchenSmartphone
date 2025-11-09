# VDKMobileApp

Application mobile Flutter avec services backend pour la gestion de réservations de restaurant.

## Démarrage

### Backend
```bash
cd backend
docker compose up
```

**Important:** Vérifiez le fichier `init.sql` dans le dossier backend pour l'initialisation de la base de données.

### Mobile
```bash
cd mobile
flutter pub get
flutter run
```

## Structure du Projet

```
VDKMobileApp/
├── backend/               # Services backend et API REST
│   ├── init.sql          # Script d'initialisation PostgreSQL
│   ├── docker-compose.yml
│   └── src/
│       └── main/
│           ├── java/     # Code Spring Boot
│           └── resources/
└── mobile/               # Application Flutter
    ├── lib/
    │   ├── models/      # Modèles de données
    │   ├── services/    # Services API
    │   ├── screens/     # Écrans de l'app
    │   └── widgets/     # Composants réutilisables
    └── pubspec.yaml
```

## Fonctionnalités

### 🍽️ Gestion des Réservations
- Création de réservations avec sélection de plats
- Vérification automatique de disponibilité
- Modification et annulation des réservations
- Visualisation des réservations utilisateur

### 👥 Authentification et Rôles
- Connexion utilisateur avec JWT
- Rôles CLIENT et ADMIN
- Interface sécurisée

### 🏪 Administration
- Tableau de bord admin
- Approbation/refus des réservations
- Gestion des réservations par statut

## Technologies et Frameworks

### Backend
- **Spring Boot** - Framework Java
- **Spring Security** - Authentification JWT
- **JPA/Hibernate** - ORM pour PostgreSQL
- **PostgreSQL** - Base de données
- **Docker** - Conteneurisation

### Frontend
- **Flutter** - Framework mobile multiplateforme
- **Dart** - Langage de programmation
- **HTTP** - Communication avec l'API REST
- **Provider** - Gestion d'état

### Infrastructure
- **Docker Compose** - Orchestration des services
- **JWT** - Authentification stateless
- **REST API** - Architecture API
