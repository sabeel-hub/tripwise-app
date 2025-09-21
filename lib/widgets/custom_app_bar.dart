import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Custom app bar widget implementing Contemporary Spatial Minimalism design
/// with contextual actions and adaptive behavior for travel data collection app.
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// The title to display in the app bar
  final String title;

  /// Whether to show the back button (automatically determined if not specified)
  final bool? showBackButton;

  /// Custom leading widget (overrides back button)
  final Widget? leading;

  /// List of action widgets to display on the right
  final List<Widget>? actions;

  /// Whether to show elevation shadow
  final bool showElevation;

  /// Background color override
  final Color? backgroundColor;

  /// Text color override
  final Color? foregroundColor;

  /// Whether this app bar is for a modal/dialog context
  final bool isModal;

  const CustomAppBar({
    super.key,
    required this.title,
    this.showBackButton,
    this.leading,
    this.actions,
    this.showElevation = false,
    this.backgroundColor,
    this.foregroundColor,
    this.isModal = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Determine if we should show back button
    final shouldShowBack = showBackButton ??
        (leading == null && ModalRoute.of(context)?.canPop == true);

    return AppBar(
      title: Text(
        title,
        style: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: foregroundColor ?? theme.appBarTheme.foregroundColor,
          letterSpacing: 0.15,
        ),
      ),
      leading: leading ??
          (shouldShowBack ? _buildBackButton(context, isDark) : null),
      actions: actions,
      backgroundColor: backgroundColor ?? theme.appBarTheme.backgroundColor,
      foregroundColor: foregroundColor ?? theme.appBarTheme.foregroundColor,
      elevation: showElevation ? 2 : 0,
      shadowColor:
          isDark ? Colors.white.withAlpha(26) : Colors.black.withAlpha(26),
      surfaceTintColor: Colors.transparent,
      centerTitle: false,
      titleSpacing: leading == null && !shouldShowBack ? 16 : null,
      automaticallyImplyLeading: false,
    );
  }

  Widget _buildBackButton(BuildContext context, bool isDark) {
    return IconButton(
      onPressed: () => Navigator.of(context).pop(),
      icon: Icon(
        isModal ? Icons.close : Icons.arrow_back,
        size: 24,
        color: foregroundColor ??
            (isDark ? Colors.white : const Color(0xFF1A1A1A)),
      ),
      tooltip: isModal ? 'Close' : 'Back',
      splashRadius: 20,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  /// Factory constructor for trip dashboard app bar
  factory CustomAppBar.dashboard({
    Key? key,
    List<Widget>? actions,
  }) {
    return CustomAppBar(
      key: key,
      title: 'Trip Dashboard',
      showBackButton: false,
      actions: actions ??
          [
            Builder(
              builder: (context) => IconButton(
                onPressed: () =>
                    Navigator.pushNamed(context, '/settings-and-privacy'),
                icon: const Icon(Icons.settings_outlined, size: 24),
                tooltip: 'Settings',
                splashRadius: 20,
              ),
            ),
          ],
    );
  }

  /// Factory constructor for active trip tracking app bar
  factory CustomAppBar.activeTrip({
    Key? key,
    VoidCallback? onStopTrip,
  }) {
    return CustomAppBar(
      key: key,
      title: 'Active Trip',
      actions: [
        if (onStopTrip != null)
          Builder(
            builder: (context) => TextButton.icon(
              onPressed: onStopTrip,
              icon: const Icon(Icons.stop, size: 18),
              label: const Text('Stop'),
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFFF44336),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            ),
          ),
      ],
    );
  }

  /// Factory constructor for trip history app bar
  factory CustomAppBar.history({
    Key? key,
    VoidCallback? onFilter,
    VoidCallback? onSearch,
  }) {
    return CustomAppBar(
      key: key,
      title: 'Trip History',
      actions: [
        if (onSearch != null)
          Builder(
            builder: (context) => IconButton(
              onPressed: onSearch,
              icon: const Icon(Icons.search, size: 24),
              tooltip: 'Search trips',
              splashRadius: 20,
            ),
          ),
        if (onFilter != null)
          Builder(
            builder: (context) => IconButton(
              onPressed: onFilter,
              icon: const Icon(Icons.filter_list, size: 24),
              tooltip: 'Filter trips',
              splashRadius: 20,
            ),
          ),
      ],
    );
  }

  /// Factory constructor for trip detail view app bar
  factory CustomAppBar.tripDetail({
    Key? key,
    VoidCallback? onEdit,
    VoidCallback? onShare,
    VoidCallback? onDelete,
  }) {
    return CustomAppBar(
      key: key,
      title: 'Trip Details',
      actions: [
        if (onShare != null)
          Builder(
            builder: (context) => IconButton(
              onPressed: onShare,
              icon: const Icon(Icons.share_outlined, size: 24),
              tooltip: 'Share trip',
              splashRadius: 20,
            ),
          ),
        if (onEdit != null || onDelete != null)
          Builder(
            builder: (context) => PopupMenuButton<String>(
              onSelected: (value) {
                switch (value) {
                  case 'edit':
                    onEdit?.call();
                    break;
                  case 'delete':
                    onDelete?.call();
                    break;
                }
              },
              itemBuilder: (context) => [
                if (onEdit != null)
                  const PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit_outlined, size: 20),
                        SizedBox(width: 12),
                        Text('Edit Trip'),
                      ],
                    ),
                  ),
                if (onDelete != null)
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete_outline,
                            size: 20, color: Color(0xFFF44336)),
                        SizedBox(width: 12),
                        Text('Delete Trip',
                            style: TextStyle(color: Color(0xFFF44336))),
                      ],
                    ),
                  ),
              ],
              icon: const Icon(Icons.more_vert, size: 24),
              tooltip: 'More options',
            ),
          ),
      ],
    );
  }

  /// Factory constructor for manual trip entry app bar
  factory CustomAppBar.manualEntry({
    Key? key,
    VoidCallback? onSave,
    bool canSave = false,
  }) {
    return CustomAppBar(
      key: key,
      title: 'Add Trip',
      actions: [
        if (onSave != null)
          Builder(
            builder: (context) => TextButton(
              onPressed: canSave ? onSave : null,
              child: Text(
                'Save',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.1,
                ),
              ),
            ),
          ),
      ],
    );
  }

  /// Factory constructor for settings app bar
  factory CustomAppBar.settings({
    Key? key,
  }) {
    return CustomAppBar(
      key: key,
      title: 'Settings & Privacy',
    );
  }

  /// Factory constructor for modal/dialog contexts
  factory CustomAppBar.modal({
    Key? key,
    required String title,
    List<Widget>? actions,
    Color? backgroundColor,
  }) {
    return CustomAppBar(
      key: key,
      title: title,
      isModal: true,
      actions: actions,
      backgroundColor: backgroundColor,
      showElevation: true,
    );
  }
}