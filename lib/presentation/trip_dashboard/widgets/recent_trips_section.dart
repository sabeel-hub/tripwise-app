import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class RecentTripsSection extends StatelessWidget {
  final List<Map<String, dynamic>> recentTrips;
  final Function(Map<String, dynamic>)? onTripTap;
  final Function(Map<String, dynamic>)? onEditTrip;
  final Function(Map<String, dynamic>)? onShareTrip;
  final Function(Map<String, dynamic>)? onDeleteTrip;
  final Function(Map<String, dynamic>)? onCompleteTrip;

  const RecentTripsSection({
    super.key,
    required this.recentTrips,
    this.onTripTap,
    this.onEditTrip,
    this.onShareTrip,
    this.onDeleteTrip,
    this.onCompleteTrip,
  });

  @override
  Widget build(BuildContext context) {
    if (recentTrips.isEmpty) {
      return _buildEmptyState();
    }

    return Container(
      width: 90.w,
      margin: EdgeInsets.symmetric(horizontal: 5.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Trips',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pushNamed(context, '/trip-history'),
                child: Text(
                  'View All',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.primaryBlue,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: recentTrips.length > 5 ? 5 : recentTrips.length,
            separatorBuilder: (context, index) => SizedBox(height: 2.h),
            itemBuilder: (context, index) {
              final trip = recentTrips[index];
              return _buildTripCard(context, trip);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTripCard(BuildContext context, Map<String, dynamic> trip) {
    final isIncomplete = trip['status'] == 'incomplete';

    return Slidable(
      key: ValueKey(trip['id']),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) => onEditTrip?.call(trip),
            backgroundColor: AppTheme.primaryBlue,
            foregroundColor: AppTheme.backgroundWhite,
            icon: Icons.edit,
            label: 'Edit',
          ),
          SlidableAction(
            onPressed: (context) => onShareTrip?.call(trip),
            backgroundColor: AppTheme.successGreen,
            foregroundColor: AppTheme.backgroundWhite,
            icon: Icons.share,
            label: 'Share',
          ),
          SlidableAction(
            onPressed: (context) => onDeleteTrip?.call(trip),
            backgroundColor: AppTheme.errorRed,
            foregroundColor: AppTheme.backgroundWhite,
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),
      child: GestureDetector(
        onTap: () => onTripTap?.call(trip),
        child: Container(
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: AppTheme.surfaceGray,
            borderRadius: BorderRadius.circular(12),
            border: isIncomplete
                ? Border.all(color: AppTheme.warningAmber, width: 1)
                : null,
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      color: _getModeColor(trip['mode'] as String)
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: CustomIconWidget(
                      iconName: _getModeIcon(trip['mode'] as String),
                      color: _getModeColor(trip['mode'] as String),
                      size: 20,
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                trip['origin'] as String,
                                style: AppTheme.lightTheme.textTheme.titleSmall
                                    ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (isIncomplete)
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 2.w,
                                  vertical: 0.5.h,
                                ),
                                decoration: BoxDecoration(
                                  color: AppTheme.warningAmber
                                      .withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  'Incomplete',
                                  style: AppTheme.lightTheme.textTheme.bodySmall
                                      ?.copyWith(
                                    color: AppTheme.warningAmber,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        SizedBox(height: 0.5.h),
                        Row(
                          children: [
                            CustomIconWidget(
                              iconName: 'arrow_downward',
                              color: AppTheme.textSecondary,
                              size: 12,
                            ),
                            SizedBox(width: 1.w),
                            Expanded(
                              child: Text(
                                trip['destination'] as String,
                                style: AppTheme.lightTheme.textTheme.bodySmall
                                    ?.copyWith(
                                  color: AppTheme.textSecondary,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 2.h),
              Row(
                children: [
                  Expanded(
                    child: _buildTripStat(
                      'schedule',
                      _formatDuration(trip['duration'] as int),
                    ),
                  ),
                  Expanded(
                    child: _buildTripStat(
                      'straighten',
                      '${(trip['distance'] as double).toStringAsFixed(1)} km',
                    ),
                  ),
                  Expanded(
                    child: _buildTripStat(
                      'calendar_today',
                      _formatDate(trip['date'] as DateTime),
                    ),
                  ),
                  if (isIncomplete)
                    GestureDetector(
                      onTap: () => onCompleteTrip?.call(trip),
                      child: Container(
                        padding: EdgeInsets.all(2.w),
                        decoration: BoxDecoration(
                          color: AppTheme.warningAmber.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: CustomIconWidget(
                          iconName: 'check_circle_outline',
                          color: AppTheme.warningAmber,
                          size: 20,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTripStat(String iconName, String value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomIconWidget(
          iconName: iconName,
          color: AppTheme.textSecondary,
          size: 14,
        ),
        SizedBox(width: 1.w),
        Flexible(
          child: Text(
            value,
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.textSecondary,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: 90.w,
      margin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 4.h),
      padding: EdgeInsets.all(6.w),
      decoration: BoxDecoration(
        color: AppTheme.surfaceGray,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          CustomIconWidget(
            iconName: 'map',
            color: AppTheme.textSecondary,
            size: 48,
          ),
          SizedBox(height: 2.h),
          Text(
            'No trips yet',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Start your first trip to see it here',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
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

  Color _getModeColor(String mode) {
    switch (mode.toLowerCase()) {
      case 'walk':
        return AppTheme.successGreen;
      case 'bus':
        return AppTheme.primaryBlue;
      case 'car':
        return AppTheme.errorRed;
      case 'train':
        return AppTheme.accentTeal;
      case 'bicycle':
        return AppTheme.successGreen;
      case 'motorcycle':
        return AppTheme.warningAmber;
      case 'rideshare':
        return AppTheme.warningAmber;
      case 'flight':
        return AppTheme.primaryBlue;
      case 'boat':
        return AppTheme.accentTeal;
      default:
        return AppTheme.textSecondary;
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

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${date.month}/${date.day}';
    }
  }
}
