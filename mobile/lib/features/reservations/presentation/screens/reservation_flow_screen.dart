import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'steps/confirmation_step.dart';
import 'steps/date_selection_step.dart';
import 'steps/guest_details_step.dart';
import 'steps/time_slot_selection_step.dart';

/// Multi-step wizard for creating a reservation.
/// Steps: 1) Date selection, 2) Time slot selection, 3) Guest details form, 4) Confirmation
class ReservationFlowScreen extends ConsumerStatefulWidget {
  const ReservationFlowScreen({super.key});

  @override
  ConsumerState<ReservationFlowScreen> createState() =>
      _ReservationFlowScreenState();
}

class _ReservationFlowScreenState extends ConsumerState<ReservationFlowScreen> {
  int _currentStep = 0;

  final List<String> _stepTitles = [
    'Select Date',
    'Choose Time',
    'Guest Details',
    'Confirmation',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_stepTitles[_currentStep]),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => _handleClose(),
        ),
      ),
      body: Column(
        children: [
          // Progress Indicator
          LinearProgressIndicator(
            value: (_currentStep + 1) / _stepTitles.length,
          ),
          const SizedBox(height: 8),

          // Step Indicators
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(
                _stepTitles.length,
                (index) => _buildStepIndicator(index),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Step Content (includes its own navigation)
          Expanded(
            child: _buildStepContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildStepIndicator(int index) {
    final isCompleted = index < _currentStep;
    final isCurrent = index == _currentStep;

    return Column(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isCompleted || isCurrent
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.surfaceContainerHighest,
          ),
          child: Center(
            child: isCompleted
                ? Icon(
                    Icons.check,
                    color: Theme.of(context).colorScheme.onPrimary,
                    size: 16,
                  )
                : Text(
                    '${index + 1}',
                    style: TextStyle(
                      color: isCurrent
                          ? Theme.of(context).colorScheme.onPrimary
                          : Theme.of(context).colorScheme.outline,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 0:
        return DateSelectionStep(
          onNext: _goToNextStep,
        );
      case 1:
        return TimeSlotSelectionStep(
          onNext: _goToNextStep,
          onBack: _goToPreviousStep,
        );
      case 2:
        return GuestDetailsStep(
          onNext: _goToNextStep,
          onBack: _goToPreviousStep,
        );
      case 3:
        return ConfirmationStep(
          onBack: _goToPreviousStep,
        );
      default:
        return const Center(child: Text('Invalid step'));
    }
  }

  void _goToNextStep() {
    if (_currentStep < _stepTitles.length - 1) {
      setState(() {
        _currentStep++;
      });
    }
  }

  void _goToPreviousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    }
  }

  void _handleClose() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Reservation'),
        content: const Text(
          'Are you sure you want to cancel? Your progress will be lost.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Continue'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Close flow screen
            },
            child: const Text('Yes, Cancel'),
          ),
        ],
      ),
    );
  }
}
