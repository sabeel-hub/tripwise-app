import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// A class that contains all theme configurations for the travel data collection application.
/// Implements Contemporary Spatial Minimalism with Travel Intelligence Palette.
class AppTheme {
  AppTheme._();

  // Travel Intelligence Palette - Core Colors
  static const Color primaryBlue = Color(0xFF2196F3);
  static const Color successGreen = Color(0xFF4CAF50);
  static const Color backgroundWhite = Color(0xFFFFFFFF);
  static const Color surfaceGray = Color(0xFFF8F9FA);
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color borderSubtle = Color(0xFFE5E7EB);
  static const Color warningAmber = Color(0xFFFF9800);
  static const Color errorRed = Color(0xFFF44336);
  static const Color accentTeal = Color(0xFF009688);

  // Dark theme variations
  static const Color backgroundDark = Color(0xFF121212);
  static const Color surfaceDark = Color(0xFF1E1E1E);
  static const Color cardDark = Color(0xFF2D2D2D);
  static const Color textPrimaryDark = Color(0xFFFFFFFF);
  static const Color textSecondaryDark = Color(0xFFB0B0B0);
  static const Color borderDark = Color(0xFF404040);

  // Shadow and elevation colors
  static const Color shadowLight = Color(0x0F000000);
  static const Color shadowDark = Color(0x1FFFFFFF);

