import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class TripSummaryCardWidget extends StatelessWidget {
  final Map<String, dynamic> tripData;

  const TripSummaryCardWidget({
    super.key,
    required this.tripData,
  });

  String _getTravelModeIcon(String mode) {
    switch (mode.toLowerCase()) {
      case 'walk':
        return 'directions_walk';
      case 'bus':
        return 'directions_bus';
      case 'car':
        return 'directions_car';
      case 'train':
        return 'train';
      case 'bicycle':
        return 'directions_bike';
      case 'motorcycle':
        return 'motorcycle';
      case 'rideshare':
        return 'local_taxi';
      case 'flight':
        return 'flight';
      case 'boat':
        return 'directions_boat';
      default:
        return 'directions';
    }
  }

  String _formatDuration(int minutes) {
    if (minutes < 60) {
      return '${minutes}m';
    } else {
      final hours = minutes ~/ 60;
      final remainingMinutes = minutes % 60;
      return remainingMinutes > 0
          ? '${hours}h ${remainingMinutes}m'
          : '${hours}h';
    }
  }

  String _formatDistance(double kilometers) {
    if (kilometers < 1) {
      return '${(kilometers * 1000).toInt()}m';
    } else {
      return '${kilometers.toStringAsFixed(1)} km';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: double.infinity,
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
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.primaryBlue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: CustomIconWidget(
                  iconName:
                      _getTravelModeIcon(tripData['travelMode'] as String),
                  color: AppTheme.primaryBlue,
                  size: 32,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tripData['travelMode'] as String,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 16.sp,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${tripData['date']} • ${tripData['startTime']} - ${tripData['endTime']}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: isDark
                            ? AppTheme.textSecondaryDark
                            : AppTheme.textSecondary,
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  context,
                  'Duration',
                  _formatDuration(tripData['duration'] as int),
                  'schedule',
                  isDark,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatItem(
                  context,
                  'Distance',
                  _formatDistance((tripData['distance'] as num).toDouble()),
                  'straighten',
                  isDark,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatItem(
                  context,
                  'Companions',
                  '${tripData['companionCount'] ?? 0}',
                  'group',
                  isDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color:
                  (isDark ? AppTheme.backgroundDark : AppTheme.backgroundWhite)
                      .withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isDark ? AppTheme.borderDark : AppTheme.borderSubtle,
                width: 1,
              ),
            ),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'location_on',
                  color: AppTheme.successGreen,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    tripData['origin']['address'] as String,
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontSize: 11.sp,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color:
                  (isDark ? AppTheme.backgroundDark : AppTheme.backgroundWhite)
                      .withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isDark ? AppTheme.borderDark : AppTheme.borderSubtle,
                width: 1,
              ),
            ),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'flag',
                  color: AppTheme.errorRed,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    tripData['destination']['address'] as String,
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontSize: 11.sp,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    String label,
    String value,
    String iconName,
    bool isDark,
  ) {
    return Column(
      children: [
        CustomIconWidget(
          iconName: iconName,
          color: isDark ? AppTheme.textSecondaryDark : AppTheme.textSecondary,
          size: 20,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 14.sp,
              ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: isDark
                    ? AppTheme.textSecondaryDark
                    : AppTheme.textSecondary,
                fontSize: 10.sp,
              ),
        ),
      ],
    );
  }
}
