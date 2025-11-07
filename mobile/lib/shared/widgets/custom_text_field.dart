import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Text field variant types.
enum TextFieldVariant {
  /// Standard outlined text field (default).
  outlined,

  /// Filled text field with background.
  filled,
}

/// Custom text field widget with validation and consistent styling.
///
/// Provides a reusable input field following Material 3 design principles.
///
/// Example:
/// ```dart
/// CustomTextField(
///   label: 'Email',
///   hint: 'Enter your email',
///   controller: emailController,
///   keyboardType: TextInputType.emailAddress,
///   validator: (value) => value?.isEmpty == true ? 'Required' : null,
/// )
/// ```
class CustomTextField extends StatefulWidget {
  const CustomTextField({
    this.controller,
    this.label,
    this.hint,
    this.helperText,
    this.errorText,
    this.prefixIcon,
    this.suffixIcon,
    this.onChanged,
    this.onSubmitted,
    this.validator,
    this.keyboardType,
    this.textInputAction,
    this.obscureText = false,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.inputFormatters,
    this.variant = TextFieldVariant.outlined,
    this.initialValue,
    this.focusNode,
    this.onTap,
    this.autocorrect = true,
    this.enableSuggestions = true,
    super.key,
  });

  /// Text editing controller.
  final TextEditingController? controller;

  /// Field label text.
  final String? label;

  /// Placeholder/hint text.
  final String? hint;

  /// Helper text displayed below field.
  final String? helperText;

  /// Error text displayed below field.
  final String? errorText;

  /// Leading icon.
  final IconData? prefixIcon;

  /// Trailing icon/widget.
  final Widget? suffixIcon;

  /// Callback when text changes.
  final ValueChanged<String>? onChanged;

  /// Callback when field is submitted.
  final ValueChanged<String>? onSubmitted;

  /// Validation function.
  final String? Function(String?)? validator;

  /// Keyboard type.
  final TextInputType? keyboardType;

  /// Text input action button.
  final TextInputAction? textInputAction;

  /// Whether text should be obscured (for passwords).
  final bool obscureText;

  /// Whether field is enabled.
  final bool enabled;

  /// Whether field is read-only.
  final bool readOnly;

  /// Whether field should autofocus.
  final bool autofocus;

  /// Maximum number of lines.
  final int? maxLines;

  /// Minimum number of lines.
  final int? minLines;

  /// Maximum character length.
  final int? maxLength;

  /// Input formatters.
  final List<TextInputFormatter>? inputFormatters;

  /// Field style variant.
  final TextFieldVariant variant;

  /// Initial value for field.
  final String? initialValue;

  /// Focus node.
  final FocusNode? focusNode;

  /// Callback when field is tapped.
  final VoidCallback? onTap;

  /// Whether to enable autocorrect.
  final bool autocorrect;

  /// Whether to enable suggestions.
  final bool enableSuggestions;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _obscureText;
  String? _validationError;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  @override
  void didUpdateWidget(CustomTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.obscureText != oldWidget.obscureText) {
      _obscureText = widget.obscureText;
    }
  }

  void _validate(String? value) {
    if (widget.validator != null) {
      setState(() {
        _validationError = widget.validator!(value);
      });
    }
  }

  void _toggleObscureText() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Determine which error to show
    final String? displayError = widget.errorText ?? _validationError;

    // Build suffix icon (add visibility toggle for password fields)
    Widget? suffixIcon = widget.suffixIcon;
    if (widget.obscureText) {
      suffixIcon = IconButton(
        icon: Icon(
          _obscureText ? Icons.visibility_outlined : Icons.visibility_off_outlined,
          color: colorScheme.onSurfaceVariant,
        ),
        onPressed: _toggleObscureText,
        tooltip: _obscureText ? 'Show password' : 'Hide password',
      );
    }

    final InputDecoration decoration = InputDecoration(
      labelText: widget.label,
      hintText: widget.hint,
      helperText: widget.helperText,
      errorText: displayError,
      prefixIcon: widget.prefixIcon != null ? Icon(widget.prefixIcon) : null,
      suffixIcon: suffixIcon,
      enabled: widget.enabled,
      filled: widget.variant == TextFieldVariant.filled,
      fillColor: widget.variant == TextFieldVariant.filled
          ? colorScheme.surfaceContainerHighest
          : null,

      // Border styling
      border: widget.variant == TextFieldVariant.outlined
          ? OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: colorScheme.outline),
            )
          : UnderlineInputBorder(
              borderSide: BorderSide(color: colorScheme.outline),
            ),
      enabledBorder: widget.variant == TextFieldVariant.outlined
          ? OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: colorScheme.outline),
            )
          : UnderlineInputBorder(
              borderSide: BorderSide(color: colorScheme.outline),
            ),
      focusedBorder: widget.variant == TextFieldVariant.outlined
          ? OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: colorScheme.primary, width: 2),
            )
          : UnderlineInputBorder(
              borderSide: BorderSide(color: colorScheme.primary, width: 2),
            ),
      errorBorder: widget.variant == TextFieldVariant.outlined
          ? OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: colorScheme.error),
            )
          : UnderlineInputBorder(
              borderSide: BorderSide(color: colorScheme.error),
            ),
      focusedErrorBorder: widget.variant == TextFieldVariant.outlined
          ? OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: colorScheme.error, width: 2),
            )
          : UnderlineInputBorder(
              borderSide: BorderSide(color: colorScheme.error, width: 2),
            ),
      disabledBorder: widget.variant == TextFieldVariant.outlined
          ? OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: colorScheme.surfaceContainerHighest),
            )
          : UnderlineInputBorder(
              borderSide: BorderSide(color: colorScheme.surfaceContainerHighest),
            ),

      // Content padding
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 16,
      ),
    );

    return TextFormField(
      controller: widget.controller,
      initialValue: widget.initialValue,
      focusNode: widget.focusNode,
      decoration: decoration,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      obscureText: _obscureText,
      enabled: widget.enabled,
      readOnly: widget.readOnly,
      autofocus: widget.autofocus,
      maxLines: widget.obscureText ? 1 : widget.maxLines,
      minLines: widget.minLines,
      maxLength: widget.maxLength,
      inputFormatters: widget.inputFormatters,
      autocorrect: widget.autocorrect,
      enableSuggestions: widget.enableSuggestions,
      onChanged: (value) {
        _validate(value);
        widget.onChanged?.call(value);
      },
      onFieldSubmitted: widget.onSubmitted,
      onTap: widget.onTap,
      validator: widget.validator,
      style: theme.textTheme.bodyLarge,
    );
  }
}

