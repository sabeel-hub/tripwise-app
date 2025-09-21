import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PrivacySectionWidget extends StatefulWidget {
  final Map<String, bool> privacySettings;
  final Function(String key, bool value) onToggleChanged;

  const PrivacySectionWidget({
    super.key,
    required this.privacySettings,
    required this.onToggleChanged,
  });

  @override
  State<PrivacySectionWidget> createState() => _PrivacySectionWidgetState();
}

class _PrivacySectionWidgetState extends State<PrivacySectionWidget> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.white.withValues(alpha: 0.05)
                : Colors.black.withValues(alpha: 0.08),
            offset: const Offset(0, 2),
            blurRadius: 8,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'privacy_tip',
                  color: AppTheme.primaryBlue,
                  size: 24,
                ),
                SizedBox(width: 3.w),
                Text(
                  'Privacy Controls',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
          _buildPrivacyToggle(
            context: context,
            key: 'location_tracking',
            title: 'Location Tracking',
            subtitle:
                'Allow app to collect GPS location data for trip recording',
            lastModified: 'Last modified: Dec 10, 2024',
            isEnabled: widget.privacySettings['location_tracking'] ?? true,
            theme: theme,
          ),
          _buildDivider(theme),
          _buildPrivacyToggle(
            context: context,
            key: 'research_participation',
            title: 'Research Participation',
            subtitle:
                'Share anonymized trip data with transportation researchers',
            lastModified: 'Last modified: Dec 8, 2024',
            isEnabled:
                widget.privacySettings['research_participation'] ?? false,
            theme: theme,
          ),
          _buildDivider(theme),
          _buildPrivacyToggle(
            context: context,
            key: 'analytics_sharing',
            title: 'Analytics & Insights',
            subtitle: 'Allow usage analytics to improve app performance',
            lastModified: 'Last modified: Dec 5, 2024',
            isEnabled: widget.privacySettings['analytics_sharing'] ?? true,
            theme: theme,
          ),
          SizedBox(height: 1.h),
        ],
      ),
    );
  }

  Widget _buildPrivacyToggle({
    required BuildContext context,
    required String key,
    required String title,
    required String subtitle,
    required String lastModified,
    required bool isEnabled,
    required ThemeData theme,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  subtitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  lastModified,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 3.w),
          Switch(
            value: isEnabled,
            onChanged: (value) {
              widget.onToggleChanged(key, value);
            },
            activeColor: AppTheme.primaryBlue,
            inactiveThumbColor:
                theme.colorScheme.onSurface.withValues(alpha: 0.6),
            inactiveTrackColor:
                theme.colorScheme.onSurface.withValues(alpha: 0.2),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider(ThemeData theme) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Divider(
        height: 1,
        thickness: 1,
        color: theme.colorScheme.outline.withValues(alpha: 0.2),
      ),
    );
  }
}
