import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/api_service.dart';
import '../models/reservation.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_snackbar.dart';

class ReservationScreen extends StatefulWidget {
  const ReservationScreen({super.key});

  @override
  State<ReservationScreen> createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _telephoneController = TextEditingController();
  final _commentaireController = TextEditingController();
  final _apiService = ApiService();

  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  TimeOfDay _selectedTime = const TimeOfDay(hour: 12, minute: 0);
  int _nombrePersonnes = 2;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _telephoneController.dispose();
    _commentaireController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().add(const Duration(hours: 1)), // At least 1 hour from now
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  Future<void> _submitReservation() async {
    if (!_formKey.currentState!.validate()) return;

    // Get arguments before any async operations to avoid context issues
    final platIds = ModalRoute.of(context)!.settings.arguments as List<int>;

    setState(() => _isLoading = true);

    try {
      final userId = await _apiService.getUserId();
      if (userId == null) {
        throw Exception('Utilisateur non connecté');
      }

      final dateReservation = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        _selectedTime.hour,
        _selectedTime.minute,
      );

      // Validate that the reservation date is in the future
      if (dateReservation.isBefore(DateTime.now())) {
        throw Exception('La date de réservation doit être dans le futur');
      }

      final request = ReservationRequest(
        idClient: userId,
        email: _emailController.text.trim(),
        telephone: _telephoneController.text.trim(),
        dateReservation: dateReservation,
        nombrePersonnes: _nombrePersonnes,
        platIds: platIds,
        commentaire: _commentaireController.text.isEmpty
            ? null
            : _commentaireController.text,
      );

      await _apiService.createReservation(request);

      if (mounted) {
        CustomSnackbar.success(context, 'Réservation créée avec succès!');
        Navigator.pushNamedAndRemoveUntil(context, '/menu', (route) => false);
      }
    } catch (e) {
      if (mounted) {
        final errorMessage = e.toString().replaceFirst('Exception: ', '');
        print('Full error in reservation screen: $errorMessage');

        // Show detailed error to user
        CustomSnackbar.error(
          context,
          errorMessage.length > 100
            ? '${errorMessage.substring(0, 100)}...'
            : errorMessage,
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nouvelle Réservation'),
        backgroundColor: colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.spaceMd),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Card
              Card(
                color: colorScheme.primaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(AppTheme.spaceMd),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: colorScheme.primary,
                      ),
                      const SizedBox(width: AppTheme.spaceMd),
                      Expanded(
                        child: Text(
                          'Remplissez les informations ci-dessous pour confirmer votre réservation',
                          style: theme.textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppTheme.spaceLg),

              // Contact Information Section
              Text(
                'Informations de contact',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppTheme.spaceMd),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  hintText: 'votre@email.com',
                  prefixIcon: Icon(Icons.email_outlined),
                ),
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer votre email';
                  }
                  if (!value.contains('@')) {
                    return 'Veuillez entrer un email valide';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppTheme.spaceMd),
              TextFormField(
                controller: _telephoneController,
                decoration: const InputDecoration(
                  labelText: 'Téléphone',
                  hintText: '+33 6 12 34 56 78',
                  prefixIcon: Icon(Icons.phone_outlined),
                ),
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer votre téléphone';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppTheme.spaceLg),

              // Date and Time Section
              Text(
                'Date et heure',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppTheme.spaceMd),
              Row(
                children: [
                  Expanded(
                    child: Card(
                      child: InkWell(
                        onTap: _selectDate,
                        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
                        child: Padding(
                          padding: const EdgeInsets.all(AppTheme.spaceMd),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.calendar_today, color: colorScheme.primary),
                                  const SizedBox(width: AppTheme.spaceSm),
                                  Text(
                                    'Date',
                                    style: theme.textTheme.labelLarge,
                                  ),
                                ],
                              ),
                              const SizedBox(height: AppTheme.spaceSm),
                              Text(
                                DateFormat('dd/MM/yyyy').format(_selectedDate),
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppTheme.spaceMd),
                  Expanded(
                    child: Card(
                      child: InkWell(
                        onTap: _selectTime,
                        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
                        child: Padding(
                          padding: const EdgeInsets.all(AppTheme.spaceMd),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.access_time, color: colorScheme.primary),
                                  const SizedBox(width: AppTheme.spaceSm),
                                  Text(
                                    'Heure',
                                    style: theme.textTheme.labelLarge,
                                  ),
                                ],
                              ),
                              const SizedBox(height: AppTheme.spaceSm),
                              Text(
                                _selectedTime.format(context),
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppTheme.spaceLg),

              // Number of People Section
              Text(
                'Nombre de personnes',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppTheme.spaceMd),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppTheme.spaceMd),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton.filled(
                        icon: const Icon(Icons.remove),
                        onPressed: _nombrePersonnes > 1
                            ? () => setState(() => _nombrePersonnes--)
                            : null,
                        style: IconButton.styleFrom(
                          backgroundColor: colorScheme.primaryContainer,
                          foregroundColor: colorScheme.onPrimaryContainer,
                        ),
                      ),
                      Column(
                        children: [
                          Text(
                            '$_nombrePersonnes',
                            style: theme.textTheme.displaySmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.primary,
                            ),
                          ),
                          Text(
                            'personne${_nombrePersonnes > 1 ? 's' : ''}',
                            style: theme.textTheme.bodyMedium,
                          ),
                        ],
                      ),
                      IconButton.filled(
                        icon: const Icon(Icons.add),
                        onPressed: _nombrePersonnes < 20
                            ? () => setState(() => _nombrePersonnes++)
                            : null,
                        style: IconButton.styleFrom(
                          backgroundColor: colorScheme.primaryContainer,
                          foregroundColor: colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppTheme.spaceLg),

              // Comment Section
              Text(
                'Commentaire (optionnel)',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppTheme.spaceMd),
              TextFormField(
                controller: _commentaireController,
                decoration: const InputDecoration(
                  labelText: 'Commentaire',
                  hintText: 'Allergies, préférences...',
                  alignLabelWithHint: true,
                  prefixIcon: Padding(
                    padding: EdgeInsets.only(bottom: 60),
                    child: Icon(Icons.comment_outlined),
                  ),
                ),
                maxLines: 4,
              ),
              const SizedBox(height: AppTheme.spaceXl),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _isLoading ? null : _submitReservation,
                  icon: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.check_circle),
                  label: Text(
                    _isLoading ? 'Création en cours...' : 'Confirmer la réservation',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppTheme.spaceMd),
            ],
          ),
        ),
      ),
    );
  }
}
