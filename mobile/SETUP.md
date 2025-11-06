# Restaurant Reservation App - Setup Guide

## Prerequisites
- Flutter SDK 3.5.0 or higher
- Dart SDK 3.5.0 or higher
- Android Studio / Xcode (for mobile development)
- VS Code with Flutter extensions (recommended)

## Installation Steps

### 1. Install Dependencies
```bash
flutter pub get
```

### 2. Run Code Generation
Generate required files for Riverpod, Freezed, and JSON serialization:
```bash
dart run build_runner build --delete-conflicting-outputs
```

For continuous generation during development:
```bash
dart run build_runner watch --delete-conflicting-outputs
```

### 3. Verify Setup
```bash
flutter doctor
flutter analyze
```

## Project Structure

```
lib/
├── main.dart                    # App entry point
├── app.dart                     # App widget configuration
├── core/                        # Core functionality
│   ├── constants/              # App-wide constants
│   │   ├── api_constants.dart
│   │   ├── app_constants.dart
│   │   └── string_constants.dart
│   ├── theme/                  # Material 3 theme
│   │   ├── app_colors.dart
│   │   ├── app_dimensions.dart
│   │   ├── app_text_styles.dart
│   │   └── app_theme.dart
│   ├── utils/                  # Utilities
│   │   ├── validators.dart
│   │   ├── extensions.dart
│   │   ├── logger.dart
│   │   └── date_utils.dart
│   ├── router/                 # Navigation
│   │   ├── app_router.dart
│   │   └── route_names.dart
│   └── network/                # API client
│       ├── api_client.dart
│       ├── api_client_provider.dart
│       ├── auth_interceptor.dart
│       └── error_interceptor.dart
├── shared/                      # Shared across features
│   ├── models/                 # Shared data models
│   │   ├── failure.dart
│   │   ├── result.dart
│   │   └── api_response.dart
│   ├── widgets/                # Reusable widgets
│   └── providers/              # Shared providers
└── features/                    # Feature modules
    ├── auth/                   # Authentication
    │   ├── domain/
    │   ├── data/
    │   └── presentation/
    ├── menu/                   # Menu display
    │   ├── domain/
    │   ├── data/
    │   └── presentation/
    ├── reservations/           # Booking system
    │   ├── domain/
    │   ├── data/
    │   └── presentation/
    └── back_office/            # Admin panel
        ├── domain/
        ├── data/
        └── presentation/
```

## Development Workflow

### Running the App
```bash
# Development mode with hot reload
flutter run

# Release mode
flutter run --release

# Specific device
flutter run -d <device_id>
```

### Code Generation
After creating/modifying files with `@freezed` or `@riverpod` annotations:
```bash
dart run build_runner build --delete-conflicting-outputs
```

### Testing
```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Run specific test file
flutter test test/features/auth/login_test.dart
```

### Linting
```bash
# Analyze code
flutter analyze

# Fix auto-fixable issues
dart fix --apply
```

### Build
```bash
# Android APK
flutter build apk

# Android App Bundle
flutter build appbundle

# iOS
flutter build ios

# Web
flutter build web
```

## Environment Configuration

### Development
Update `lib/core/constants/api_constants.dart`:
```dart
static const String baseUrl = 'https://api-dev.restaurant.com';
```

### Production
```dart
static const String baseUrl = 'https://api.restaurant.com';
```

## Common Issues

### Build Runner Conflicts
```bash
dart run build_runner clean
dart run build_runner build --delete-conflicting-outputs
```

### Dependency Conflicts
```bash
flutter clean
flutter pub get
```

### iOS Pod Issues
```bash
cd ios
pod deintegrate
pod install
cd ..
flutter run
```

## Next Steps

1. ✅ Complete core foundation (DONE)
2. 🔄 Implement router with GoRouter
3. 🔄 Create shared widgets
4. 🔄 Build Auth feature
5. 🔄 Build Menu feature
6. 🔄 Build Reservations feature
7. 🔄 Build Back Office feature
8. 🔄 Add tests
9. 🔄 Performance optimization

## Resources

- [Flutter Documentation](https://docs.flutter.dev)
- [Riverpod Documentation](https://riverpod.dev)
- [Material Design 3](https://m3.material.io)
- [Go Router](https://pub.dev/packages/go_router)
- [Freezed](https://pub.dev/packages/freezed)

## Support

For issues or questions, refer to the project documentation or create an issue in the repository.
