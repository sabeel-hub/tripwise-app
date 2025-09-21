import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class EmptyStateWidget extends StatelessWidget {
  final String type;
  final VoidCallback? onStartTracking;
  final VoidCallback? onAdjustFilters;

  const EmptyStateWidget({
    super.key,
    required this.type,
    this.onStartTracking,
    this.onAdjustFilters,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildIllustration(theme),
            SizedBox(height: 4.h),
            _buildTitle(theme),
            SizedBox(height: 2.h),
            _buildDescription(theme),
            SizedBox(height: 4.h),
            _buildActionButton(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildIllustration(ThemeData theme) {
    IconData iconData;
    Color iconColor;

    switch (type) {
      case 'no_trips':
        iconData = Icons.map_outlined;
        iconColor = AppTheme.primaryBlue;
        break;
      case 'no_search_results':
        iconData = Icons.search_off;
        iconColor = AppTheme.textSecondary;
        break;
      case 'no_filtered_results':
        iconData = Icons.filter_list_off;
        iconColor = AppTheme.warningAmber;
        break;
      default:
        iconData = Icons.help_outline;
        iconColor = AppTheme.textSecondary;
    }

    return Container(
      width: 30.w,
      height: 30.w,
      decoration: BoxDecoration(
        color: iconColor.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        iconData,
        size: 15.w,
        color: iconColor,
      ),
    );
  }

  Widget _buildTitle(ThemeData theme) {
    String title;

    switch (type) {
      case 'no_trips':
        title = 'No Trips Yet';
        break;
      case 'no_search_results':
        title = 'No Results Found';
        break;
      case 'no_filtered_results':
        title = 'No Matching Trips';
        break;
      default:
        title = 'Nothing Here';
    }

    return Text(
      title,
      style: theme.textTheme.headlineSmall?.copyWith(
        fontWeight: FontWeight.w600,
        color: theme.colorScheme.onSurface,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildDescription(ThemeData theme) {
    String description;

    switch (type) {
      case 'no_trips':
        description =
            'Start tracking your trips to see them here. Your travel history will help improve transportation planning.';
        break;
      case 'no_search_results':
        description =
            'We couldn\'t find any trips matching your search. Try different keywords or check your spelling.';
        break;
      case 'no_filtered_results':
        description =
            'No trips match your current filters. Try adjusting your filter criteria to see more results.';
        break;
      default:
        description = 'There\'s nothing to display right now.';
    }

    return Text(
      description,
      style: theme.textTheme.bodyMedium?.copyWith(
        color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
        height: 1.5,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildActionButton(ThemeData theme) {
    String buttonText;
    VoidCallback? onPressed;
    bool isPrimary = false;

    switch (type) {
      case 'no_trips':
        buttonText = 'Start Tracking';
        onPressed = onStartTracking;
        isPrimary = true;
        break;
      case 'no_search_results':
        return const SizedBox.shrink();
      case 'no_filtered_results':
        buttonText = 'Adjust Filters';
        onPressed = onAdjustFilters;
        isPrimary = false;
        break;
      default:
        return const SizedBox.shrink();
    }

    return isPrimary
        ? ElevatedButton.icon(
            onPressed: onPressed,
            icon: CustomIconWidget(
              iconName: 'navigation',
              color: AppTheme.backgroundWhite,
              size: 18,
            ),
            label: Text(buttonText),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 1.5.h),
            ),
          )
        : OutlinedButton.icon(
            onPressed: onPressed,
            icon: CustomIconWidget(
              iconName: 'tune',
              color: AppTheme.primaryBlue,
              size: 18,
            ),
            label: Text(buttonText),
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 1.5.h),
            ),
          );
  }
}
