import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Navigation item data for bottom navigation bar
class BottomNavItem {
  final String route;
  final IconData icon;
  final IconData? activeIcon;
  final String label;
  final String tooltip;

  const BottomNavItem({
    required this.route,
    required this.icon,
    this.activeIcon,
    required this.label,
    required this.tooltip,
  });
}

/// Custom bottom navigation bar implementing Contemporary Spatial Minimalism
/// with adaptive behavior and contextual navigation for travel data collection app.
class CustomBottomBar extends StatelessWidget {
  /// Current active route
  final String currentRoute;

  /// Callback when navigation item is tapped
  final Function(String route)? onTap;

  /// Whether to show labels on all items
  final bool showLabels;

  /// Custom background color
  final Color? backgroundColor;

  /// Whether to show elevation
  final bool showElevation;

  const CustomBottomBar({
    super.key,
    required this.currentRoute,
    this.onTap,
    this.showLabels = true,
    this.backgroundColor,
    this.showElevation = true,
  });

  /// Navigation items for the travel data collection app
  static const List<BottomNavItem> _navItems = [
    BottomNavItem(
      route: '/trip-dashboard',
      icon: Icons.dashboard_outlined,
      activeIcon: Icons.dashboard,
      label: 'Dashboard',
      tooltip: 'Trip Dashboard',
    ),
    BottomNavItem(
      route: '/active-trip-tracking',
      icon: Icons.navigation_outlined,
      activeIcon: Icons.navigation,
      label: 'Active',
      tooltip: 'Active Trip Tracking',
    ),
    BottomNavItem(
      route: '/trip-history',
      icon: Icons.history_outlined,
      activeIcon: Icons.history,
      label: 'History',
      tooltip: 'Trip History',
    ),
    BottomNavItem(
      route: '/manual-trip-entry',
      icon: Icons.add_location_outlined,
      activeIcon: Icons.add_location,
      label: 'Add Trip',
      tooltip: 'Manual Trip Entry',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Find current index
    final currentIndex =
        _navItems.indexWhere((item) => item.route == currentRoute);
    final validIndex = currentIndex >= 0 ? currentIndex : 0;

    return Container(
      decoration: BoxDecoration(
        color:
            backgroundColor ?? theme.bottomNavigationBarTheme.backgroundColor,
        boxShadow: showElevation
            ? [
                BoxShadow(
                  color: isDark
                      ? Colors.white.withAlpha(13)
                      : Colors.black.withAlpha(20),
                  offset: const Offset(0, -2),
                  blurRadius: 8,
                  spreadRadius: 0,
                ),
              ]
            : null,
      ),
      child: SafeArea(
        child: BottomNavigationBar(
          currentIndex: validIndex,
          onTap: (index) {
            final selectedRoute = _navItems[index].route;
            if (selectedRoute != currentRoute) {
              if (onTap != null) {
                onTap!(selectedRoute);
              } else {
                Navigator.pushReplacementNamed(context, selectedRoute);
              }
            }
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: theme.colorScheme.primary,
          unselectedItemColor: theme.colorScheme.onSurface.withAlpha(153),
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
          showSelectedLabels: showLabels,
          showUnselectedLabels: showLabels,
          items: _navItems.map((item) {
            final isSelected = item.route == currentRoute;
            return BottomNavigationBarItem(
              icon: _buildNavIcon(
                icon: item.icon,
                activeIcon: item.activeIcon,
                isSelected: isSelected,
                theme: theme,
              ),
              label: item.label,
              tooltip: item.tooltip,
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildNavIcon({
    required IconData icon,
    IconData? activeIcon,
    required bool isSelected,
    required ThemeData theme,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected
            ? theme.colorScheme.primary.withAlpha(26)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(16),
      ),
      child: AnimatedScale(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        scale: isSelected ? 1.1 : 1.0,
        child: Icon(
          isSelected && activeIcon != null ? activeIcon : icon,
          size: 24,
          color: isSelected
              ? theme.colorScheme.primary
              : theme.colorScheme.onSurface.withAlpha(153),
        ),
      ),
    );
  }

  /// Factory constructor for dashboard context
  factory CustomBottomBar.dashboard({
    Key? key,
    Function(String route)? onTap,
  }) {
    return CustomBottomBar(
      key: key,
      currentRoute: '/trip-dashboard',
      onTap: onTap,
    );
  }

  /// Factory constructor for active trip context
  factory CustomBottomBar.activeTrip({
    Key? key,
    Function(String route)? onTap,
  }) {
    return CustomBottomBar(
      key: key,
      currentRoute: '/active-trip-tracking',
      onTap: onTap,
    );
  }

  /// Factory constructor for history context
  factory CustomBottomBar.history({
    Key? key,
    Function(String route)? onTap,
  }) {
    return CustomBottomBar(
      key: key,
      currentRoute: '/trip-history',
      onTap: onTap,
    );
  }

  /// Factory constructor for manual entry context
  factory CustomBottomBar.manualEntry({
    Key? key,
    Function(String route)? onTap,
  }) {
    return CustomBottomBar(
      key: key,
      currentRoute: '/manual-trip-entry',
      onTap: onTap,
    );
  }

  /// Factory constructor with minimal labels for compact screens
  factory CustomBottomBar.compact({
    Key? key,
    required String currentRoute,
    Function(String route)? onTap,
  }) {
    return CustomBottomBar(
      key: key,
      currentRoute: currentRoute,
      onTap: onTap,
      showLabels: false,
    );
  }

  /// Check if the given route is a valid bottom navigation route
  static bool isValidRoute(String route) {
    return _navItems.any((item) => item.route == route);
  }

  /// Get the navigation item for a given route
  static BottomNavItem? getNavItem(String route) {
    try {
      return _navItems.firstWhere((item) => item.route == route);
    } catch (e) {
      return null;
    }
  }

  /// Get all available navigation routes
  static List<String> get availableRoutes {
    return _navItems.map((item) => item.route).toList();
  }
}
