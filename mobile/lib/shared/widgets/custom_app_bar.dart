import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Custom app bar with consistent styling.
///
/// Provides reusable app bar variations following Material 3 design principles.
///
/// Example:
/// ```dart
/// CustomAppBar(
///   title: 'Menu',
///   actions: [
///     IconButton(
///       icon: Icon(Icons.search),
///       onPressed: () {},
///     ),
///   ],
/// )
/// ```
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    required this.title,
    this.subtitle,
    this.leading,
    this.actions,
    this.centerTitle = true,
    this.showBackButton = true,
    this.onBackPressed,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation,
    this.bottom,
    super.key,
  });

  /// App bar title.
  final String title;

  /// Optional subtitle below title.
  final String? subtitle;

  /// Leading widget (overrides back button).
  final Widget? leading;

  /// Action buttons.
  final List<Widget>? actions;

  /// Whether to center the title.
  final bool centerTitle;

  /// Whether to show back button (if applicable).
  final bool showBackButton;

  /// Custom back button callback.
  final VoidCallback? onBackPressed;

  /// Background color.
  final Color? backgroundColor;

  /// Text/icon color.
  final Color? foregroundColor;

  /// Elevation.
  final double? elevation;

  /// Bottom widget (e.g., TabBar).
  final PreferredSizeWidget? bottom;

  @override
  Size get preferredSize => Size.fromHeight(
        kToolbarHeight + (bottom?.preferredSize.height ?? 0),
      );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Check if we can pop (show back button)
    final canPop = ModalRoute.of(context)?.canPop ?? false;

    return AppBar(
      title: subtitle != null
          ? Column(
              crossAxisAlignment:
                  centerTitle ? CrossAxisAlignment.center : CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(title),
                Text(
                  subtitle!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: foregroundColor?.withOpacity(0.7) ??
                        colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            )
          : Text(title),
      centerTitle: centerTitle,
      leading: leading ??
          (canPop && showBackButton
              ? IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
                  tooltip: 'Back',
                )
              : null),
      actions: actions,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      elevation: elevation,
      bottom: bottom,
      systemOverlayStyle: _getSystemOverlayStyle(context),
    );
  }

  SystemUiOverlayStyle _getSystemOverlayStyle(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
      statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
    );
  }

  /// Large app bar with title in the body area.
  static Widget large({
    required String title,
    String? subtitle,
    List<Widget>? actions,
    VoidCallback? onBackPressed,
    bool showBackButton = true,
    Color? backgroundColor,
    Color? foregroundColor,
  }) {
    return Builder(
      builder: (context) {
        final theme = Theme.of(context);
        final canPop = ModalRoute.of(context)?.canPop ?? false;

        return SliverAppBar.large(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(title),
              if (subtitle != null)
                Text(
                  subtitle,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
            ],
          ),
          leading: canPop && showBackButton
              ? IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
                  tooltip: 'Back',
                )
              : null,
          actions: actions,
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          pinned: true,
        );
      },
    );
  }

  /// Medium app bar with slightly larger title.
  static Widget medium({
    required String title,
    String? subtitle,
    List<Widget>? actions,
    VoidCallback? onBackPressed,
    bool showBackButton = true,
    Color? backgroundColor,
    Color? foregroundColor,
  }) {
    return Builder(
      builder: (context) {
        final theme = Theme.of(context);
        final canPop = ModalRoute.of(context)?.canPop ?? false;

        return SliverAppBar.medium(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(title),
              if (subtitle != null)
                Text(
                  subtitle,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
            ],
          ),
          leading: canPop && showBackButton
              ? IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
                  tooltip: 'Back',
                )
              : null,
          actions: actions,
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          pinned: true,
        );
      },
    );
  }
}

/// Search app bar with integrated search field.
///
/// Example:
/// ```dart
/// SearchAppBar(
///   hintText: 'Search menu items...',
///   controller: searchController,
///   onSearch: (query) => performSearch(query),
/// )
/// ```
class SearchAppBar extends StatefulWidget implements PreferredSizeWidget {
  const SearchAppBar({
    required this.controller,
    this.hintText = 'Search...',
    this.onSearch,
    this.onClear,
    this.showBackButton = true,
    this.actions,
    super.key,
  });

  /// Search text controller.
  final TextEditingController controller;

  /// Hint text for search field.
  final String hintText;

  /// Callback when search query changes.
  final ValueChanged<String>? onSearch;

  /// Callback when search is cleared.
  final VoidCallback? onClear;

  /// Whether to show back button.
  final bool showBackButton;