  /// Light theme optimized for outdoor visibility and accessibility
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: primaryBlue,
      onPrimary: backgroundWhite,
      primaryContainer: primaryBlue.withAlpha(26),
      onPrimaryContainer: primaryBlue,
      secondary: accentTeal,
      onSecondary: backgroundWhite,
      secondaryContainer: accentTeal.withAlpha(26),
      onSecondaryContainer: accentTeal,
      tertiary: successGreen,
      onTertiary: backgroundWhite,
      tertiaryContainer: successGreen.withAlpha(26),
      onTertiaryContainer: successGreen,
      error: errorRed,
      onError: backgroundWhite,
      errorContainer: errorRed.withAlpha(26),
      onErrorContainer: errorRed,
      surface: backgroundWhite,
      onSurface: textPrimary,
      onSurfaceVariant: textSecondary,
      outline: borderSubtle,
      outlineVariant: borderSubtle.withAlpha(128),
      shadow: shadowLight,
      scrim: textPrimary.withAlpha(128),
      inverseSurface: textPrimary,
      onInverseSurface: backgroundWhite,
      inversePrimary: primaryBlue.withAlpha(204),
      surfaceTint: primaryBlue,
    ),
    scaffoldBackgroundColor: backgroundWhite,
    cardColor: surfaceGray,
    dividerColor: borderSubtle,

    // AppBar theme for clean, minimal navigation
    appBarTheme: AppBarTheme(
      backgroundColor: backgroundWhite,
      foregroundColor: textPrimary,
      elevation: 0,
      shadowColor: shadowLight,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: textPrimary,
        letterSpacing: 0.15,
      ),
      iconTheme: const IconThemeData(
        color: textPrimary,
        size: 24,
      ),
      actionsIconTheme: const IconThemeData(
        color: textPrimary,
        size: 24,
      ),
    ),

    // Card theme for trip cards and content containers
    cardTheme: CardTheme(
      color: surfaceGray,
      elevation: 0,
      shadowColor: shadowLight,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    ),

    // Bottom navigation for mobile-first design
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: backgroundWhite,
      selectedItemColor: primaryBlue,
      unselectedItemColor: textSecondary,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
      selectedLabelStyle: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.4,
      ),
      unselectedLabelStyle: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.4,
      ),
    ),

    // Navigation rail for tablet adaptive design
    navigationRailTheme: NavigationRailThemeData(
      backgroundColor: backgroundWhite,
      selectedIconTheme: const IconThemeData(
        color: primaryBlue,
        size: 24,
      ),
      unselectedIconTheme: const IconThemeData(
        color: textSecondary,
        size: 24,
      ),
      selectedLabelTextStyle: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: primaryBlue,
        letterSpacing: 0.4,
      ),
      unselectedLabelTextStyle: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: textSecondary,
        letterSpacing: 0.4,
      ),
      elevation: 0,
      indicatorColor: primaryBlue.withAlpha(26),
    ),

    // Floating action button for contextual primary actions
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primaryBlue,
      foregroundColor: backgroundWhite,
      elevation: 4,
      focusElevation: 6,
      hoverElevation: 8,
      highlightElevation: 12,
      shape: CircleBorder(),
    ),

    // Button themes optimized for touch interaction
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: backgroundWhite,
        backgroundColor: primaryBlue,
        elevation: 2,
        shadowColor: shadowLight,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.1,
        ),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryBlue,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        side: const BorderSide(color: primaryBlue, width: 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.1,
        ),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryBlue,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.1,
        ),
      ),
    ),

    // Text theme using Inter font family for consistency
    textTheme: _buildTextTheme(isLight: true),

    // Input decoration for forms and data entry
    inputDecorationTheme: InputDecorationTheme(
      fillColor: surfaceGray,
      filled: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: borderSubtle, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: borderSubtle, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: primaryBlue, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: errorRed, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: errorRed, width: 2),
      ),
      labelStyle: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: textSecondary,
        letterSpacing: 0.25,
      ),
      hintStyle: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: textSecondary.withAlpha(153),
        letterSpacing: 0.25,
      ),
      errorStyle: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: errorRed,
        letterSpacing: 0.4,
      ),
    ),

    // Switch theme for settings and preferences
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryBlue;
        }
        return textSecondary;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryBlue.withAlpha(77);
        }
        return borderSubtle;
      }),
    ),

    // Checkbox theme for selection states
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryBlue;
        }
        return Colors.transparent;
      }),
      checkColor: WidgetStateProperty.all(backgroundWhite),
      side: const BorderSide(color: borderSubtle, width: 2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
    ),

    // Radio theme for single selection
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryBlue;
        }
        return textSecondary;
      }),
    ),

    // Progress indicators for loading states
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: primaryBlue,
      linearTrackColor: borderSubtle,
      circularTrackColor: borderSubtle,
    ),

    // Slider theme for value selection
    sliderTheme: SliderThemeData(
      activeTrackColor: primaryBlue,
      thumbColor: primaryBlue,
      overlayColor: primaryBlue.withAlpha(51),
      inactiveTrackColor: borderSubtle,
      valueIndicatorColor: primaryBlue,
      valueIndicatorTextStyle: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: backgroundWhite,
      ),
    ),

    // Tab bar theme for navigation tabs
    tabBarTheme: TabBarTheme(
      labelColor: primaryBlue,
      unselectedLabelColor: textSecondary,
      indicatorColor: primaryBlue,
      indicatorSize: TabBarIndicatorSize.label,
      labelStyle: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
      ),
      unselectedLabelStyle: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.1,
      ),
    ),

    // Tooltip theme for help and information
    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        color: textPrimary.withAlpha(230),
        borderRadius: BorderRadius.circular(8),
      ),
      textStyle: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: backgroundWhite,
        letterSpacing: 0.4,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    ),

    // Snackbar theme for feedback messages
    snackBarTheme: SnackBarThemeData(
      backgroundColor: textPrimary,
      contentTextStyle: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: backgroundWhite,
        letterSpacing: 0.25,
      ),
      actionTextColor: accentTeal,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      elevation: 4,
    ),

    // List tile theme for settings and options
    listTileTheme: ListTileThemeData(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      titleTextStyle: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: textPrimary,
        letterSpacing: 0.15,
      ),
      subtitleTextStyle: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: textSecondary,
        letterSpacing: 0.25,
      ),
      iconColor: textSecondary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),

    // Chip theme for tags and filters
    chipTheme: ChipThemeData(
      backgroundColor: surfaceGray,
      selectedColor: primaryBlue.withAlpha(26),
      disabledColor: borderSubtle,
      labelStyle: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: textPrimary,
        letterSpacing: 0.4,
      ),
      secondaryLabelStyle: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: primaryBlue,
        letterSpacing: 0.4,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: borderSubtle),
      ),
    ), dialogTheme: DialogThemeData(backgroundColor: backgroundWhite),
  );

  /// Dark theme for low-light conditions and battery efficiency
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme(
      brightness: Brightness.dark,
      primary: primaryBlue,
      onPrimary: backgroundDark,
      primaryContainer: primaryBlue.withAlpha(51),
      onPrimaryContainer: primaryBlue,
      secondary: accentTeal,
      onSecondary: backgroundDark,
      secondaryContainer: accentTeal.withAlpha(51),
      onSecondaryContainer: accentTeal,
      tertiary: successGreen,
      onTertiary: backgroundDark,
      tertiaryContainer: successGreen.withAlpha(51),
      onTertiaryContainer: successGreen,
      error: errorRed,
      onError: backgroundDark,
      errorContainer: errorRed.withAlpha(51),
      onErrorContainer: errorRed,
      surface: backgroundDark,
      onSurface: textPrimaryDark,
      onSurfaceVariant: textSecondaryDark,
      outline: borderDark,
      outlineVariant: borderDark.withAlpha(128),
      shadow: shadowDark,
      scrim: backgroundDark.withAlpha(128),
      inverseSurface: backgroundWhite,
      onInverseSurface: textPrimary,
      inversePrimary: primaryBlue,
      surfaceTint: primaryBlue,
    ),
    scaffoldBackgroundColor: backgroundDark,
    cardColor: surfaceDark,
    dividerColor: borderDark,
    appBarTheme: AppBarTheme(
      backgroundColor: backgroundDark,
      foregroundColor: textPrimaryDark,
      elevation: 0,
      shadowColor: shadowDark,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: textPrimaryDark,
        letterSpacing: 0.15,
      ),
      iconTheme: const IconThemeData(
        color: textPrimaryDark,
        size: 24,
      ),
      actionsIconTheme: const IconThemeData(
        color: textPrimaryDark,
        size: 24,
      ),
    ),
    cardTheme: CardTheme(
      color: surfaceDark,
      elevation: 0,
      shadowColor: shadowDark,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: backgroundDark,
      selectedItemColor: primaryBlue,
      unselectedItemColor: textSecondaryDark,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
      selectedLabelStyle: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.4,
      ),
      unselectedLabelStyle: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.4,
      ),
    ),
    navigationRailTheme: NavigationRailThemeData(
      backgroundColor: backgroundDark,
      selectedIconTheme: const IconThemeData(
        color: primaryBlue,
        size: 24,
      ),
      unselectedIconTheme: const IconThemeData(
        color: textSecondaryDark,
        size: 24,
      ),
      selectedLabelTextStyle: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: primaryBlue,
        letterSpacing: 0.4,
      ),
      unselectedLabelTextStyle: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: textSecondaryDark,
        letterSpacing: 0.4,
      ),
      elevation: 0,
      indicatorColor: primaryBlue.withAlpha(51),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primaryBlue,
      foregroundColor: backgroundWhite,
      elevation: 4,
      focusElevation: 6,
      hoverElevation: 8,
      highlightElevation: 12,
      shape: CircleBorder(),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: backgroundWhite,
        backgroundColor: primaryBlue,
        elevation: 2,
        shadowColor: shadowDark,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.1,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryBlue,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        side: const BorderSide(color: primaryBlue, width: 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.1,
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryBlue,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.1,
        ),
      ),
    ),
    textTheme: _buildTextTheme(isLight: false),
    inputDecorationTheme: InputDecorationTheme(
      fillColor: surfaceDark,
      filled: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: borderDark, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: borderDark, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: primaryBlue, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: errorRed, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: errorRed, width: 2),
      ),
      labelStyle: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: textSecondaryDark,
        letterSpacing: 0.25,
      ),
      hintStyle: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: textSecondaryDark.withAlpha(153),
        letterSpacing: 0.25,
      ),
      errorStyle: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: errorRed,
        letterSpacing: 0.4,
      ),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryBlue;
        }
        return textSecondaryDark;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryBlue.withAlpha(77);
        }
        return borderDark;
      }),
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryBlue;
        }
        return Colors.transparent;
      }),
      checkColor: WidgetStateProperty.all(backgroundWhite),
      side: const BorderSide(color: borderDark, width: 2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
    ),
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryBlue;
        }
        return textSecondaryDark;
      }),
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: primaryBlue,
      linearTrackColor: borderDark,
      circularTrackColor: borderDark,
    ),
    sliderTheme: SliderThemeData(
      activeTrackColor: primaryBlue,
      thumbColor: primaryBlue,
      overlayColor: primaryBlue.withAlpha(51),
      inactiveTrackColor: borderDark,
      valueIndicatorColor: primaryBlue,
      valueIndicatorTextStyle: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: backgroundWhite,
      ),
    ),
    tabBarTheme: TabBarTheme(
      labelColor: primaryBlue,
      unselectedLabelColor: textSecondaryDark,
      indicatorColor: primaryBlue,
      indicatorSize: TabBarIndicatorSize.label,
      labelStyle: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
      ),
      unselectedLabelStyle: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.1,
      ),
    ),
    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        color: textPrimaryDark.withAlpha(230),
        borderRadius: BorderRadius.circular(8),
      ),
      textStyle: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: backgroundDark,
        letterSpacing: 0.4,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: cardDark,
      contentTextStyle: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: textPrimaryDark,
        letterSpacing: 0.25,
      ),
      actionTextColor: accentTeal,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      elevation: 4,
    ),
    listTileTheme: ListTileThemeData(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      titleTextStyle: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: textPrimaryDark,
        letterSpacing: 0.15,
      ),
      subtitleTextStyle: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: textSecondaryDark,
        letterSpacing: 0.25,
      ),
      iconColor: textSecondaryDark,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: surfaceDark,
      selectedColor: primaryBlue.withAlpha(51),
      disabledColor: borderDark,
      labelStyle: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: textPrimaryDark,
        letterSpacing: 0.4,
      ),
      secondaryLabelStyle: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: primaryBlue,
        letterSpacing: 0.4,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: borderDark),
      ),
    ), dialogTheme: DialogThemeData(backgroundColor: cardDark),
  );

  /// Helper method to build text theme using Inter font family
  static TextTheme _buildTextTheme({required bool isLight}) {
    final Color textHighEmphasis = isLight ? textPrimary : textPrimaryDark;
    final Color textMediumEmphasis =
        isLight ? textSecondary : textSecondaryDark;
    final Color textLowEmphasis = isLight
        ? textSecondary.withAlpha(153)
        : textSecondaryDark.withAlpha(153);

    return TextTheme(
      // Display styles for large headings
      displayLarge: GoogleFonts.inter(
        fontSize: 57,
        fontWeight: FontWeight.w400,
        color: textHighEmphasis,
        letterSpacing: -0.25,
        height: 1.12,
      ),
      displayMedium: GoogleFonts.inter(
        fontSize: 45,
        fontWeight: FontWeight.w400,
        color: textHighEmphasis,
        letterSpacing: 0,
        height: 1.16,
      ),
      displaySmall: GoogleFonts.inter(
        fontSize: 36,
        fontWeight: FontWeight.w400,
        color: textHighEmphasis,
        letterSpacing: 0,
        height: 1.22,
      ),

      // Headline styles for section headers
      headlineLarge: GoogleFonts.inter(
        fontSize: 32,
        fontWeight: FontWeight.w500,
        color: textHighEmphasis,
        letterSpacing: 0,
        height: 1.25,
      ),
      headlineMedium: GoogleFonts.inter(
        fontSize: 28,
        fontWeight: FontWeight.w500,
        color: textHighEmphasis,
        letterSpacing: 0,
        height: 1.29,
      ),
      headlineSmall: GoogleFonts.inter(
        fontSize: 24,
        fontWeight: FontWeight.w500,
        color: textHighEmphasis,
        letterSpacing: 0,
        height: 1.33,
      ),

      // Title styles for cards and components
      titleLarge: GoogleFonts.inter(
        fontSize: 22,
        fontWeight: FontWeight.w500,
        color: textHighEmphasis,
        letterSpacing: 0,
        height: 1.27,
      ),
      titleMedium: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: textHighEmphasis,
        letterSpacing: 0.15,
        height: 1.50,
      ),
      titleSmall: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: textHighEmphasis,
        letterSpacing: 0.1,
        height: 1.43,
      ),

      // Body styles for content text
      bodyLarge: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: textHighEmphasis,
        letterSpacing: 0.5,
        height: 1.50,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: textHighEmphasis,
        letterSpacing: 0.25,
        height: 1.43,
      ),
      bodySmall: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: textMediumEmphasis,
        letterSpacing: 0.4,
        height: 1.33,
      ),

      // Label styles for buttons and UI elements
      labelLarge: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: textHighEmphasis,
        letterSpacing: 0.1,
        height: 1.43,
      ),
      labelMedium: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: textHighEmphasis,
        letterSpacing: 0.5,
        height: 1.33,
      ),
      labelSmall: GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: textLowEmphasis,
        letterSpacing: 0.5,
        height: 1.45,
      ),
    );
  }

  /// Data text style using JetBrains Mono for numerical precision
  static TextStyle dataTextStyle({
    required bool isLight,
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.w400,
  }) {
    return GoogleFonts.jetBrainsMono(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: isLight ? textPrimary : textPrimaryDark,
      letterSpacing: 0,
      height: 1.4,
    );
  }

  /// Helper method to get appropriate shadow for elevation
  static List<BoxShadow> getElevationShadow({
    required bool isLight,
    double elevation = 2,
  }) {
    if (elevation <= 0) return [];

    final shadowColor = isLight ? shadowLight : shadowDark;
    return [
      BoxShadow(
        color: shadowColor,
        offset: Offset(0, elevation),
        blurRadius: elevation * 2,
        spreadRadius: 0,
      ),
    ];
  }
}
