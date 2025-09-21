import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class GpsAccuracyIndicator extends StatelessWidget {
  final double accuracy;
  final bool isLocationEnabled;

  const GpsAccuracyIndicator({
    super.key,
    required this.accuracy,
    required this.isLocationEnabled,
  });

  @override
  Widget build(BuildContext context) {
    if (!isLocationEnabled) {
      return _buildLocationDisabledIndicator();
    }

    final signalStrength = _getSignalStrength(accuracy);
    final color = _getSignalColor(signalStrength);

    return Container(
      margin: EdgeInsets.only(top: 2.h, right: 4.w),
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: AppTheme.backgroundWhite.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            offset: const Offset(0, 2),
            blurRadius: 8,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildSignalBars(signalStrength, color),
          SizedBox(width: 2.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'GPS',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                _getAccuracyText(accuracy),
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLocationDisabledIndicator() {
    return Container(
      margin: EdgeInsets.only(top: 2.h, right: 4.w),
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: AppTheme.errorRed.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.errorRed.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomIconWidget(
            iconName: 'location_disabled',
            color: AppTheme.errorRed,
            size: 16,
          ),
          SizedBox(width: 2.w),
          Text(
            'Location Off',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.errorRed,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignalBars(int strength, Color color) {
    return Row(
      children: List.generate(4, (index) {
        final isActive = index < strength;
        return Container(
          margin: EdgeInsets.only(right: index < 3 ? 1 : 0),
          width: 2,
          height: 4.0 + (index * 2.0),
          decoration: BoxDecoration(
            color: isActive ? color : AppTheme.borderSubtle,
            borderRadius: BorderRadius.circular(1),
          ),
        );
      }),
    );
  }

  int _getSignalStrength(double accuracy) {
    if (accuracy <= 5) return 4; // Excellent
    if (accuracy <= 10) return 3; // Good
    if (accuracy <= 20) return 2; // Fair
    if (accuracy <= 50) return 1; // Poor
    return 0; // Very poor
  }

  Color _getSignalColor(int strength) {
    switch (strength) {
      case 4:
      case 3:
        return AppTheme.successGreen;
      case 2:
        return AppTheme.warningAmber;
      case 1:
      case 0:
        return AppTheme.errorRed;
      default:
        return AppTheme.textSecondary;
    }
  }

  String _getAccuracyText(double accuracy) {
    if (accuracy <= 5) return 'Excellent';
    if (accuracy <= 10) return 'Good';
    if (accuracy <= 20) return 'Fair';
    if (accuracy <= 50) return 'Poor';
    return 'Very Poor';
  }
}
