# 🍽️ Restaurant Reservation App

A modern, production-ready Flutter application for restaurant reservations with user authentication, menu display, booking management, and back-office administration.

## 📱 Features

### Mandatory Features
- ✅ Menu display (accessible without login)
- ✅ User authentication (email + password)
- ✅ Reservation creation with date/time selection
- ✅ User dashboard (view, edit, cancel reservations)
- ✅ Back-office for hosts (validate/refuse reservations)

### Advanced Features
- 🚀 Real-time availability checking
- 🚀 Form validation with error handling
- 🚀 Responsive design (phones & tablets)
- 🚀 Loading states and error recovery
- 🚀 Smooth animations and transitions

### Bonus Features (Planned)
- 🌟 Local notifications
- 🌟 Google Maps integration
- 🌟 Table management

## 🏗️ Architecture

This project follows **Clean Architecture** principles with **Riverpod 2.x** for state management.

```
lib/
├── main.dart                    # App entry point
├── app.dart                     # App widget
├── core/                        # Core functionality
│   ├── constants/              # App-wide constants
│   ├── theme/                  # Material 3 theme
│   ├── utils/                  # Utilities & helpers
│   ├── router/                 # Navigation (TODO)
│   └── network/                # API client & interceptors
├── shared/                      # Shared across features
│   ├── models/                 # Common models
│   ├── widgets/                # Reusable widgets (TODO)
│   └── providers/              # Shared providers (TODO)
└── features/                    # Feature modules
    ├── auth/                   # Authentication (TODO)
    ├── menu/                   # Menu display (TODO)
    ├── reservations/           # Booking system (TODO)
    └── back_office/            # Admin panel (TODO)
```

## 🎨 Tech Stack

### Core
- **Flutter**: 3.5.0+
- **Dart**: 3.5.0+
- **State Management**: Riverpod 2.5.1

### Architecture & Patterns
- **Clean Architecture**: Domain, Data, Presentation layers
- **Riverpod Code Generation**: @riverpod annotations
- **Freezed**: Immutable data classes
- **Dartz**: Functional programming (Either type)

### UI & Design
- **Material 3**: Modern design system
- **Responsive Design**: Phones, tablets, desktop
- **Animations**: flutter_animate
- **Theming**: Light & Dark mode support

### Networking & Data
- **HTTP**: Dio 5.7.0
- **Interceptors**: Auth, Error handling, Logging
- **Storage**: flutter_secure_storage, shared_preferences
- **Caching**: Built-in support

### Forms & Validation
- **Validators**: Custom validation logic
- **Date/Time**: table_calendar, intl

### Development
- **Code Generation**: build_runner
- **Linting**: very_good_analysis
- **Logging**: logger with pretty formatting

## ✅ What's Implemented

### 1. Project Configuration
- ✅ Complete `pubspec.yaml` with all dependencies
- ✅ Strict `analysis_options.yaml` with linting rules
- ✅ Clean Architecture folder structure

### 2. Core Constants
- ✅ `api_constants.dart` - All API endpoints and configuration
- ✅ `app_constants.dart` - Business rules and app settings
- ✅ `string_constants.dart` - All UI strings (i18n-ready)

### 3. Theme System (Material 3)
- ✅ `app_colors.dart` - Complete color palette
- ✅ `app_dimensions.dart` - Spacing, sizing (8dp grid)
- ✅ `app_text_styles.dart` - Typography system
- ✅ `app_theme.dart` - Light & dark themes

### 4. Core Utilities
- ✅ `validators.dart` - Email, password, phone validators
- ✅ `extensions.dart` - String, DateTime, BuildContext extensions
- ✅ `logger.dart` - Comprehensive logging utility
- ✅ `date_utils.dart` - Date/time manipulation helpers

### 5. Shared Models
- ✅ `failure.dart` - Sealed failure classes (error handling)
- ✅ `result.dart` - Either type for functional error handling
- ✅ `api_response.dart` - Generic API response wrappers

### 6. API Service
- ✅ `api_client.dart` - Dio HTTP client with all methods
- ✅ `auth_interceptor.dart` - Token injection & refresh
- ✅ `error_interceptor.dart` - Error handling & conversion
- ✅ `api_client_provider.dart` - Riverpod providers

### 7. App Foundation
- ✅ `main.dart` - Entry point with error handling
- ✅ `app.dart` - Material App with theme configuration

## 🚀 Getting Started

### Prerequisites
```bash
# Check Flutter installation
flutter doctor

# Should see Flutter 3.5.0+ and Dart 3.5.0+
```

### Installation

1. **Install Dependencies**
```bash
flutter pub get
```

2. **Generate Code** (for Riverpod, Freezed, JSON serialization)
```bash
dart run build_runner build --delete-conflicting-outputs
```

