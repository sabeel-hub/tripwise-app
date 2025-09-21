import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class WeeklyStatsCard extends StatefulWidget {
  final Map<String, dynamic> weeklyStats;
  final VoidCallback? onTap;

  const WeeklyStatsCard({
    super.key,
    required this.weeklyStats,
    this.onTap,
  });

  @override
  State<WeeklyStatsCard> createState() => _WeeklyStatsCardState();
}

class _WeeklyStatsCardState extends State<WeeklyStatsCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90.w,
      margin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'This Week',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          GestureDetector(
            onTap: _toggleExpanded,
            child: Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.primaryBlue.withValues(alpha: 0.1),
                    AppTheme.accentTeal.withValues(alpha: 0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppTheme.primaryBlue.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildMainStat(
                          'Total Distance',
                          '${(widget.weeklyStats['totalDistance'] as double).toStringAsFixed(1)} km',
                          'straighten',
                          AppTheme.primaryBlue,
                        ),
                      ),
                      Container(
                        width: 1,
                        height: 6.h,
                        color: AppTheme.borderSubtle,
                      ),
                      Expanded(
                        child: _buildMainStat(
                          'Total Trips',
                          '${widget.weeklyStats['totalTrips']}',
                          'trip_origin',
                          AppTheme.successGreen,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Carbon Footprint: ${(widget.weeklyStats['carbonFootprint'] as double).toStringAsFixed(1)} kg CO₂',
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color: AppTheme.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      AnimatedRotation(
                        turns: _isExpanded ? 0.5 : 0,
                        duration: const Duration(milliseconds: 300),
                        child: CustomIconWidget(
                          iconName: 'expand_more',
                          color: AppTheme.textSecondary,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                  AnimatedBuilder(
                    animation: _expandAnimation,
                    builder: (context, child) {
                      return SizeTransition(
                        sizeFactor: _expandAnimation,
                        child: child,
                      );
                    },
                    child: Column(
                      children: [
                        SizedBox(height: 2.h),
                        Divider(color: AppTheme.borderSubtle),
                        SizedBox(height: 2.h),
                        _buildExpandedStats(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainStat(
      String label, String value, String iconName, Color color) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(3.w),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: CustomIconWidget(
            iconName: iconName,
            color: color,
            size: 24,
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          value,
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildExpandedStats() {
    final modeBreakdown =
        widget.weeklyStats['modeBreakdown'] as Map<String, dynamic>;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Travel Mode Breakdown',
          style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 2.h),
        ...modeBreakdown.entries.map((entry) {
          final mode = entry.key;
          final data = entry.value as Map<String, dynamic>;
          final percentage = (data['percentage'] as double);

          return Container(
            margin: EdgeInsets.only(bottom: 1.h),
            child: Column(
              children: [
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: _getModeIcon(mode),
                      color: _getModeColor(mode),
                      size: 16,
                    ),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: Text(
                        mode.toUpperCase(),
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Text(
                      '${percentage.toStringAsFixed(0)}%',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 0.5.h),
                LinearProgressIndicator(
                  value: percentage / 100,
                  backgroundColor: AppTheme.borderSubtle,
                  valueColor:
                      AlwaysStoppedAnimation<Color>(_getModeColor(mode)),
                  minHeight: 4,
                ),
              ],
            ),
          );
        }).toList(),
        SizedBox(height: 2.h),
        Row(
          children: [
            Expanded(
              child: _buildDetailStat(
                'Avg Trip Duration',
                '${widget.weeklyStats['avgDuration']} min',
                'schedule',
              ),
            ),
            Expanded(
              child: _buildDetailStat(
                'Longest Trip',
                '${(widget.weeklyStats['longestTrip'] as double).toStringAsFixed(1)} km',
                'trending_up',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDetailStat(String label, String value, String iconName) {
    return Row(
      children: [
        CustomIconWidget(
          iconName: iconName,
          color: AppTheme.textSecondary,
          size: 16,
        ),
        SizedBox(width: 2.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
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
}
