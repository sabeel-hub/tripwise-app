import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class TripInfoCard extends StatelessWidget {
  final String duration;
  final String distance;
  final String detectedMode;
  final double confidence;

  const TripInfoCard({
    super.key,
    required this.duration,
    required this.distance,
    required this.detectedMode,
    required this.confidence,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            offset: const Offset(0, 2),
            blurRadius: 8,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildInfoItem(
                  icon: 'access_time',
                  label: 'Duration',
                  value: duration,
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: _buildInfoItem(
                  icon: 'straighten',
                  label: 'Distance',
                  value: distance,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          _buildModeDetection(),
        ],
      ),
    );
  }

  Widget _buildInfoItem({
    required String icon,
    required String label,
    required String value,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CustomIconWidget(
              iconName: icon,
              color: AppTheme.textSecondary,
              size: 16,
            ),
            SizedBox(width: 2.w),
            Text(
              label,
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
        SizedBox(height: 1.h),
        Text(
          value,
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildModeDetection() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppTheme.primaryBlue.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: _getModeIcon(detectedMode),
            color: AppTheme.primaryBlue,
            size: 20,
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Detected Mode',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  detectedMode,
                  style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                    color: AppTheme.primaryBlue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          _buildConfidenceIndicator(),
        ],
      ),
    );
  }

  Widget _buildConfidenceIndicator() {
    final color = confidence >= 0.8
        ? AppTheme.successGreen
        : confidence >= 0.6
            ? AppTheme.warningAmber
            : AppTheme.errorRed;

    return Column(
      children: [
        Container(
          width: 8.w,
          height: 8.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withValues(alpha: 0.2),
          ),
          child: Center(
            child: Container(
              width: 4.w,
              height: 4.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color,
              ),
            ),
          ),
        ),
        SizedBox(height: 0.5.h),
        Text(
          '${(confidence * 100).toInt()}%',
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: color,
            fontWeight: FontWeight.w500,
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
        return 'help_outline';
    }
  }
}