3. **Run the App**
```bash
flutter run
```

You should see a welcome screen confirming the foundation is working!

### Development Mode

For continuous code generation during development:
```bash
dart run build_runner watch --delete-conflicting-outputs
```

## 📝 Next Steps - What Needs to Be Implemented

### Priority 1: Router & Navigation
- [ ] `core/router/app_router.dart` - GoRouter configuration
- [ ] `core/router/route_names.dart` - Route constants
- [ ] Auth guards for protected routes

### Priority 2: Shared Widgets
- [ ] `shared/widgets/custom_button.dart`
- [ ] `shared/widgets/custom_text_field.dart`
- [ ] `shared/widgets/loading_widget.dart`
- [ ] `shared/widgets/error_widget.dart`
- [ ] `shared/widgets/empty_state_widget.dart`
- [ ] Additional reusable components

### Priority 3: Authentication Feature
- [ ] **Domain Layer**
  - `entities/user.dart`
  - `repositories/auth_repository.dart` (interface)
- [ ] **Data Layer**
  - `models/user_model.dart`
  - `datasources/auth_remote_datasource.dart`
  - `repositories/auth_repository_impl.dart`
- [ ] **Presentation Layer**
  - `providers/auth_provider.dart`
  - `screens/login_screen.dart`
  - `screens/register_screen.dart`
  - `widgets/auth_text_field.dart`

### Priority 4: Menu Feature
- [ ] Domain, Data, Presentation layers
- [ ] Menu list with categories
- [ ] Menu item details

### Priority 5: Reservations Feature
- [ ] Complete booking flow
- [ ] Date/time selection
- [ ] My reservations dashboard
- [ ] Edit/cancel functionality

### Priority 6: Back Office Feature
- [ ] Admin dashboard
- [ ] Reservation management
- [ ] Validate/refuse actions

## 🛠️ Development Commands

```bash
# Install dependencies
flutter pub get

# Generate code (Riverpod, Freezed, JSON)
dart run build_runner build --delete-conflicting-outputs

# Watch for changes
dart run build_runner watch --delete-conflicting-outputs

# Clean build
flutter clean && flutter pub get

# Analyze code
flutter analyze

# Run tests
flutter test

# Build APK
flutter build apk

# Build for iOS
flutter build ios
```

## 📦 Key Dependencies

```yaml
# State Management
flutter_riverpod: ^2.5.1
riverpod_annotation: ^2.3.5

# Code Generation
freezed_annotation: ^2.4.4
json_annotation: ^4.9.0

# Routing
go_router: ^14.2.7

# HTTP & API
dio: ^5.7.0
pretty_dio_logger: ^1.4.0

# Storage
flutter_secure_storage: ^9.2.2
shared_preferences: ^2.3.2

# UI Components
gap: ^3.0.1
flutter_hooks: ^0.20.5
shimmer: ^3.0.0

# Date & Time
intl: ^0.19.0
table_calendar: ^3.1.2

# Utils
dartz: ^0.10.1
logger: ^2.4.0
```

## 🎯 Code Quality Standards

### Implemented
- ✅ Clean Architecture separation
- ✅ Null safety throughout
- ✅ Immutable data classes (Freezed)
- ✅ Functional error handling (Either/Result)
- ✅ Comprehensive logging
- ✅ Type safety (no dynamic)
- ✅ Strict linting rules
- ✅ Material 3 design system
- ✅ Responsive design ready
- ✅ Dark mode support

### Best Practices
- Use `const` constructors everywhere possible
- Follow Dart naming conventions
- Write dartdoc comments for public APIs
- Handle all error cases
- Provide loading states
- Use code generation (@riverpod, @freezed)
- Keep widgets small and focused
- Separate business logic from UI

## 📚 Resources

- [Flutter Documentation](https://docs.flutter.dev)
- [Riverpod Documentation](https://riverpod.dev)
- [Material Design 3](https://m3.material.io)
- [Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [Freezed Package](https://pub.dev/packages/freezed)
- [Dartz Package](https://pub.dev/packages/dartz)

## 🤝 Contributing

When implementing new features:

1. Follow the existing architecture patterns
2. Use Riverpod for state management
3. Implement all three layers (Domain, Data, Presentation)
4. Add proper error handling
5. Include loading states
6. Write tests
7. Run `flutter analyze` before committing
8. Generate code: `dart run build_runner build`

## 📄 License

This project is for educational purposes as part of the ESGI M2 curriculum.

## 🎓 Author

Kevin Carttigueane - ESGI M2

---

**Status**: 🟡 **Foundation Complete** - Ready for feature implementation

**Current Version**: 1.0.0+1

**Last Updated**: January 2025
