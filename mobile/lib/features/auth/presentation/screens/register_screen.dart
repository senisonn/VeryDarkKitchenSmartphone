import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:restaurant_reservation/core/constants/string_constants.dart';
import 'package:restaurant_reservation/core/router/route_names.dart';
import 'package:restaurant_reservation/core/theme/app_dimensions.dart';
import 'package:restaurant_reservation/core/utils/validators.dart';
import 'package:restaurant_reservation/features/auth/presentation/providers/auth_providers.dart';
import 'package:restaurant_reservation/features/auth/presentation/widgets/auth_text_field.dart';

/// Register screen for creating a new user account.
class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      await ref.read(authStateProvider.notifier).register(
            email: _emailController.text.trim(),
            password: _passwordController.text,
            firstName: _firstNameController.text.trim(),
            lastName: _lastNameController.text.trim(),
            phone: _phoneController.text.trim(),
          );

      if (mounted) {
        context.go(RouteNames.menu);
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

    return Scaffold(
      appBar: AppBar(
        title: const Text(StringConstants.register),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.paddingLg),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Title
                Text(
                  StringConstants.signUp,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppDimensions.spacing8),

                // Subtitle
                Text(
                  'Create your account to get started.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppDimensions.spacing32),

                // First Name
                AuthTextField(
                  controller: _firstNameController,
                  label: StringConstants.firstName,
                  hintText: 'Enter your first name',
                  prefixIcon: Icons.person_outline,
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  validator: (value) =>
                      Validators.required(value, fieldName: 'First name'),
                  enabled: !_isLoading,
                ),
                const SizedBox(height: AppDimensions.spacing16),

                // Last Name
                AuthTextField(
                  controller: _lastNameController,
                  label: StringConstants.lastName,
                  hintText: 'Enter your last name',
                  prefixIcon: Icons.person_outline,
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  validator: (value) =>
                      Validators.required(value, fieldName: 'Last name'),
                  enabled: !_isLoading,
                ),
                const SizedBox(height: AppDimensions.spacing16),

                // Email
                AuthTextField(
                  controller: _emailController,
                  label: StringConstants.email,
                  hintText: 'Enter your email',
                  prefixIcon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  validator: Validators.email,
                  enabled: !_isLoading,
                ),
                const SizedBox(height: AppDimensions.spacing16),

                // Phone
                AuthTextField(
                  controller: _phoneController,
                  label: StringConstants.phone,
                  hintText: 'Enter your phone number',
                  prefixIcon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  validator: Validators.phone,
                  enabled: !_isLoading,
                ),
                const SizedBox(height: AppDimensions.spacing16),

                // Password
                AuthTextField(
                  controller: _passwordController,
                  label: StringConstants.password,
                  hintText: 'Enter your password',
                  prefixIcon: Icons.lock_outline,
                  obscureText: _obscurePassword,
                  textInputAction: TextInputAction.next,
                  validator: Validators.password,
                  enabled: !_isLoading,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                    onPressed: () {
                      setState(() => _obscurePassword = !_obscurePassword);
                    },
                  ),
                ),
                const SizedBox(height: AppDimensions.spacing16),

                // Confirm Password
                AuthTextField(
                  controller: _confirmPasswordController,
                  label: StringConstants.confirmPassword,
                  hintText: 'Re-enter your password',
                  prefixIcon: Icons.lock_outline,
                  obscureText: _obscureConfirmPassword,
                  textInputAction: TextInputAction.done,
                  validator: (value) =>
                      Validators.confirmPassword(value, _passwordController.text),
                  enabled: !_isLoading,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirmPassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                    onPressed: () {
                      setState(
                        () => _obscureConfirmPassword = !_obscureConfirmPassword,
                      );
                    },
                  ),
                  onSubmitted: (_) => _handleRegister(),
                ),
                const SizedBox(height: AppDimensions.spacing32),

                // Register Button
                FilledButton(
                  onPressed: _isLoading ? null : _handleRegister,
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Text(StringConstants.signUp),
                ),
                const SizedBox(height: AppDimensions.spacing24),

                // Login Link
                Center(
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        StringConstants.alreadyHaveAccount,
                        style: theme.textTheme.bodyMedium,
                      ),
                      TextButton(
                        onPressed:
                            _isLoading ? null : () => context.go(RouteNames.login),
                        child: Text(StringConstants.signIn),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
