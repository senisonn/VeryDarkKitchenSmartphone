import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ApiService _apiService = ApiService();

  String? _username;
  String? _email;
  String? _role;
  int _totalReservations = 0;
  int _activeReservations = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('userId');

      setState(() {
        _username = prefs.getString('username') ?? 'Utilisateur';
        _email = prefs.getString('email') ?? '';
        _role = prefs.getString('role') ?? 'USER';
      });

      if (userId != null) {
        final reservations = await _apiService.getUserReservations();
        setState(() {
          _totalReservations = reservations.length;
          _activeReservations = reservations
              .where((r) => r.statut == 'EN_ATTENTE' || r.statut == 'CONFIRMEE')
              .length;
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _logout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Déconnexion'),
        content: const Text('Voulez-vous vraiment vous déconnecter ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Déconnexion'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      await _apiService.logout();
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(context, '/menu', (route) => false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Modern App Bar with gradient
          SliverAppBar.large(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'Mon Profil',
                style: TextStyle(
                  color: colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      colorScheme.primary,
                      colorScheme.primaryContainer,
                    ],
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.account_circle,
                    size: 80,
                    color: colorScheme.onPrimary.withValues(alpha: 0.3),
                  ),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: _isLoading
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: CircularProgressIndicator(),
                    ),
                  )
                : Column(
                    children: [
                      const SizedBox(height: 8),

                      // User Info Card
                      _buildInfoCard(
                        context,
                        icon: Icons.person,
                        title: 'Informations',
                        children: [
                          _buildInfoRow(
                            icon: Icons.badge,
                            label: 'Nom d\'utilisateur',
                            value: _username ?? 'Non défini',
                          ),
                          if (_email?.isNotEmpty ?? false)
                            _buildInfoRow(
                              icon: Icons.email,
                              label: 'Email',
                              value: _email!,
                            ),
                          _buildInfoRow(
                            icon: Icons.shield,
                            label: 'Rôle',
                            value: _role == 'ADMIN' ? 'Administrateur' : 'Utilisateur',
                            valueColor: _role == 'ADMIN'
                                ? colorScheme.primary
                                : colorScheme.onSurface,
                          ),
                        ],
                      ),

                      // Stats Card
                      _buildInfoCard(
                        context,
                        icon: Icons.analytics,
                        title: 'Statistiques',
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: _buildStatCard(
                                  context,
                                  icon: Icons.event,
                                  value: _totalReservations.toString(),
                                  label: 'Réservations',
                                  color: colorScheme.primary,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _buildStatCard(
                                  context,
                                  icon: Icons.pending_actions,
                                  value: _activeReservations.toString(),
                                  label: 'En cours',
                                  color: colorScheme.tertiary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      // Actions Card
                      _buildInfoCard(
                        context,
                        icon: Icons.settings,
                        title: 'Actions',
                        children: [
                          _buildActionTile(
                            context,
                            icon: Icons.history,
                            title: 'Mes réservations',
                            subtitle: 'Voir toutes mes réservations',
                            onTap: () {
                              Navigator.pushNamed(context, '/my-reservations');
                            },
                          ),
                          if (_role == 'ADMIN')
                            _buildActionTile(
                              context,
                              icon: Icons.admin_panel_settings,
                              title: 'Administration',
                              subtitle: 'Gérer les réservations',
                              onTap: () {
                                Navigator.pushNamed(context, '/admin-reservations');
                              },
                            ),
                          _buildActionTile(
                            context,
                            icon: Icons.logout,
                            title: 'Déconnexion',
                            subtitle: 'Se déconnecter de l\'application',
                            iconColor: colorScheme.error,
                            onTap: _logout,
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required List<Widget> children,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 0,
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 24),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: valueColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    Color? iconColor,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: (iconColor ?? theme.colorScheme.primary).withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: iconColor ?? theme.colorScheme.primary,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
