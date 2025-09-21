import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class UnitsPreferenceWidget extends StatelessWidget {
  final String selectedUnit;
  final Function(String) onUnitChanged;

  const UnitsPreferenceWidget({
    super.key,
    required this.selectedUnit,
    required this.onUnitChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.white.withValues(alpha: 0.05)
                : Colors.black.withValues(alpha: 0.08),
            offset: const Offset(0, 2),
            blurRadius: 8,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'straighten',
                  color: AppTheme.accentTeal,
                  size: 24,
                ),
                SizedBox(width: 3.w),
                Text(
                  'Units Preference',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
            child: Row(
              children: [
                Expanded(
                  child: _buildUnitOption(
                    context: context,
                    theme: theme,
                    value: 'imperial',
                    label: 'Imperial',
                    description: 'Miles, feet, °F',
                    isSelected: selectedUnit == 'imperial',
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: _buildUnitOption(
                    context: context,
                    theme: theme,
                    value: 'metric',
                    label: 'Metric',
                    description: 'Kilometers, meters, °C',
                    isSelected: selectedUnit == 'metric',
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 2.h),
        ],
      ),
    );
  }

  Widget _buildUnitOption({
    required BuildContext context,
    required ThemeData theme,
    required String value,
    required String label,
    required String description,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () => onUnitChanged(value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.primaryBlue.withValues(alpha: 0.1)
              : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? AppTheme.primaryBlue
                : theme.colorScheme.outline.withValues(alpha: 0.3),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: isSelected
                    ? AppTheme.primaryBlue
                    : theme.colorScheme.onSurface,
              ),
            ),
            SizedBox(height: 0.5.h),
            Text(
              description,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
              textAlign: TextAlign.center,
            ),
            if (isSelected) ...[
              SizedBox(height: 1.h),
              CustomIconWidget(
                iconName: 'check_circle',
                color: AppTheme.primaryBlue,
                size: 20,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
