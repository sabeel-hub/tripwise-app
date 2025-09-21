import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class TripTimelineWidget extends StatelessWidget {
  final Map<String, dynamic> tripData;

  const TripTimelineWidget({
    super.key,
    required this.tripData,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final timelineEvents = tripData['timeline'] as List<dynamic>? ?? [];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.surfaceDark : AppTheme.surfaceGray,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppTheme.getElevationShadow(
          isLight: !isDark,
          elevation: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'timeline',
                color: AppTheme.primaryBlue,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                'Trip Timeline',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 16.sp,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          timelineEvents.isNotEmpty
              ? ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: timelineEvents.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final event = timelineEvents[index] as Map<String, dynamic>;
                    return _buildTimelineItem(context, event, isDark);
                  },
                )
              : _buildEmptyTimeline(context, isDark),
        ],
      ),
    );
  }

  Widget _buildTimelineItem(
      BuildContext context, Map<String, dynamic> event, bool isDark) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: _getEventColor(event['type'] as String),
                shape: BoxShape.circle,
              ),
            ),
            if (event != (tripData['timeline'] as List).last)
              Container(
                width: 2,
                height: 40,
                color: isDark ? AppTheme.borderDark : AppTheme.borderSubtle,
              ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    event['time'] as String,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: 12.sp,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: _getEventColor(event['type'] as String)
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      event['type'] as String,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: _getEventColor(event['type'] as String),
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                event['description'] as String,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: isDark
                      ? AppTheme.textSecondaryDark
                      : AppTheme.textSecondary,
                  fontSize: 11.sp,
                ),
              ),
              if (event['speed'] != null) ...[
                const SizedBox(height: 4),
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'speed',
                      color: isDark
                          ? AppTheme.textSecondaryDark
                          : AppTheme.textSecondary,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Speed: ${event['speed']} km/h',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: isDark
                            ? AppTheme.textSecondaryDark
                            : AppTheme.textSecondary,
                        fontSize: 10.sp,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyTimeline(BuildContext context, bool isDark) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          CustomIconWidget(
            iconName: 'timeline',
            color: isDark ? AppTheme.textSecondaryDark : AppTheme.textSecondary,
            size: 48,
          ),
          const SizedBox(height: 16),
          Text(
            'No Timeline Data',
            style: theme.textTheme.titleMedium?.copyWith(
              color:
                  isDark ? AppTheme.textSecondaryDark : AppTheme.textSecondary,
              fontSize: 14.sp,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Timeline information is not available for this trip.',
            style: theme.textTheme.bodySmall?.copyWith(
              color:
                  isDark ? AppTheme.textSecondaryDark : AppTheme.textSecondary,
              fontSize: 11.sp,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Color _getEventColor(String eventType) {
    switch (eventType.toLowerCase()) {
      case 'start':
        return AppTheme.successGreen;
      case 'stop':
        return AppTheme.errorRed;
      case 'pause':
        return AppTheme.warningAmber;
      case 'mode_change':
        return AppTheme.primaryBlue;
      case 'waypoint':
        return AppTheme.accentTeal;
      default:
        return AppTheme.textSecondary;
    }
  }
}
