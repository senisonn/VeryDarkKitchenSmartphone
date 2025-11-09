import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../models/reservation.dart';
import '../services/api_service.dart';
import '../theme/app_theme.dart';
import '../widgets/loading_shimmer.dart';
import '../widgets/empty_state.dart';
import '../widgets/status_badge.dart';
import '../widgets/custom_snackbar.dart';

class MyReservationsScreen extends StatefulWidget {
  const MyReservationsScreen({super.key});

  @override
  State<MyReservationsScreen> createState() => _MyReservationsScreenState();
}

class _MyReservationsScreenState extends State<MyReservationsScreen> {
  final ApiService _apiService = ApiService();
  List<ReservationResponse> _reservations = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadReservations();
  }

  Future<void> _loadReservations() async {
    setState(() => _isLoading = true);
    try {
      final reservations = await _apiService.getUserReservations();
      if (mounted) {
        setState(() {
          _reservations = reservations;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        CustomSnackbar.error(context, 'Erreur: ${e.toString()}');
      }
    }
  }

  Future<void> _cancelReservation(int reservationId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmer l\'annulation'),
        content: const Text('Voulez-vous vraiment annuler cette réservation?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Non'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Oui'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await _apiService.cancelReservation(reservationId);
        if (mounted) {
          CustomSnackbar.success(context, 'Réservation annulée avec succès');
        }
        _loadReservations();
      } catch (e) {
        if (mounted) {
          CustomSnackbar.error(context, 'Erreur: ${e.toString()}');
        }
      }
    }
  }

  void _editReservation(ReservationResponse reservation) {
    Navigator.pushNamed(
      context,
      '/edit-reservation',
      arguments: reservation,
    ).then((_) => _loadReservations());
  }


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes Réservations'),
        backgroundColor: colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const ReservationListShimmer()
          : _reservations.isEmpty
              ? EmptyState(
                  icon: Icons.event_busy,
                  title: 'Aucune réservation',
                  message: 'Vous n\'avez pas encore de réservation.\nCommencez par parcourir notre menu!',
                  actionLabel: 'Voir le menu',
                  onActionPressed: () => Navigator.pushReplacementNamed(context, '/menu'),
                )
              : RefreshIndicator(
                  onRefresh: _loadReservations,
                  child: AnimationLimiter(
                    child: ListView.builder(
                      itemCount: _reservations.length,
                      padding: const EdgeInsets.all(AppTheme.spaceMd),
                      itemBuilder: (context, index) {
                        final reservation = _reservations[index];
                        final dateFormat = DateFormat('dd/MM/yyyy HH:mm');
                        final canEdit = reservation.statut == 'EN_ATTENTE';

                        return AnimationConfiguration.staggeredList(
                          position: index,
                          duration: AppTheme.durationNormal,
                          child: SlideAnimation(
                            verticalOffset: 50.0,
                            child: FadeInAnimation(
                              child: Card(
                                margin: const EdgeInsets.only(bottom: AppTheme.spaceMd),
                                elevation: AppTheme.elevationMd,
                                child: Padding(
                                  padding: const EdgeInsets.all(AppTheme.spaceMd),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Header with ID and Status
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Réservation #${reservation.id}',
                                            style: theme.textTheme.titleLarge?.copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          StatusBadge(status: reservation.statut),
                                        ],
                                      ),
                                      const Divider(height: AppTheme.spaceLg),

                                      // Date and Time
                                      _buildInfoRow(
                                        icon: Icons.calendar_today,
                                        label: dateFormat.format(reservation.dateReservation),
                                        theme: theme,
                                      ),
                                      const SizedBox(height: AppTheme.spaceSm),

                                      // Number of people
                                      _buildInfoRow(
                                        icon: Icons.people,
                                        label: '${reservation.nombrePersonnes} personne${reservation.nombrePersonnes > 1 ? 's' : ''}',
                                        theme: theme,
                                      ),
                                      const SizedBox(height: AppTheme.spaceSm),

                                      // Email
                                      _buildInfoRow(
                                        icon: Icons.email,
                                        label: reservation.email,
                                        theme: theme,
                                      ),
                                      const SizedBox(height: AppTheme.spaceSm),

                                      // Phone
                                      _buildInfoRow(
                                        icon: Icons.phone,
                                        label: reservation.telephone,
                                        theme: theme,
                                      ),

                                      // Comment (if any)
                                      if (reservation.commentaire != null) ...[
                                        const SizedBox(height: AppTheme.spaceSm),
                                        _buildInfoRow(
                                          icon: Icons.comment,
                                          label: reservation.commentaire!,
                                          theme: theme,
                                        ),
                                      ],

                                      // Action Buttons (if editable)
                                      if (canEdit) ...[
                                        const SizedBox(height: AppTheme.spaceMd),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            OutlinedButton.icon(
                                              onPressed: () => _editReservation(reservation),
                                              icon: const Icon(Icons.edit),
                                              label: const Text('Modifier'),
                                            ),
                                            const SizedBox(width: AppTheme.spaceSm),
                                            FilledButton.tonalIcon(
                                              onPressed: () => _cancelReservation(reservation.id),
                                              icon: const Icon(Icons.cancel),
                                              label: const Text('Annuler'),
                                              style: FilledButton.styleFrom(
                                                backgroundColor: colorScheme.errorContainer,
                                                foregroundColor: colorScheme.error,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required ThemeData theme,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: AppTheme.iconSm,
          color: theme.colorScheme.primary,
        ),
        const SizedBox(width: AppTheme.spaceMd),
        Expanded(
          child: Text(
            label,
            style: theme.textTheme.bodyLarge,
          ),
        ),
      ],
    );
  }
}
