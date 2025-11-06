import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:restaurant_reservation/core/constants/app_constants.dart';
import 'package:restaurant_reservation/core/router/app_router.dart';
import 'package:restaurant_reservation/core/router/route_names.dart';
import 'package:restaurant_reservation/core/theme/app_theme.dart';
import 'package:restaurant_reservation/features/auth/domain/entities/user.dart';
import 'package:restaurant_reservation/features/auth/presentation/providers/auth_providers.dart';

/// Root application widget.
///
/// Sets up Material App with theme and router.
class RestaurantApp extends ConsumerWidget {
  const RestaurantApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,

      // Theme configuration
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,

      // Router configuration
      routerConfig: router,
    );
  }
}

/// Temporary home screen for testing auth functionality.
///
/// Displays current auth state and provides navigation to test routes.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final currentUser = authState.value;
    final isAuthenticated = currentUser != null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Restaurant Reservation'),
        centerTitle: true,
        actions: [
          if (isAuthenticated)
            IconButton(
              icon: const Icon(Icons.person),
              onPressed: () => context.push(RouteNames.profile),
              tooltip: 'Profile',
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // App Icon
            Icon(
              Icons.restaurant_menu,
              size: 80,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 24),

            // Welcome Text
            Text(
              'Welcome to Very Dark Kitchen',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            // Auth Status Card
            authState.when(
              data: (user) => _AuthStatusCard(
                isAuthenticated: user != null,
                user: user,
                isLoading: false,
                error: null,
              ),
              loading: () => _AuthStatusCard(
                isAuthenticated: false,
                user: null,
                isLoading: true,
                error: null,
              ),
              error: (error, _) => _AuthStatusCard(
                isAuthenticated: false,
                user: null,
                isLoading: false,
                error: error.toString(),
              ),
            ),
            const SizedBox(height: 32),

            // Navigation Section
            Text(
              'Test Navigation',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),

            // Auth Routes
            _SectionHeader(title: 'Authentication'),
            const SizedBox(height: 8),
            _NavigationButton(
              icon: Icons.login,
              label: 'Login',
              onPressed: () => context.push(RouteNames.login),
            ),
            const SizedBox(height: 8),
            _NavigationButton(
              icon: Icons.person_add,
              label: 'Register',
              onPressed: () => context.push(RouteNames.register),
            ),
            const SizedBox(height: 8),
            _NavigationButton(
              icon: Icons.person,
              label: 'Profile',
              onPressed: () => context.push(RouteNames.profile),
              enabled: isAuthenticated,
            ),
            const SizedBox(height: 24),

            // Menu Routes
            _SectionHeader(title: 'Menu (Public)'),
            const SizedBox(height: 8),
            _NavigationButton(
              icon: Icons.restaurant,
              label: 'Menu',
              onPressed: () => context.push(RouteNames.menu),
            ),
            const SizedBox(height: 24),

            // Reservation Routes
            _SectionHeader(title: 'Reservations (Protected)'),
            const SizedBox(height: 8),
            _NavigationButton(
              icon: Icons.calendar_today,
              label: 'My Reservations',
              onPressed: () => context.push(RouteNames.reservations),
              enabled: isAuthenticated,
            ),
            const SizedBox(height: 8),
            _NavigationButton(
              icon: Icons.add_circle,
              label: 'New Reservation',
              onPressed: () => context.push(RouteNames.newReservation),
              enabled: isAuthenticated,
            ),
            const SizedBox(height: 24),

            // Back Office Routes
            _SectionHeader(title: 'Back Office (Admin Only)'),
            const SizedBox(height: 8),
            _NavigationButton(
              icon: Icons.admin_panel_settings,
              label: 'Back Office',
              onPressed: () => context.push(RouteNames.backOffice),
              enabled: isAuthenticated && (currentUser?.isAdmin == true),
            ),

            const SizedBox(height: 32),

            // Logout Button
            if (isAuthenticated)
              FilledButton.icon(
                onPressed: () async {
                  await ref.read(authStateProvider.notifier).logout();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Logged out successfully')),
                    );
                  }
                },
                icon: const Icon(Icons.logout),
                label: const Text('Logout'),
                style: FilledButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.error,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Displays current auth state information.
class _AuthStatusCard extends StatelessWidget {
  const _AuthStatusCard({
    required this.isAuthenticated,
    required this.user,
    required this.isLoading,
    required this.error,
  });

  final bool isAuthenticated;
  final User? user;
  final bool isLoading;
  final String? error;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  isAuthenticated ? Icons.check_circle : Icons.cancel,
                  color: isAuthenticated
                      ? theme.colorScheme.primary
                      : theme.colorScheme.error,
                ),
                const SizedBox(width: 8),
                Text(
                  'Auth Status',
                  style: theme.textTheme.titleMedium,
                ),
              ],
            ),
            const Divider(height: 24),
            _InfoRow(
              label: 'Status',
              value: isAuthenticated ? 'Authenticated' : 'Not Authenticated',
              valueColor: isAuthenticated
                  ? theme.colorScheme.primary
                  : theme.colorScheme.error,
            ),
            if (user != null) ...[
              const SizedBox(height: 8),
              _InfoRow(label: 'Name', value: user!.fullName),
              const SizedBox(height: 8),
              _InfoRow(label: 'Email', value: user!.email),
              const SizedBox(height: 8),
              _InfoRow(label: 'Role', value: user!.role.value),
            ],
            if (isLoading) ...[
              const SizedBox(height: 16),
              const LinearProgressIndicator(),
            ],
            if (error != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: theme.colorScheme.errorContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  error!,
                  style: TextStyle(color: theme.colorScheme.onErrorContainer),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Information row widget.
class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.label,
    required this.value,
    this.valueColor,
  });

  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '$label:',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: valueColor,
              ),
        ),
      ],
    );
  }
}

/// Section header widget.
class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
    );
  }
}

/// Navigation button widget.
class _NavigationButton extends StatelessWidget {
  const _NavigationButton({
    required this.icon,
    required this.label,
    required this.onPressed,
    this.enabled = true,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: enabled ? onPressed : null,
      icon: Icon(icon),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.all(16),
      ),
    );
  }
}
