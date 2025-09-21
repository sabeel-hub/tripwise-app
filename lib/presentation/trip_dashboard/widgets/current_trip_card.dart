import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CurrentTripCard extends StatelessWidget {
  final Map<String, dynamic>? currentTrip;
  final VoidCallback? onEndTrip;

  const CurrentTripCard({
    super.key,
    this.currentTrip,
    this.onEndTrip,
  });

  @override
  Widget build(BuildContext context) {
    if (currentTrip == null) return const SizedBox.shrink();

    final duration = _formatDuration(currentTrip!['duration'] as int);
    final distance = currentTrip!['distance'] as double;
    final mode = currentTrip!['mode'] as String;

    return Container(
      width: 90.w,
      margin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.primaryBlue.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: AppTheme.primaryBlue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: CustomIconWidget(
                  iconName: _getModeIcon(mode),
                  color: AppTheme.primaryBlue,
                  size: 20,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Trip in Progress',
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        color: AppTheme.primaryBlue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'Started ${_formatTime(currentTrip!['startTime'] as DateTime)}',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 3.w,
                height: 3.w,
                decoration: const BoxDecoration(
                  color: AppTheme.successGreen,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  'Duration',
                  duration,
                  'schedule',
                ),
              ),
              Container(
                width: 1,
                height: 4.h,
                color: AppTheme.borderSubtle,
              ),
              Expanded(
                child: _buildStatItem(
                  'Distance',
                  '${distance.toStringAsFixed(1)} km',
                  'straighten',
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onEndTrip,
              icon: CustomIconWidget(
                iconName: 'stop',
                color: AppTheme.backgroundWhite,
                size: 18,
              ),
              label: Text(
                'End Trip',
                style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                  color: AppTheme.backgroundWhite,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.errorRed,
                padding: EdgeInsets.symmetric(vertical: 1.5.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, String iconName) {
    return Column(
      children: [
        CustomIconWidget(
          iconName: iconName,
          color: AppTheme.textSecondary,
          size: 20,
        ),
        SizedBox(height: 1.h),
        Text(
          value,
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.textSecondary,
          ),
        ),
      ],
    );
  }

  String _getModeIcon(String mode) {
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
        return 'location_on';
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

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}
