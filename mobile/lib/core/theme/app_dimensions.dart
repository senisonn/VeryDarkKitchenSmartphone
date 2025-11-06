/// Application spacing and dimension constants.
///
/// Provides consistent sizing and spacing following 8dp grid system.
class AppDimensions {
  AppDimensions._();

  // Spacing (8dp grid system)
  static const double spacing4 = 4.0;
  static const double spacing8 = 8.0;
  static const double spacing12 = 12.0;
  static const double spacing16 = 16.0;
  static const double spacing20 = 20.0;
  static const double spacing24 = 24.0;
  static const double spacing32 = 32.0;
  static const double spacing40 = 40.0;
  static const double spacing48 = 48.0;
  static const double spacing56 = 56.0;
  static const double spacing64 = 64.0;

  // Common Spacing Aliases
  static const double paddingXs = spacing8;
  static const double paddingSm = spacing12;
  static const double paddingMd = spacing16;
  static const double paddingLg = spacing24;
  static const double paddingXl = spacing32;

  static const double marginXs = spacing8;
  static const double marginSm = spacing12;
  static const double marginMd = spacing16;
  static const double marginLg = spacing24;
  static const double marginXl = spacing32;

  // Border Radius
  static const double radiusXs = 4.0;
  static const double radiusSm = 8.0;
  static const double radiusMd = 12.0;
  static const double radiusLg = 16.0;
  static const double radiusXl = 20.0;
  static const double radiusXxl = 24.0;
  static const double radiusFull = 9999.0;

  // Icon Sizes
  static const double iconXs = 16.0;
  static const double iconSm = 20.0;
  static const double iconMd = 24.0;
  static const double iconLg = 32.0;
  static const double iconXl = 40.0;
  static const double iconXxl = 48.0;

  // Button Heights
  static const double buttonHeightSm = 36.0;
  static const double buttonHeightMd = 48.0;
  static const double buttonHeightLg = 56.0;

  // Input Field Heights
  static const double inputHeightSm = 40.0;
  static const double inputHeightMd = 48.0;
  static const double inputHeightLg = 56.0;

  // Card Heights
  static const double cardHeightSm = 80.0;
  static const double cardHeightMd = 120.0;
  static const double cardHeightLg = 180.0;

  // Elevation (shadows)
  static const double elevationNone = 0.0;
  static const double elevationXs = 1.0;
  static const double elevationSm = 2.0;
  static const double elevationMd = 4.0;
  static const double elevationLg = 8.0;
  static const double elevationXl = 16.0;

  // Border Width
  static const double borderWidthThin = 0.5;
  static const double borderWidthNormal = 1.0;
  static const double borderWidthThick = 2.0;

  // Divider Thickness
  static const double dividerThin = 0.5;
  static const double dividerNormal = 1.0;
  static const double dividerThick = 2.0;

  // App Bar
  static const double appBarHeight = 56.0;
  static const double appBarElevation = elevationSm;

  // Bottom Navigation
  static const double bottomNavHeight = 56.0;
  static const double bottomNavElevation = elevationMd;

  // List Tile
  static const double listTileHeight = 72.0;
  static const double listTileVerticalPadding = spacing12;
  static const double listTileHorizontalPadding = spacing16;

  // Avatar Sizes
  static const double avatarXs = 24.0;
  static const double avatarSm = 32.0;
  static const double avatarMd = 40.0;
  static const double avatarLg = 56.0;
  static const double avatarXl = 72.0;

  // Dialog
  static const double dialogBorderRadius = radiusMd;
  static const double dialogPadding = paddingLg;
  static const double dialogMaxWidth = 400.0;

  // Snackbar
  static const double snackbarBorderRadius = radiusSm;
  static const double snackbarPadding = paddingMd;

  // Bottom Sheet
  static const double bottomSheetBorderRadius = radiusLg;
  static const double bottomSheetMinHeight = 200.0;

  // Responsive Breakpoints
  static const double breakpointMobile = 600.0;
  static const double breakpointTablet = 960.0;
  static const double breakpointDesktop = 1280.0;

  // Maximum Content Width
  static const double maxContentWidth = 1200.0;
  static const double maxFormWidth = 600.0;

  // Minimum Touch Target Size (Accessibility)
  static const double minTouchTarget = 48.0;

  // Loading Indicator
  static const double loadingIndicatorSize = 24.0;
  static const double loadingIndicatorStrokeWidth = 3.0;

  // Image Heights
  static const double imageHeightSm = 100.0;
  static const double imageHeightMd = 200.0;
  static const double imageHeightLg = 300.0;

  // Menu Item Card
  static const double menuItemCardHeight = 120.0;
  static const double menuItemImageWidth = 100.0;

  // Reservation Card
  static const double reservationCardMinHeight = 140.0;

  // Time Slot Card
  static const double timeSlotCardHeight = 56.0;
  static const double timeSlotCardWidth = 100.0;
}
