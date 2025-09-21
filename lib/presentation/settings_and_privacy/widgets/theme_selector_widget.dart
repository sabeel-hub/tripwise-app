import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ThemeSelectorWidget extends StatelessWidget {
  final String selectedTheme;
  final Function(String) onThemeChanged;

  const ThemeSelectorWidget({
    super.key,
    required this.selectedTheme,
    required this.onThemeChanged,
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
                  iconName: 'palette',
                  color: AppTheme.accentTeal,
                  size: 24,
                ),
                SizedBox(width: 3.w),
                Text(
                  'Appearance',
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
                  child: _buildThemeOption(
                    context: context,
                    theme: theme,
                    value: 'light',
                    label: 'Light',
                    icon: 'light_mode',
                    isSelected: selectedTheme == 'light',
                  ),
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: _buildThemeOption(
                    context: context,
                    theme: theme,
                    value: 'dark',
                    label: 'Dark',
                    icon: 'dark_mode',
                    isSelected: selectedTheme == 'dark',
                  ),
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: _buildThemeOption(
                    context: context,
                    theme: theme,
                    value: 'system',
                    label: 'System',
                    icon: 'settings_brightness',
                    isSelected: selectedTheme == 'system',
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

  Widget _buildThemeOption({
    required BuildContext context,
    required ThemeData theme,
    required String value,
    required String label,
    required String icon,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () => onThemeChanged(value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
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
            Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppTheme.primaryBlue.withValues(alpha: 0.2)
                    : theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(8),
              ),
              child: CustomIconWidget(
                iconName: icon,
                color: isSelected
                    ? AppTheme.primaryBlue
                    : theme.colorScheme.onSurface.withValues(alpha: 0.6),
                size: 24,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              label,
              style: theme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: isSelected
                    ? AppTheme.primaryBlue
                    : theme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
