import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class StartTripButton extends StatelessWidget {
  final VoidCallback? onStartTrip;
  final bool isLoading;

  const StartTripButton({
    super.key,
    this.onStartTrip,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90.w,
      margin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
      child: Column(
        children: [
          GestureDetector(
            onTap: isLoading ? null : onStartTrip,
            child: Container(
              width: 20.w,
              height: 20.w,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.primaryBlue,
                    AppTheme.primaryBlue.withValues(alpha: 0.8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryBlue.withValues(alpha: 0.3),
                    offset: const Offset(0, 4),
                    blurRadius: 12,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: isLoading
                  ? const CircularProgressIndicator(
                      color: AppTheme.backgroundWhite,
                      strokeWidth: 2,
                    )
                  : CustomIconWidget(
                      iconName: 'play_arrow',
                      color: AppTheme.backgroundWhite,
                      size: 32,
                    ),
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            'Start Trip',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Tap to begin tracking your journey',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
