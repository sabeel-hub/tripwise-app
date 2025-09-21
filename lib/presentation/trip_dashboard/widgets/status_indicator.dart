import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class StatusIndicator extends StatelessWidget {
  final bool isGpsEnabled;
  final bool isBatteryOptimized;
  final bool isLocationPermissionGranted;
  final bool isOnline;

  const StatusIndicator({
    super.key,
    required this.isGpsEnabled,
    required this.isBatteryOptimized,
    required this.isLocationPermissionGranted,
    required this.isOnline,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90.w,
      margin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: _getStatusColor().withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: _getStatusColor().withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: _getStatusIcon(),
            color: _getStatusColor(),
            size: 16,
          ),
          SizedBox(width: 2.w),
          Expanded(
            child: Text(
              _getStatusMessage(),
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: _getStatusColor(),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          if (!_isAllSystemsGo())
            GestureDetector(
              onTap: () =>
                  Navigator.pushNamed(context, '/settings-and-privacy'),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: _getStatusColor().withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Fix',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: _getStatusColor(),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  bool _isAllSystemsGo() {
    return isGpsEnabled &&
        isBatteryOptimized &&
        isLocationPermissionGranted &&
        isOnline;
  }

  Color _getStatusColor() {
    if (!isLocationPermissionGranted || !isGpsEnabled) {
      return AppTheme.errorRed;
    } else if (!isBatteryOptimized || !isOnline) {
      return AppTheme.warningAmber;
    } else {
      return AppTheme.successGreen;
    }
  }

  String _getStatusIcon() {
    if (!isLocationPermissionGranted || !isGpsEnabled) {
      return 'location_off';
    } else if (!isBatteryOptimized) {
      return 'battery_alert';
    } else if (!isOnline) {
      return 'wifi_off';
    } else {
      return 'check_circle';
    }
  }

  String _getStatusMessage() {
    if (!isLocationPermissionGranted) {
      return 'Location permission required for trip tracking';
    } else if (!isGpsEnabled) {
      return 'GPS is disabled - enable for accurate tracking';
    } else if (!isBatteryOptimized) {
      return 'Battery optimization may affect background tracking';
    } else if (!isOnline) {
      return 'Offline - trips will sync when connected';
    } else {
      return 'All systems ready for trip tracking';
    }
  }
}
