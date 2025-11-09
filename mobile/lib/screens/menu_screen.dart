import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../theme/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';
import '../models/plat.dart';
import '../widgets/loading_shimmer.dart';
import '../widgets/empty_state.dart';
import '../widgets/custom_snackbar.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen>
    with SingleTickerProviderStateMixin {
  final _apiService = ApiService();
  List<Plat> _plats = [];
  final List<Plat> _selectedPlats = [];
  bool _isLoading = true;
  String? _error;
  String? _userRole;
  String _selectedCategory = 'Tous';
  late AnimationController _fabAnimationController;

  final List<String> _categories = [
    'Tous',
    'ENTREE',
    'PLAT_PRINCIPAL',
    'DESSERT',
    'BOISSON',
  ];

  final Map<String, String> _categoryLabels = {
    'Tous': 'Tous',
    'ENTREE': 'Entrées',
    'PLAT_PRINCIPAL': 'Plats',
    'DESSERT': 'Desserts',
    'BOISSON': 'Boissons',
  };

  final Map<String, IconData> _categoryIcons = {
    'Tous': Icons.restaurant_menu,
    'ENTREE': Icons.soup_kitchen,
    'PLAT_PRINCIPAL': Icons.dinner_dining,
    'DESSERT': Icons.cake,
    'BOISSON': Icons.local_cafe,
  };

  @override
  void initState() {
    super.initState();
    _fabAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _loadMenu();
    _loadUserRole();
  }

  @override
  void dispose() {
    _fabAnimationController.dispose();
    super.dispose();
  }

  Future<void> _loadUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userRole = prefs.getString('role') ?? 'USER';
    });
  }

  Future<void> _loadMenu() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final plats = await _apiService.getMenu();
      setState(() {
        _plats = plats;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _togglePlatSelection(Plat plat) {
    setState(() {
      if (_selectedPlats.contains(plat)) {
        _selectedPlats.remove(plat);
        if (_selectedPlats.isEmpty) {
          _fabAnimationController.reverse();
        }
      } else {
        if (_selectedPlats.isEmpty) {
          _fabAnimationController.forward();
        }
        _selectedPlats.add(plat);
      }
    });
  }

  Future<void> _navigateToReservation() async {
    final isLoggedIn = await _apiService.isLoggedIn();
    if (!mounted) return;

    if (!isLoggedIn) {
      CustomSnackbar.show(
        context,
        message: 'Veuillez vous connecter pour réserver',
        type: SnackbarType.warning,
        action: SnackBarAction(
          label: 'Connexion',
          textColor: Colors.white,
          onPressed: () => Navigator.pushNamed(context, '/login'),
        ),
      );
      return;
    }

    if (_selectedPlats.isEmpty) {
      CustomSnackbar.info(context, 'Sélectionnez au moins un plat');
      return;
    }

    Navigator.pushNamed(
      context,
      '/reservation',
      arguments: _selectedPlats.map((p) => p.id).toList(),
    );
  }

  List<Plat> get _filteredPlats {
    if (_selectedCategory == 'Tous') {
      return _plats;
    }
    return _plats.where((plat) => plat.categorie == _selectedCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Modern App Bar
          SliverAppBar.large(
            floating: true,
            pinned: true,
            expandedHeight: 140,
            backgroundColor: colorScheme.primary,
            foregroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'Very Dark Kitchen',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      colorScheme.primary,
                      colorScheme.primary.withValues(alpha: 0.8),
                    ],
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.restaurant,
                    size: 80,
                    color: Colors.white.withValues(alpha: 0.1),
                  ),
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.event),
                tooltip: 'Mes réservations',
                onPressed: () =>
                    Navigator.pushNamed(context, '/my-reservations'),
              ),
              IconButton(
                icon: const Icon(Icons.person),
                tooltip: 'Mon profil',
                onPressed: () => Navigator.pushNamed(context, '/profile'),
              ),
            ],
          ),

          // Category Filters
          SliverToBoxAdapter(
            child: Container(
              height: 60,
              margin: const EdgeInsets.symmetric(vertical: AppTheme.spaceSm),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spaceMd,
                ),
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final category = _categories[index];
                  final isSelected = _selectedCategory == category;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      selected: isSelected,
                      label: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _categoryIcons[category],
                            size: 18,
                            color: isSelected
                                ? Colors.white
                                : colorScheme.primary,
                          ),
                          const SizedBox(width: 8),
                          Text(_categoryLabels[category]!),
                        ],
                      ),
                      onSelected: (selected) {
                        setState(() => _selectedCategory = category);
                      },
                      backgroundColor: colorScheme.surface,
                      selectedColor: colorScheme.primary,
                      labelStyle: TextStyle(
                        color: isSelected
                            ? Colors.white
                            : colorScheme.onSurface,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // Selected Items Summary
          if (_selectedPlats.isNotEmpty)
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spaceMd,
                  vertical: AppTheme.spaceSm,
                ),
                padding: const EdgeInsets.all(AppTheme.spaceMd),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                ),
                child: Row(
                  children: [
                    Icon(Icons.shopping_bag, color: colorScheme.primary),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        '${_selectedPlats.length} plat${_selectedPlats.length > 1 ? 's' : ''} sélectionné${_selectedPlats.length > 1 ? 's' : ''}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ),
                    if (_selectedPlats.isNotEmpty)
                      TextButton.icon(
                        onPressed: () {
                          setState(() => _selectedPlats.clear());
                          _fabAnimationController.reverse();
                        },
                        icon: const Icon(Icons.clear),
                        label: const Text('Vider'),
                      ),
                  ],
                ),
              ),
            ),

          // Content
          if (_isLoading)
            const SliverFillRemaining(child: MenuGridShimmer())
          else if (_error != null)
            SliverFillRemaining(
              child: ErrorState(message: _error!, onRetry: _loadMenu),
            )
          else if (_filteredPlats.isEmpty)
            SliverFillRemaining(
              child: EmptyState(
                icon: Icons.restaurant,
                title: 'Aucun plat disponible',
                message: 'Aucun plat dans cette catégorie pour le moment',
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.all(AppTheme.spaceMd),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: AppTheme.spaceMd,
                  mainAxisSpacing: AppTheme.spaceMd,
                ),
                delegate: SliverChildBuilderDelegate((context, index) {
                  final plat = _filteredPlats[index];
                  final isSelected = _selectedPlats.contains(plat);
                  return AnimationConfiguration.staggeredGrid(
                    position: index,
                    duration: AppTheme.durationNormal,
                    columnCount: 2,
                    child: ScaleAnimation(
                      child: FadeInAnimation(
                        child: _buildPlatCard(plat, isSelected),
                      ),
                    ),
                  );
                }, childCount: _filteredPlats.length),
              ),
            ),
        ],
      ),
      floatingActionButton: ScaleTransition(
        scale: _fabAnimationController,
        child: FloatingActionButton.extended(
          onPressed: _navigateToReservation,
          icon: const Icon(Icons.restaurant),
          label: Text('Réserver (${_selectedPlats.length})'),
        ),
      ),
      drawer: _buildDrawer(),
    );
  }

  Widget _buildPlatCard(Plat plat, bool isSelected) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: isSelected
          ? AppTheme.cardElevation * 2
          : AppTheme.cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
        side: isSelected
            ? BorderSide(color: colorScheme.primary, width: 2)
            : BorderSide.none,
      ),
      child: InkWell(
        onTap: () => _togglePlatSelection(plat),
        borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image or placeholder
            Expanded(
              flex: 3,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      colorScheme.primaryContainer,
                      colorScheme.secondaryContainer,
                    ],
                  ),
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(AppTheme.radiusLarge),
                  ),
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Icon(
                        _categoryIcons[plat.categorie] ?? Icons.restaurant,
                        size: 48,
                        color: Colors.white.withOpacity(0.5),
                      ),
                    ),
                    if (isSelected)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: colorScheme.primary,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    if (!plat.disponible)
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.5),
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(16),
                            ),
                          ),
                          child: Center(
                            child: Chip(
                              label: const Text('Indisponible'),
                              backgroundColor: Theme.of(
                                context,
                              ).colorScheme.error,
                              labelStyle: TextStyle(
                                color: Theme.of(context).colorScheme.onError,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            // Info
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.only(
                  left: AppTheme.spaceMd,
                  right: AppTheme.spaceMd,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      plat.nom,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      plat.description,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Text(
                          '${plat.prix.toStringAsFixed(2)} €',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.primaryContainer,
                ],
              ),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(Icons.restaurant, size: 48, color: Colors.white),
                SizedBox(height: 8),
                Text(
                  'Very Dark Kitchen',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.restaurant_menu),
            title: const Text('Menu'),
            onTap: () => Navigator.pop(context),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Mon Profil'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/profile');
            },
          ),
          ListTile(
            leading: const Icon(Icons.event),
            title: const Text('Mes Réservations'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/my-reservations');
            },
          ),
          if (_userRole == 'ADMIN') ...[
            const Divider(),
            ListTile(
              leading: const Icon(Icons.admin_panel_settings),
              title: const Text('Gestion Réservations'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/admin-reservations');
              },
            ),
          ],
          const Divider(),
          ListTile(
            leading: const Icon(Icons.login),
            title: const Text('Connexion'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/login');
            },
          ),
        ],
      ),
    );
  }
}
