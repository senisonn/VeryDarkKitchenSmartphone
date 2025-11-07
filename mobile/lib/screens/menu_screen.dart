import 'package:flutter/material.dart';
import '../services/mock_api_service.dart';
import '../models/plat.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final _apiService = MockApiService();
  List<Plat> _plats = [];
  List<Plat> _selectedPlats = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadMenu();
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
      } else {
        _selectedPlats.add(plat);
      }
    });
  }

  Future<void> _navigateToReservation() async {
    final isLoggedIn = await _apiService.isLoggedIn();
    if (!mounted) return;

    if (!isLoggedIn) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez vous connecter pour faire une réservation'),
        ),
      );
      Navigator.pushNamed(context, '/login');
      return;
    }

    if (_selectedPlats.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez sélectionner au moins un plat'),
        ),
      );
      return;
    }

    Navigator.pushNamed(
      context,
      '/reservation',
      arguments: _selectedPlats.map((p) => p.id).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu du Restaurant'),
        backgroundColor: Colors.deepOrange,
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => Navigator.pushNamed(context, '/login'),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error, size: 64, color: Colors.red),
                      const SizedBox(height: 16),
                      Text('Erreur: $_error'),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadMenu,
                        child: const Text('Réessayer'),
                      ),
                    ],
                  ),
                )
              : _plats.isEmpty
                  ? const Center(
                      child: Text('Aucun plat disponible'),
                    )
                  : Column(
                      children: [
                        if (_selectedPlats.isNotEmpty)
                          Container(
                            color: Colors.deepOrange.shade50,
                            padding: const EdgeInsets.all(8),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    '${_selectedPlats.length} plat(s) sélectionné(s)',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                ElevatedButton.icon(
                                  onPressed: _navigateToReservation,
                                  icon: const Icon(Icons.restaurant_menu),
                                  label: const Text('Réserver'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.deepOrange,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        Expanded(
                          child: RefreshIndicator(
                            onRefresh: _loadMenu,
                            child: ListView.builder(
                              itemCount: _plats.length,
                              padding: const EdgeInsets.all(8),
                              itemBuilder: (context, index) {
                                final plat = _plats[index];
                                final isSelected = _selectedPlats.contains(plat);

                                return Card(
                                  elevation: 2,
                                  margin: const EdgeInsets.symmetric(
                                    vertical: 8,
                                    horizontal: 4,
                                  ),
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      backgroundColor: Colors.deepOrange,
                                      child: Text(
                                        plat.prix.toStringAsFixed(0),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    title: Text(
                                      plat.nom,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 4),
                                        Text(plat.description),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            Chip(
                                              label: Text(
                                                plat.categorie,
                                                style: const TextStyle(fontSize: 12),
                                              ),
                                              backgroundColor:
                                                  Colors.deepOrange.shade100,
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              '${plat.prix.toStringAsFixed(2)} €',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    trailing: Checkbox(
                                      value: isSelected,
                                      onChanged: plat.disponible
                                          ? (_) => _togglePlatSelection(plat)
                                          : null,
                                    ),
                                    enabled: plat.disponible,
                                    isThreeLine: true,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
    );
  }
}
