import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class LocationSettingsWidget extends StatelessWidget {
  final String accuracyLevel;
  final bool backgroundTracking;
  final Function(String) onAccuracyChanged;
  final VoidCallback onBackgroundToggle;
  final VoidCallback onSystemSettings;

  const LocationSettingsWidget({
    super.key,
    required this.accuracyLevel,
    required this.backgroundTracking,
    required this.onAccuracyChanged,
    required this.onBackgroundToggle,
    required this.onSystemSettings,
  });

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
                  iconName: 'location_on',
                  color: AppTheme.successGreen,
                  size: 24,
                ),
                SizedBox(width: 3.w),
                Text(
                  'Location Settings',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
          _buildAccuracySelector(context, theme),
          _buildDivider(theme),
          _buildBackgroundTrackingToggle(context, theme),
          _buildDivider(theme),
          _buildSystemSettingsButton(context, theme),
          SizedBox(height: 1.h),
        ],
      ),
    );
  }

  Widget _buildAccuracySelector(BuildContext context, ThemeData theme) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Location Accuracy',
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w500,
              color: theme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 1.h),
          Row(
            children: [
              Expanded(
                child: _buildAccuracyOption(
                  context: context,
                  theme: theme,
                  value: 'high',
                  label: 'High',
                  description: 'GPS + Network',
                  isSelected: accuracyLevel == 'high',
                ),
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: _buildAccuracyOption(
                  context: context,
                  theme: theme,
                  value: 'medium',
                  label: 'Medium',
                  description: 'Network only',
                  isSelected: accuracyLevel == 'medium',
                ),
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: _buildAccuracyOption(
                  context: context,
                  theme: theme,
                  value: 'low',
                  label: 'Low',
                  description: 'Battery saver',
                  isSelected: accuracyLevel == 'low',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAccuracyOption({
    required BuildContext context,
    required ThemeData theme,
    required String value,
    required String label,
    required String description,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () => onAccuracyChanged(value),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.5.h),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.primaryBlue.withValues(alpha: 0.1)
              : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? AppTheme.primaryBlue
                : theme.colorScheme.outline.withValues(alpha: 0.3),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: theme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: isSelected
                    ? AppTheme.primaryBlue
                    : theme.colorScheme.onSurface,
              ),
            ),
            SizedBox(height: 0.5.h),
            Text(
              description,
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackgroundTrackingToggle(BuildContext context, ThemeData theme) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Background Tracking',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  'Continue tracking when app is in background',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
                if (backgroundTracking) ...[
                  SizedBox(height: 0.5.h),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                    decoration: BoxDecoration(
                      color: AppTheme.successGreen.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'Active',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: AppTheme.successGreen,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          SizedBox(width: 3.w),
          Switch(
            value: backgroundTracking,
            onChanged: (_) => onBackgroundToggle(),
            activeColor: AppTheme.primaryBlue,
          ),
        ],
      ),
    );
  }

  Widget _buildSystemSettingsButton(BuildContext context, ThemeData theme) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: OutlinedButton.icon(
        onPressed: onSystemSettings,
        icon: CustomIconWidget(
          iconName: 'settings',
          color: theme.colorScheme.primary,
          size: 18,
        ),
        label: Text(
          'Open System Settings',
          style: theme.textTheme.labelLarge?.copyWith(
            color: theme.colorScheme.primary,
          ),
        ),
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          side: BorderSide(
            color: theme.colorScheme.primary,
            width: 1,
          ),
        ),
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
