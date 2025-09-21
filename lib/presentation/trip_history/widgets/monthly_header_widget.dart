import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class MonthlyHeaderWidget extends StatelessWidget {
  final String month;
  final int tripCount;
  final String totalDistance;
  final String totalDuration;
  final bool isExpanded;
  final VoidCallback? onToggle;

  const MonthlyHeaderWidget({
    super.key,
    required this.month,
    required this.tripCount,
    required this.totalDistance,
    required this.totalDuration,
    this.isExpanded = true,
    this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.2),
        ),
      ),
      child: InkWell(
        onTap: onToggle,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(4.w),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          month,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          '$tripCount ${tripCount == 1 ? 'trip' : 'trips'}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface
                                .withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (onToggle != null)
                    AnimatedRotation(
                      turns: isExpanded ? 0.5 : 0,
                      duration: const Duration(milliseconds: 200),
                      child: CustomIconWidget(
                        iconName: 'keyboard_arrow_down',
                        color: theme.colorScheme.primary,
                        size: 24,
                      ),
                    ),
                ],
              ),
              SizedBox(height: 2.h),
              Row(
                children: [
                  Expanded(
                    child: _buildStatItem(
                      context: context,
                      icon: Icons.straighten,
                      label: 'Distance',
                      value: totalDistance,
                      color: AppTheme.successGreen,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: _buildStatItem(
                      context: context,
                      icon: Icons.timer,
                      label: 'Duration',
                      value: totalDuration,
                      color: AppTheme.accentTeal,
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

  Widget _buildStatItem({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 20,
            color: color,
          ),
          SizedBox(height: 1.h),
          Text(
            value,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: color,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 0.5.h),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
