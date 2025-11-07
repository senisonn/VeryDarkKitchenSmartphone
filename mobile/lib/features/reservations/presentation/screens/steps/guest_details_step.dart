import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/reservation_providers.dart';
import '../../widgets/guest_count_picker.dart';

/// Step 3: Guest details form for reservation.
class GuestDetailsStep extends ConsumerStatefulWidget {
  const GuestDetailsStep({
    super.key,
    required this.onNext,
    required this.onBack,
  });

  final VoidCallback onNext;
  final VoidCallback onBack;

  @override
  ConsumerState<GuestDetailsStep> createState() => _GuestDetailsStepState();
}

class _GuestDetailsStepState extends ConsumerState<GuestDetailsStep> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize controllers with existing values
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _nameController.text = ref.read(guestNameProvider);
      _phoneController.text = ref.read(guestPhoneProvider);
      _emailController.text = ref.read(guestEmailProvider);
      _notesController.text = ref.read(reservationNotesProvider);
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _handleNext() {
    if (_formKey.currentState?.validate() ?? false) {
      // Save form data to providers
      ref.read(guestNameProvider.notifier).update(_nameController.text);
      ref.read(guestPhoneProvider.notifier).update(_phoneController.text);
      ref.read(guestEmailProvider.notifier).update(_emailController.text);
      ref.read(reservationNotesProvider.notifier).update(_notesController.text);
      widget.onNext();
    }
  }

  @override
  Widget build(BuildContext context) {
    final guestCount = ref.watch(guestCountProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
              'Guest Details',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Please provide your contact information',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                  ),
            ),
            const SizedBox(height: 24),

            // Guest Count Picker
            GuestCountPicker(
              guestCount: guestCount,
              onChanged: (count) {
                ref.read(guestCountProvider.notifier).set(count);
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
                hintText: 'Enter your full name',
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
                if (value.trim().length < 2) {
                  return 'Name must be at least 2 characters';
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
                hintText: 'Enter your phone number',
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
                // Basic phone validation (at least 10 digits)
                final digitsOnly = value.replaceAll(RegExp(r'\D'), '');
                if (digitsOnly.length < 10) {
                  return 'Please enter a valid phone number';
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
                hintText: 'Enter your email address',
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
                // Basic email validation
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

            // Special Requests Section
            Text(
              'Special Requests (Optional)',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),

            // Notes Field
            TextFormField(
              controller: _notesController,
              decoration: InputDecoration(
                labelText: 'Special Requests or Notes',
                hintText: 'Any dietary restrictions, allergies, or special occasions?',
                prefixIcon: const Icon(Icons.note),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                alignLabelWithHint: true,
              ),
              maxLines: 4,
              maxLength: 500,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => _handleNext(),
            ),
            const SizedBox(height: 24),

            // Next Button
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _handleNext,
                icon: const Icon(Icons.arrow_forward),
                label: const Text('Review Reservation'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
