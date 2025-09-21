import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class NotificationPreferencesWidget extends StatelessWidget {
  final Map<String, bool> notificationSettings;
  final Map<String, String> timingSettings;
  final Function(String key, bool value) onNotificationToggle;
  final Function(String key, String value) onTimingChanged;

  const NotificationPreferencesWidget({
    super.key,
    required this.notificationSettings,
    required this.timingSettings,
    required this.onNotificationToggle,
    required this.onTimingChanged,
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
                  iconName: 'notifications',
                  color: AppTheme.warningAmber,
                  size: 24,
                ),
                SizedBox(width: 3.w),
                Text(
                  'Notifications',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
          _buildNotificationToggle(
            context: context,
            theme: theme,
            key: 'trip_reminders',
            title: 'Trip Reminders',
            subtitle: 'Remind me to start tracking trips',
            timing: timingSettings['trip_reminders'] ?? '15 minutes',
            isEnabled: notificationSettings['trip_reminders'] ?? true,
          ),
          _buildDivider(theme),
          _buildNotificationToggle(
            context: context,
            theme: theme,
            key: 'completion_prompts',
            title: 'Completion Prompts',
            subtitle: 'Notify when trip tracking stops',
            timing: timingSettings['completion_prompts'] ?? 'Immediate',
            isEnabled: notificationSettings['completion_prompts'] ?? true,
          ),
          _buildDivider(theme),
          _buildNotificationToggle(
            context: context,
            theme: theme,
            key: 'research_updates',
            title: 'Research Updates',
            subtitle: 'Updates about transportation research',
            timing: timingSettings['research_updates'] ?? 'Weekly',
            isEnabled: notificationSettings['research_updates'] ?? false,
          ),
          SizedBox(height: 1.h),
        ],
      ),
    );
  }

  Widget _buildNotificationToggle({
    required BuildContext context,
    required ThemeData theme,
    required String key,
    required String title,
    required String subtitle,
    required String timing,
    required bool isEnabled,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Column(
        children: [
          Row(
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
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 3.w),
              Switch(
                value: isEnabled,
                onChanged: (value) => onNotificationToggle(key, value),
                activeColor: AppTheme.primaryBlue,
              ),
            ],
          ),
          if (isEnabled) ...[
            SizedBox(height: 1.h),
            Row(
              children: [
                Text(
                  'Timing: ',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
                GestureDetector(
                  onTap: () => _showTimingSelector(context, key, timing),
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryBlue.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: AppTheme.primaryBlue.withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          timing,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: AppTheme.primaryBlue,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(width: 1.w),
                        CustomIconWidget(
                          iconName: 'keyboard_arrow_down',
                          color: AppTheme.primaryBlue,
                          size: 16,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  void _showTimingSelector(
      BuildContext context, String key, String currentTiming) {
    final List<String> timingOptions = key == 'trip_reminders'
        ? ['5 minutes', '15 minutes', '30 minutes', '1 hour']
        : key == 'completion_prompts'
            ? ['Immediate', '5 minutes', '15 minutes']
            : ['Daily', 'Weekly', 'Monthly'];

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        final theme = Theme.of(context);
        return Container(
          padding: EdgeInsets.all(4.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select Timing',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 2.h),
              ...timingOptions.map((option) => ListTile(
                    title: Text(option),
                    trailing: currentTiming == option
                        ? CustomIconWidget(
                            iconName: 'check',
                            color: AppTheme.primaryBlue,
                            size: 20,
                          )
                        : null,
                    onTap: () {
                      onTimingChanged(key, option);
                      Navigator.pop(context);
                    },
                  )),
              SizedBox(height: 2.h),
            ],
          ),
        );
      },
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