/// Password text field with built-in visibility toggle.
///
/// Example:
/// ```dart
/// PasswordTextField(
///   label: 'Password',
///   controller: passwordController,
///   validator: (value) => value?.length < 6 ? 'Too short' : null,
/// )
/// ```
class PasswordTextField extends StatelessWidget {
  const PasswordTextField({
    required this.controller,
    this.label = 'Password',
    this.hint,
    this.helperText,
    this.errorText,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.textInputAction,
    this.autofocus = false,
    this.enabled = true,
    super.key,
  });

  /// Text editing controller.
  final TextEditingController controller;

  /// Field label.
  final String label;

  /// Placeholder text.
  final String? hint;

  /// Helper text.
  final String? helperText;

  /// Error text.
  final String? errorText;

  /// Validation function.
  final String? Function(String?)? validator;

  /// Callback when text changes.
  final ValueChanged<String>? onChanged;

  /// Callback when field is submitted.
  final ValueChanged<String>? onSubmitted;

  /// Text input action.
  final TextInputAction? textInputAction;

  /// Whether to autofocus.
  final bool autofocus;

  /// Whether field is enabled.
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: controller,
      label: label,
      hint: hint,
      helperText: helperText,
      errorText: errorText,
      prefixIcon: Icons.lock_outline,
      obscureText: true,
      keyboardType: TextInputType.visiblePassword,
      textInputAction: textInputAction,
      autocorrect: false,
      enableSuggestions: false,
      validator: validator,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      autofocus: autofocus,
      enabled: enabled,
    );
  }
}

/// Email text field with built-in email keyboard and icon.
///
/// Example:
/// ```dart
/// EmailTextField(
///   controller: emailController,
///   validator: Validators.email,
/// )
/// ```
class EmailTextField extends StatelessWidget {
  const EmailTextField({
    required this.controller,
    this.label = 'Email',
    this.hint,
    this.helperText,
    this.errorText,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.textInputAction,
    this.autofocus = false,
    this.enabled = true,
    super.key,
  });

  /// Text editing controller.
  final TextEditingController controller;

  /// Field label.
  final String label;

  /// Placeholder text.
  final String? hint;

  /// Helper text.
  final String? helperText;

  /// Error text.
  final String? errorText;

  /// Validation function.
  final String? Function(String?)? validator;

  /// Callback when text changes.
  final ValueChanged<String>? onChanged;

  /// Callback when field is submitted.
  final ValueChanged<String>? onSubmitted;

  /// Text input action.
  final TextInputAction? textInputAction;

  /// Whether to autofocus.
  final bool autofocus;

  /// Whether field is enabled.
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: controller,
      label: label,
      hint: hint,
      helperText: helperText,
      errorText: errorText,
      prefixIcon: Icons.email_outlined,
      keyboardType: TextInputType.emailAddress,
      textInputAction: textInputAction ?? TextInputAction.next,
      autocorrect: false,
      enableSuggestions: false,
      validator: validator,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      autofocus: autofocus,
      enabled: enabled,
    );
  }
}

/// Search text field with search icon and clear button.
///
/// Example:
/// ```dart
/// SearchTextField(
///   controller: searchController,
///   hint: 'Search menu items...',
///   onChanged: (query) => performSearch(query),
/// )
/// ```
class SearchTextField extends StatelessWidget {
  const SearchTextField({
    required this.controller,
    this.hint = 'Search...',
    this.onChanged,
    this.onSubmitted,
    this.onClear,
    this.autofocus = false,
    super.key,
  });

  /// Text editing controller.
  final TextEditingController controller;

  /// Placeholder text.
  final String hint;

  /// Callback when text changes.
  final ValueChanged<String>? onChanged;

  /// Callback when search is submitted.
  final ValueChanged<String>? onSubmitted;

  /// Callback when clear button is pressed.
  final VoidCallback? onClear;

  /// Whether to autofocus.
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: controller,
      hint: hint,
      prefixIcon: Icons.search,
      suffixIcon: controller.text.isNotEmpty
          ? IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                controller.clear();
                onClear?.call();
                onChanged?.call('');
              },
              tooltip: 'Clear',
            )
          : null,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.search,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      autofocus: autofocus,
    );
  }
}
