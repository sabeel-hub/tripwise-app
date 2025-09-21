import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class BatteryOptimizationWarning extends StatelessWidget {
  final VoidCallback onDismiss;
  final VoidCallback onOpenSettings;

  const BatteryOptimizationWarning({
    super.key,
    required this.onDismiss,
    required this.onOpenSettings,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.warningAmber.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.warningAmber.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'battery_alert',
                color: AppTheme.warningAmber,
                size: 24,
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Text(
                  'Battery Optimization Warning',
                  style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                    color: AppTheme.warningAmber,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              GestureDetector(
                onTap: onDismiss,
                child: CustomIconWidget(
                  iconName: 'close',
                  color: AppTheme.textSecondary,
                  size: 20,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Text(
            'Background app refresh is disabled. This may affect trip tracking accuracy. Enable it in settings for better results.',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.textPrimary,
            ),
          ),
          SizedBox(height: 3.h),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onDismiss,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppTheme.warningAmber),
                    foregroundColor: AppTheme.warningAmber,
                  ),
                  child: const Text('Dismiss'),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: ElevatedButton(
                  onPressed: onOpenSettings,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.warningAmber,
                  ),
                  child: const Text('Open Settings'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