  /// Additional action buttons.
  final List<Widget>? actions;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  State<SearchAppBar> createState() => _SearchAppBarState();
}

class _SearchAppBarState extends State<SearchAppBar> {
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _handleClear() {
    widget.controller.clear();
    widget.onClear?.call();
    widget.onSearch?.call('');
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final canPop = ModalRoute.of(context)?.canPop ?? false;

    return AppBar(
      leading: canPop && widget.showBackButton
          ? IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(),
              tooltip: 'Back',
            )
          : null,
      title: TextField(
        controller: widget.controller,
        focusNode: _focusNode,
        autofocus: true,
        decoration: InputDecoration(
          hintText: widget.hintText,
          border: InputBorder.none,
          hintStyle: TextStyle(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        style: TextStyle(color: colorScheme.onSurface),
        onChanged: widget.onSearch,
      ),
      actions: [
        if (widget.controller.text.isNotEmpty)
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: _handleClear,
            tooltip: 'Clear',
          ),
        ...?widget.actions,
      ],
    );
  }
}

/// Transparent app bar for overlaying on images.
///
/// Example:
/// ```dart
/// TransparentAppBar(
///   actions: [
///     IconButton(
///       icon: Icon(Icons.favorite_border),
///       onPressed: () {},
///     ),
///   ],
/// )
/// ```
class TransparentAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TransparentAppBar({
    this.title,
    this.actions,
    this.showBackButton = true,
    this.onBackPressed,
    super.key,
  });

  /// Optional title.
  final String? title;

  /// Action buttons.
  final List<Widget>? actions;

  /// Whether to show back button.
  final bool showBackButton;

  /// Custom back button callback.
  final VoidCallback? onBackPressed;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final canPop = ModalRoute.of(context)?.canPop ?? false;

    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: title != null ? Text(title!) : null,
      leading: canPop && showBackButton
          ? IconButton(
              icon: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.black26,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back, color: Colors.white),
              ),
              onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
              tooltip: 'Back',
            )
          : null,
      actions: actions
          ?.map(
            (action) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: action,
            ),
          )
          .toList(),
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    );
  }
}

/// Bottom app bar with centered FAB cutout.
///
/// Example:
/// ```dart
/// CustomBottomAppBar(
///   leading: [
///     IconButton(icon: Icon(Icons.menu), onPressed: () {}),
///   ],
///   trailing: [
///     IconButton(icon: Icon(Icons.search), onPressed: () {}),
///   ],
/// )
/// ```
class CustomBottomAppBar extends StatelessWidget {
  const CustomBottomAppBar({
    this.leading,
    this.trailing,
    this.height = 60.0,
    this.backgroundColor,
    super.key,
  });

  /// Leading action buttons (left side).
  final List<Widget>? leading;

  /// Trailing action buttons (right side).
  final List<Widget>? trailing;

  /// Height of the bottom bar.
  final double height;

  /// Background color.
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BottomAppBar(
      height: height,
      color: backgroundColor ?? theme.colorScheme.surface,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(children: leading ?? []),
          Row(children: trailing ?? []),
        ],
      ),
    );
  }
}

/// Tab bar with custom styling.
///
/// Example:
/// ```dart
/// CustomTabBar(
///   tabs: ['All', 'Appetizers', 'Main Course', 'Desserts'],
///   controller: tabController,
/// )
/// ```
class CustomTabBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomTabBar({
    required this.tabs,
    this.controller,
    this.isScrollable = false,
    this.indicatorColor,
    this.labelColor,
    this.unselectedLabelColor,
    super.key,
  });

  /// Tab labels.
  final List<String> tabs;

  /// Tab controller.
  final TabController? controller;

  /// Whether tabs should be scrollable.
  final bool isScrollable;

  /// Indicator color.
  final Color? indicatorColor;

  /// Selected label color.
  final Color? labelColor;

  /// Unselected label color.
  final Color? unselectedLabelColor;

  @override
  Size get preferredSize => const Size.fromHeight(48);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return TabBar(
      controller: controller,
      isScrollable: isScrollable,
      tabs: tabs.map((tab) => Tab(text: tab)).toList(),
      indicatorColor: indicatorColor ?? colorScheme.primary,
      labelColor: labelColor ?? colorScheme.primary,
      unselectedLabelColor:
          unselectedLabelColor ?? colorScheme.onSurfaceVariant,
      indicatorWeight: 3,
      labelStyle: theme.textTheme.titleSmall?.copyWith(
        fontWeight: FontWeight.bold,
      ),
      unselectedLabelStyle: theme.textTheme.titleSmall,
    );
  }
}
