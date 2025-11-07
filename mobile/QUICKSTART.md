# Quick Start Guide - Very Dark Kitchen App

## Installation et Lancement (2 minutes)

### 1. Installation des dépendances
```bash
cd mobile
flutter pub get
```

### 2. Lancer l'application
```bash
flutter run
```

L'application se lance immédiatement avec des données mockées - **aucun backend nécessaire** !

## Test de l'Application

### Étape 1: Explorer le Menu (sans connexion)
- L'application démarre sur l'écran du menu
- Vous voyez 15 plats disponibles (burgers, pizzas, pâtes, desserts, boissons)
- Sélectionnez quelques plats en cochant les cases
- Cliquez sur le bouton "Réserver" en haut

### Étape 2: S'inscrire
- Quand vous cliquez sur "Réserver", on vous demande de vous connecter
- Cliquez sur "Pas de compte? Inscrivez-vous"
- Remplissez le formulaire avec n'importe quelles données:
  - **Username**: `test` (min 3 caractères)
  - **Email**: `test@example.com`
  - **Password**: `123456` (min 6 caractères)
- Cliquez sur "S'inscrire"

### Étape 3: Faire une Réservation
- Après inscription, vous êtes redirigé vers le menu
- Sélectionnez à nouveau des plats
- Cliquez sur "Réserver"
- Remplissez le formulaire de réservation:
  - Email: `test@example.com`
  - Téléphone: `0601020304`
  - Date: Choisissez une date
  - Heure: Choisissez une heure
  - Nombre de personnes: Ajustez avec +/-
  - Commentaire (optionnel)
- Cliquez sur "Confirmer la réservation"
- Vous verrez un message de succès !

### Étape 4: Se Reconnecter (optionnel)
- Revenez au menu
- Cliquez sur l'icône utilisateur en haut à droite
- Connectez-vous avec les mêmes identifiants:
  - **Username**: `test`
  - **Password**: `123456`

## Fonctionnalités Testables

✅ **Menu sans connexion** - Parcourir le menu librement
✅ **Inscription** - Créer un compte utilisateur
✅ **Connexion** - Se connecter avec les identifiants créés
✅ **Sélection de plats** - Cocher plusieurs plats
✅ **Réservation** - Formulaire complet avec date/heure
✅ **Validation** - Les champs obligatoires sont validés
✅ **Navigation** - Navigation fluide entre les écrans

## Résolution de Problèmes

### L'app ne se lance pas
```bash
flutter clean
flutter pub get
flutter run
```

### Pas d'émulateur/simulateur
```bash
# Lister les appareils disponibles
flutter devices

# Lancer sur un appareil spécifique
flutter run -d <device_id>
```

### Erreur de dépendances
```bash
flutter pub upgrade
flutter pub get
```

## Architecture Mock

L'application utilise `MockApiService` qui simule:
- Un serveur HTTP avec délai de 500ms
- Une base de données en mémoire pour les utilisateurs
- 15 plats pré-chargés dans le menu
- Génération de tokens JWT fictifs
- Réservations acceptées automatiquement

**Avantage**: Testez toutes les fonctionnalités sans configurer de backend !
