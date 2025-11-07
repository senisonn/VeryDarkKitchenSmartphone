import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:restaurant_reservation/app.dart';
import 'package:restaurant_reservation/core/router/route_names.dart';
import 'package:restaurant_reservation/core/utils/logger.dart';
import 'package:restaurant_reservation/features/auth/presentation/providers/auth_providers.dart';
import 'package:restaurant_reservation/features/auth/presentation/screens/login_screen.dart';
import 'package:restaurant_reservation/features/auth/presentation/screens/profile_screen.dart';
import 'package:restaurant_reservation/features/auth/presentation/screens/register_screen.dart';
import 'package:restaurant_reservation/features/back_office/presentation/screens/all_reservations_screen.dart';
import 'package:restaurant_reservation/features/back_office/presentation/screens/back_office_dashboard_screen.dart';
import 'package:restaurant_reservation/features/menu/presentation/screens/menu_detail_screen.dart';
import 'package:restaurant_reservation/features/menu/presentation/screens/menu_screen.dart';
import 'package:restaurant_reservation/features/reservations/presentation/screens/edit_reservation_screen.dart';
import 'package:restaurant_reservation/features/reservations/presentation/screens/my_reservations_screen.dart';
import 'package:restaurant_reservation/features/reservations/presentation/screens/reservation_detail_screen.dart';
import 'package:restaurant_reservation/features/reservations/presentation/screens/reservation_flow_screen.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_router.g.dart';

/// Provides the GoRouter instance for the app.
@riverpod
GoRouter router(RouterRef ref) {
  // Watch auth state to rebuild router when auth changes
  final authState = ref.watch(authStateProvider);
  final isAuthenticated = authState.value != null;

  return GoRouter(
    initialLocation: RouteNames.root,
    debugLogDiagnostics: true,
    observers: [_RouterObserver()],

    // Redirect logic for auth guards
    redirect: (context, state) {
      final currentLocation = state.matchedLocation;

      // Define public routes
      final publicRoutes = [
        RouteNames.root,
        RouteNames.login,
        RouteNames.register,
        RouteNames.menu,
      ];

      final isPublicRoute = publicRoutes.contains(currentLocation) ||
          currentLocation.startsWith('/menu/');

      // Redirect to login if trying to access protected route while not authenticated
      if (!isAuthenticated && !isPublicRoute) {
        return RouteNames.login;
      }

      // Redirect to home if authenticated user tries to access login/register
      if (isAuthenticated &&
          (currentLocation == RouteNames.login ||
              currentLocation == RouteNames.register)) {
        return RouteNames.root;
      }

      return null; // No redirect
    },

    routes: [
      // Root - Home Screen
      GoRoute(
        path: RouteNames.root,
        name: 'home',
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const HomeScreen(),
        ),
      ),

      // Auth Routes
      GoRoute(
        path: RouteNames.login,
        name: 'login',
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const LoginScreen(),
        ),
      ),
      GoRoute(
        path: RouteNames.register,
        name: 'register',
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const RegisterScreen(),
        ),
      ),
      GoRoute(
        path: RouteNames.profile,
        name: 'profile',
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const ProfileScreen(),
        ),
      ),

      // Menu Routes (Public)
      GoRoute(
        path: RouteNames.menu,
        name: 'menu',
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const MenuScreen(),
        ),
      ),
      GoRoute(
        path: RouteNames.menuItem,
        name: 'menuItem',
        pageBuilder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return MaterialPage(
            key: state.pageKey,
            child: MenuDetailScreen(itemId: id),
          );
        },
      ),

      // Reservation Routes (Protected)
      GoRoute(
        path: RouteNames.reservations,
        name: 'reservations',
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const MyReservationsScreen(),
        ),
      ),
      GoRoute(
        path: RouteNames.newReservation,
        name: 'newReservation',
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const ReservationFlowScreen(),
        ),
      ),
      GoRoute(
        path: RouteNames.reservationDetails,
        name: 'reservationDetails',
        pageBuilder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return MaterialPage(
            key: state.pageKey,
            child: ReservationDetailScreen(reservationId: id),
          );
        },
      ),
      GoRoute(
        path: RouteNames.editReservation,
        name: 'editReservation',
        pageBuilder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return MaterialPage(
            key: state.pageKey,
            child: EditReservationScreen(reservationId: id),
          );
        },
      ),

      // Back Office Routes (Protected - Admin only)
      GoRoute(
        path: RouteNames.backOffice,
        name: 'backOffice',
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const BackOfficeDashboardScreen(),
        ),
      ),
      GoRoute(
        path: RouteNames.backOfficeReservations,
        name: 'backOfficeReservations',
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const AllReservationsScreen(),
        ),
      ),

      // Root - redirect handled by root route above
    ],

    // Error handler
    errorBuilder: (context, state) => _ErrorScreen(error: state.error),
  );
}

/// Router observer for logging navigation events.
class _RouterObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    AppLogger.logNavigation(
      previousRoute?.settings.name ?? 'none',
      route.settings.name ?? 'unknown',
    );
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    AppLogger.logNavigation(
      route.settings.name ?? 'unknown',
      previousRoute?.settings.name ?? 'none',
    );
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    AppLogger.logNavigation(
      oldRoute?.settings.name ?? 'none',
      newRoute?.settings.name ?? 'unknown',
    );
  }
}

/// Placeholder screen for routes not yet implemented.
class _PlaceholderScreen extends StatelessWidget {
  const _PlaceholderScreen({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.construction,
              size: 64,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'This screen is under construction',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => context.go(RouteNames.menu),
              icon: const Icon(Icons.home),
              label: const Text('Go to Menu'),
            ),
          ],
        ),
      ),
    );
}

/// Error screen for navigation errors.
class _ErrorScreen extends StatelessWidget {
  const _ErrorScreen({this.error});

  final Exception? error;

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: const Text('Error'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Page Not Found',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            if (error != null)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  error.toString(),
                  style: Theme.of(context).textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
              ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => context.go(RouteNames.menu),
              icon: const Icon(Icons.home),
              label: const Text('Go Home'),
            ),
          ],
        ),
      ),
    );
}
