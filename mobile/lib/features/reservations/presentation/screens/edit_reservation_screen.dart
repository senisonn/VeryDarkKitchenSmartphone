import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/router/route_names.dart';
import '../../domain/entities/reservation.dart';
import '../providers/reservation_providers.dart';
import '../widgets/guest_count_picker.dart';

/// Screen for editing an existing reservation.
class EditReservationScreen extends ConsumerStatefulWidget {
  const EditReservationScreen({
    super.key,
    required this.reservationId,
  });

  final String reservationId;

  @override
  ConsumerState<EditReservationScreen> createState() =>
      _EditReservationScreenState();
}

class _EditReservationScreenState
    extends ConsumerState<EditReservationScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _notesController;
  int _guestCount = 2;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _phoneController = TextEditingController();
    _emailController = TextEditingController();
    _notesController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _initializeFormData(Reservation reservation) {
    _nameController.text = reservation.name ?? '';
    _phoneController.text = reservation.phone ?? '';
    _emailController.text = reservation.email ?? '';
    _notesController.text = reservation.notes ?? '';
    _guestCount = reservation.guests;
  }

  Future<void> _handleSave(Reservation originalReservation) async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);

      try {
        final updateData = {
          'guests': _guestCount,
          if (_nameController.text.isNotEmpty)
            'name': _nameController.text.trim(),
          if (_phoneController.text.isNotEmpty)
            'phone': _phoneController.text.trim(),
          if (_emailController.text.isNotEmpty)
            'email': _emailController.text.trim(),
          if (_notesController.text.isNotEmpty)
            'notes': _notesController.text.trim(),
        };

        final repository = ref.read(reservationRepositoryProvider);
        await repository.updateReservation(widget.reservationId, updateData);

        // Invalidate cache to refresh
        ref.invalidate(userReservationsProvider);
        ref.invalidate(reservationProvider(widget.reservationId));

        if (mounted) {
          context.pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Reservation updated successfully'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error updating reservation: $e'),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final reservationAsync = ref.watch(reservationProvider(widget.reservationId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Reservation'),
      ),
      body: reservationAsync.when(
        data: (reservation) {
          // Initialize form data once
          if (_nameController.text.isEmpty &&
              _phoneController.text.isEmpty &&
              _emailController.text.isEmpty) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _initializeFormData(reservation);
            });
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Info Card - Non-editable reservation info
                  _buildInfoCard(context, reservation),
                  const SizedBox(height: 24),

                  // Editable Fields
                  Text(
                    'Update Details',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),

                  // Guest Count
                  GuestCountPicker(
                    guestCount: _guestCount,
                    onChanged: (count) {
                      setState(() => _guestCount = count);
                    },
                  ),
                  const SizedBox(height: 24),

                  // Contact Information
                  Text(
                    'Contact Information',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),

                  // Name Field
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Full Name',
                      prefixIcon: const Icon(Icons.person),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Phone Field
                  TextFormField(
                    controller: _phoneController,
                    decoration: InputDecoration(
                      labelText: 'Phone Number',
                      prefixIcon: const Icon(Icons.phone),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your phone number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Email Field
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email Address',
                      prefixIcon: const Icon(Icons.email),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your email';
                      }
                      final emailRegex = RegExp(
                        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                      );
                      if (!emailRegex.hasMatch(value)) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),

                  // Notes Field
                  Text(
                    'Special Requests',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _notesController,
                    decoration: InputDecoration(
                      labelText: 'Special Requests or Notes',
                      prefixIcon: const Icon(Icons.note),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignLabelWithHint: true,
                    ),
                    maxLines: 4,
                    maxLength: 500,
                  ),
                  const SizedBox(height: 24),

                  // Save Button
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: _isLoading
                          ? null
                          : () => _handleSave(reservation),
                      icon: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.save),
                      label: Text(_isLoading ? 'Saving...' : 'Save Changes'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error: $error'),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () {
                  ref.invalidate(reservationProvider(widget.reservationId));
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, Reservation reservation) {
    final dateFormat = DateFormat.yMMMMEEEEd();
    final timeFormat = DateFormat.jm();

    return Card(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 12),
                Text(
                  'Reservation Details',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildInfoRow(
              context,
              label: 'Date',
              value: dateFormat.format(reservation.date),
            ),
            const SizedBox(height: 8),
            _buildInfoRow(
              context,
              label: 'Time',
              value: reservation.startTime != null && reservation.endTime != null
                  ? '${timeFormat.format(reservation.startTime!)} - '
                      '${timeFormat.format(reservation.endTime!)}'
                  : 'Time slot: ${reservation.timeSlotId}',
            ),
            const SizedBox(height: 8),
            _buildInfoRow(
              context,
              label: 'Status',
              value: reservation.status.name.toUpperCase(),
            ),
            const Divider(height: 24),
            Text(
              'Note: Date, time, and status cannot be changed. '
              'To change these, please cancel and create a new reservation.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontStyle: FontStyle.italic,
                    color: Theme.of(context).colorScheme.outline,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context,
      {required String label, required String value}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.outline,
                ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
          ),
        ),
      ],
    );
  }
}
