import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:restaurant_reservation/core/constants/string_constants.dart';
import 'package:restaurant_reservation/core/router/route_names.dart';
import 'package:restaurant_reservation/core/theme/app_dimensions.dart';
import 'package:restaurant_reservation/core/utils/validators.dart';
import 'package:restaurant_reservation/features/auth/presentation/providers/auth_providers.dart';
import 'package:restaurant_reservation/features/auth/presentation/widgets/auth_text_field.dart';

/// Profile screen for viewing and editing user information.
class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _phoneController;
  bool _isEditing = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _phoneController = TextEditingController();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _populateFields() {
    final user = ref.watch(authStateProvider).value;
    if (user != null) {
      _firstNameController.text = user.firstName;
      _lastNameController.text = user.lastName;
      _phoneController.text = user.phone;
    }
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      await ref.read(authStateProvider.notifier).updateProfile(
            firstName: _firstNameController.text.trim(),
            lastName: _lastNameController.text.trim(),
            phone: _phoneController.text.trim(),
          );

      if (mounted) {
        setState(() => _isEditing = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(StringConstants.updateSuccess),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceAll('Exception: ', '')),
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

  Future<void> _handleLogout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text(StringConstants.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text(StringConstants.logout),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() => _isLoading = true);

    try {
      await ref.read(authStateProvider.notifier).logout();

      if (mounted) {
        context.go(RouteNames.login);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceAll('Exception: ', '')),
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final authState = ref.watch(authStateProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(StringConstants.profile),
        actions: [
          if (!_isEditing)
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              onPressed: _isLoading
                  ? null
                  : () {
                      setState(() => _isEditing = true);
                      _populateFields();
                    },
              tooltip: 'Edit Profile',
            )
          else
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: _isLoading
                  ? null
                  : () {
                      setState(() => _isEditing = false);
                      _populateFields();
                    },
              tooltip: 'Cancel',
            ),
        ],
      ),
      body: authState.when(
        data: (user) {
          if (user == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.person_off_outlined,
                    size: 64,
                  ),
                  const SizedBox(height: AppDimensions.spacing16),
                  const Text('Not logged in'),
                  const SizedBox(height: AppDimensions.spacing24),
                  FilledButton.icon(
                    onPressed: () => context.go(RouteNames.login),
                    icon: const Icon(Icons.login),
                    label: const Text(StringConstants.login),
                  ),
                ],
              ),
            );
          }

          // Populate fields if editing and controllers are empty
          if (_isEditing &&
              _firstNameController.text.isEmpty &&
              _lastNameController.text.isEmpty) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _populateFields();
            });
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppDimensions.paddingLg),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Avatar
                  Center(
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor: colorScheme.primaryContainer,
                      child: Icon(
                        Icons.person,
                        size: 60,
                        color: colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppDimensions.spacing24),

                  // Name (readonly when not editing)
                  if (!_isEditing) ...[
                    _buildInfoCard(
                      context,
                      'Name',
                      user.fullName,
                      Icons.person_outline,
                    ),
                    const SizedBox(height: AppDimensions.spacing16),
                  ] else ...[
                    AuthTextField(
                      controller: _firstNameController,
                      label: StringConstants.firstName,
                      prefixIcon: Icons.person_outline,
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                      validator: (value) =>
                          Validators.required(value, fieldName: 'First name'),
                      enabled: !_isLoading,
                    ),
                    const SizedBox(height: AppDimensions.spacing16),
                    AuthTextField(
                      controller: _lastNameController,
                      label: StringConstants.lastName,
                      prefixIcon: Icons.person_outline,
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                      validator: (value) =>
                          Validators.required(value, fieldName: 'Last name'),
                      enabled: !_isLoading,
                    ),
                    const SizedBox(height: AppDimensions.spacing16),
                  ],

                  // Email (always readonly)
                  _buildInfoCard(
                    context,
                    StringConstants.email,
                    user.email,
                    Icons.email_outlined,
                  ),
                  const SizedBox(height: AppDimensions.spacing16),

                  // Phone
                  if (!_isEditing)
                    _buildInfoCard(
                      context,
                      StringConstants.phone,
                      user.phone,
                      Icons.phone_outlined,
                    )
                  else
                    AuthTextField(
                      controller: _phoneController,
                      label: StringConstants.phone,
                      prefixIcon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.done,
                      validator: Validators.phone,
                      enabled: !_isLoading,
                    ),
                  const SizedBox(height: AppDimensions.spacing16),

                  // Role Badge
                  _buildInfoCard(
                    context,
                    'Role',
                    user.isAdmin ? 'Administrator' : 'Customer',
                    Icons.badge_outlined,
                  ),
                  const SizedBox(height: AppDimensions.spacing32),

                  // Save Button (only when editing)
                  if (_isEditing)
                    FilledButton.icon(
                      onPressed: _isLoading ? null : _handleSave,
                      icon: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Icon(Icons.save),
                      label: const Text(StringConstants.save),
                    ),

                  const SizedBox(height: AppDimensions.spacing16),

                  // Logout Button
                  OutlinedButton.icon(
                    onPressed: _isLoading ? null : _handleLogout,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: colorScheme.error,
                      side: BorderSide(color: colorScheme.error),
                    ),
                    icon: const Icon(Icons.logout),
                    label: const Text(StringConstants.logout),
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
              Icon(
                Icons.error_outline,
                size: 64,
                color: colorScheme.error,
              ),
              const SizedBox(height: AppDimensions.spacing16),
              Text(
                'Error loading profile',
                style: theme.textTheme.titleMedium,
              ),
              const SizedBox(height: AppDimensions.spacing8),
              Text(
                error.toString(),
                style: theme.textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        side: BorderSide(color: colorScheme.outline.withOpacity(0.5)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingMd),
        child: Row(
          children: [
            Icon(icon, color: colorScheme.primary),
            const SizedBox(width: AppDimensions.spacing16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: theme.textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
