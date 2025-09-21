import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class DataManagementWidget extends StatelessWidget {
  final String storageUsage;
  final VoidCallback onExportData;
  final VoidCallback onDeleteAccount;
  final VoidCallback onBackupRestore;

  const DataManagementWidget({
    super.key,
    required this.storageUsage,
    required this.onExportData,
    required this.onDeleteAccount,
    required this.onBackupRestore,
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
                  iconName: 'storage',
                  color: AppTheme.errorRed,
                  size: 24,
                ),
                SizedBox(width: 3.w),
                Text(
                  'Data Management',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
          _buildStorageInfo(context, theme),
          _buildDivider(theme),
          _buildActionButton(
            context: context,
            theme: theme,
            icon: 'download',
            title: 'Export Data',
            subtitle: 'Download your trip history and preferences',
            onTap: onExportData,
            iconColor: AppTheme.primaryBlue,
          ),
          _buildDivider(theme),
          _buildActionButton(
            context: context,
            theme: theme,
            icon: 'cloud_sync',
            title: 'Backup & Restore',
            subtitle: 'Sync preferences across devices',
            onTap: onBackupRestore,
            iconColor: AppTheme.successGreen,
          ),
          _buildDivider(theme),
          _buildActionButton(
            context: context,
            theme: theme,
            icon: 'delete_forever',
            title: 'Delete Account',
            subtitle: 'Permanently remove all data and account',
            onTap: () => _showDeleteConfirmation(context),
            iconColor: AppTheme.errorRed,
            isDestructive: true,
          ),
          SizedBox(height: 1.h),
        ],
      ),
    );
  }

  Widget _buildStorageInfo(BuildContext context, ThemeData theme) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Storage Usage',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  'Trip data, preferences, and cached content',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 3.w),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
            decoration: BoxDecoration(
              color: AppTheme.primaryBlue.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              storageUsage,
              style: theme.textTheme.labelLarge?.copyWith(
                color: AppTheme.primaryBlue,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required ThemeData theme,
    required String icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required Color iconColor,
    bool isDestructive = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: CustomIconWidget(
                iconName: icon,
                color: iconColor,
                size: 20,
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: isDestructive
                          ? AppTheme.errorRed
                          : theme.colorScheme.onSurface,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),
            CustomIconWidget(
              iconName: 'chevron_right',
              color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        final theme = Theme.of(context);
        return AlertDialog(
          title: Row(
            children: [
              CustomIconWidget(
                iconName: 'warning',
                color: AppTheme.errorRed,
                size: 24,
              ),
              SizedBox(width: 2.w),
              Text(
                'Delete Account',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: AppTheme.errorRed,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'This action will permanently delete:',
                style: theme.textTheme.bodyMedium,
              ),
              SizedBox(height: 1.h),
              ...const [
                '• All trip history and data',
                '• Account preferences and settings',
                '• Research participation data',
                '• Backup and sync information',
              ].map((item) => Padding(
                    padding: EdgeInsets.only(bottom: 0.5.h),
                    child: Text(
                      item,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.8),
                      ),
                    ),
                  )),
              SizedBox(height: 1.h),
              Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: AppTheme.errorRed.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppTheme.errorRed.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Text(
                  'This action cannot be undone and will impact ongoing research studies.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.errorRed,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                onDeleteAccount();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.errorRed,
                foregroundColor: Colors.white,
              ),
              child: Text(
                'Delete Account',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDivider(ThemeData theme) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Divider(
        height: 1,
        thickness: 1,
        color: theme.colorScheme.outline.withValues(alpha: 0.2),
      ),
    );
  }
}
