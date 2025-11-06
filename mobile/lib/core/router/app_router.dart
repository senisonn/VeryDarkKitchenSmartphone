import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:restaurant_reservation/core/router/route_names.dart';
import 'package:restaurant_reservation/core/utils/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_router.g.dart';

/// Provides the GoRouter instance for the app.
@riverpod
// ignore: prefer_expression_function_bodies
GoRouter router(RouterRef ref) {
  // Watch auth state to rebuild router when auth changes
  // This will be implemented when we add the auth provider
  // final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: RouteNames.menu,
    debugLogDiagnostics: true,
    observers: [_RouterObserver()],

    // Redirect logic for auth guards
    redirect: (context, state) {
      // Get current auth state
      // For now, we'll allow all routes
      // This will be updated when auth is implemented

      final isLoginRoute = state.matchedLocation == RouteNames.login;
      final isRegisterRoute = state.matchedLocation == RouteNames.register;
      final isPublicRoute = isLoginRoute ||
          isRegisterRoute ||
          state.matchedLocation == RouteNames.menu ||
          state.matchedLocation.startsWith('/menu/');

      // TODO: Implement auth check
      // final isAuthenticated = authState.isAuthenticated;

      // Example redirect logic (will be activated with auth):
      // if (!isAuthenticated && !isPublicRoute) {
      //   return RouteNames.login;
      // }
      // if (isAuthenticated && (isLoginRoute || isRegisterRoute)) {
      //   return RouteNames.menu;
      // }

      return null; // No redirect
    },

    routes: [
      // Menu Routes (Public)
      GoRoute(
        path: RouteNames.menu,
        name: 'menu',
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const _PlaceholderScreen(title: 'Menu'),
        ),
      ),
      GoRoute(
        path: RouteNames.menuItem,
        name: 'menuItem',
        pageBuilder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return MaterialPage(
            key: state.pageKey,
            child: _PlaceholderScreen(title: 'Menu Item: $id'),
          );
        },
      ),

      // Auth Routes
      GoRoute(
        path: RouteNames.login,
        name: 'login',
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const _PlaceholderScreen(title: 'Login'),
        ),
      ),
      GoRoute(
        path: RouteNames.register,
        name: 'register',
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const _PlaceholderScreen(title: 'Register'),
        ),
      ),
      GoRoute(
        path: RouteNames.profile,
        name: 'profile',
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const _PlaceholderScreen(title: 'Profile'),
        ),
      ),

      // Reservation Routes (Protected)
      GoRoute(
        path: RouteNames.reservations,
        name: 'reservations',
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const _PlaceholderScreen(title: 'My Reservations'),
        ),
      ),
      GoRoute(
        path: RouteNames.newReservation,
        name: 'newReservation',
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const _PlaceholderScreen(title: 'New Reservation'),
        ),
      ),
      GoRoute(
        path: RouteNames.reservationDetails,
        name: 'reservationDetails',
        pageBuilder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return MaterialPage(
            key: state.pageKey,
            child: _PlaceholderScreen(title: 'Reservation: $id'),
          );
        },
      ),

      // Back Office Routes (Protected - Admin only)
      GoRoute(
        path: RouteNames.backOffice,
        name: 'backOffice',
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const _PlaceholderScreen(title: 'Back Office'),
        ),
      ),
      GoRoute(
        path: RouteNames.backOfficeReservations,
        name: 'backOfficeReservations',
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const _PlaceholderScreen(title: 'All Reservations'),
        ),
      ),

      // Root - redirect to menu
      GoRoute(
        path: RouteNames.root,
        redirect: (context, state) => RouteNames.menu,
      ),
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
