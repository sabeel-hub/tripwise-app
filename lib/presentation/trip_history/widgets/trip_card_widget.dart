import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class TripCardWidget extends StatelessWidget {
  final Map<String, dynamic> trip;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onShare;
  final VoidCallback? onDelete;
  final VoidCallback? onComplete;
  final bool isSelected;
  final bool isMultiSelectMode;
  final ValueChanged<bool?>? onSelectionChanged;

  const TripCardWidget({
    super.key,
    required this.trip,
    this.onTap,
    this.onEdit,
    this.onShare,
    this.onDelete,
    this.onComplete,
    this.isSelected = false,
    this.isMultiSelectMode = false,
    this.onSelectionChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isIncomplete = (trip["status"] as String) == "incomplete";

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Slidable(
        key: ValueKey(trip["id"]),
        startActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (_) => onEdit?.call(),
              backgroundColor: AppTheme.primaryBlue,
              foregroundColor: AppTheme.backgroundWhite,
              icon: Icons.edit,
              label: 'Edit',
              borderRadius: BorderRadius.circular(12),
            ),
            SlidableAction(
              onPressed: (_) => onShare?.call(),
              backgroundColor: AppTheme.accentTeal,
              foregroundColor: AppTheme.backgroundWhite,
              icon: Icons.share,
              label: 'Share',
              borderRadius: BorderRadius.circular(12),
            ),
          ],
        ),
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (_) => onDelete?.call(),
              backgroundColor: AppTheme.errorRed,
              foregroundColor: AppTheme.backgroundWhite,
              icon: Icons.delete,
              label: 'Delete',
              borderRadius: BorderRadius.circular(12),
            ),
          ],
        ),
        child: GestureDetector(
          onTap: isMultiSelectMode
              ? () => onSelectionChanged?.call(!isSelected)
              : onTap,
          onLongPress: () => onSelectionChanged?.call(!isSelected),
          child: Container(
            decoration: BoxDecoration(
              color: isSelected
                  ? theme.colorScheme.primary.withValues(alpha: 0.1)
                  : theme.cardColor,
              borderRadius: BorderRadius.circular(12),
              border: isIncomplete
                  ? Border.all(color: AppTheme.warningAmber, width: 1)
                  : Border.all(
                      color: theme.colorScheme.outline.withValues(alpha: 0.2)),
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
            child: Padding(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      if (isMultiSelectMode) ...[
                        Checkbox(
                          value: isSelected,
                          onChanged: onSelectionChanged,
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                        ),
                        SizedBox(width: 2.w),
                      ],
                      Expanded(
                        child: _buildLocationInfo(theme),
                      ),
                      _buildTravelModeChip(theme),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  _buildTripDetails(theme),
                  if (isIncomplete) ...[
                    SizedBox(height: 2.h),
                    _buildIncompleteActions(theme),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLocationInfo(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CustomIconWidget(
              iconName: 'radio_button_checked',
              color: AppTheme.successGreen,
              size: 16,
            ),
            SizedBox(width: 2.w),
            Expanded(
              child: Text(
                trip["origin"] as String,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        SizedBox(height: 1.h),
        Row(
          children: [
            CustomIconWidget(
              iconName: 'location_on',
              color: AppTheme.errorRed,
              size: 16,
            ),
            SizedBox(width: 2.w),
            Expanded(
              child: Text(
                trip["destination"] as String,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTravelModeChip(ThemeData theme) {
    final mode = trip["travelMode"] as String;
    IconData modeIcon;
    Color modeColor;

    switch (mode.toLowerCase()) {
      case 'car':
        modeIcon = Icons.directions_car;
        modeColor = AppTheme.primaryBlue;
        break;
      case 'bus':
        modeIcon = Icons.directions_bus;
        modeColor = AppTheme.accentTeal;
        break;
      case 'walk':
        modeIcon = Icons.directions_walk;
        modeColor = AppTheme.successGreen;
        break;
      case 'bicycle':
        modeIcon = Icons.directions_bike;
        modeColor = AppTheme.warningAmber;
        break;
      case 'train':
        modeIcon = Icons.train;
        modeColor = AppTheme.primaryBlue;
        break;
      case 'flight':
        modeIcon = Icons.flight;
        modeColor = AppTheme.errorRed;
        break;
      default:
        modeIcon = Icons.directions;
        modeColor = AppTheme.textSecondary;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
      decoration: BoxDecoration(
        color: modeColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: modeColor.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            modeIcon,
            size: 14,
            color: modeColor,
          ),
          SizedBox(width: 1.w),
          Text(
            mode,
            style: theme.textTheme.labelSmall?.copyWith(
              color: modeColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTripDetails(ThemeData theme) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CustomIconWidget(
                    iconName: 'schedule',
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    size: 14,
                  ),
                  SizedBox(width: 1.w),
                  Text(
                    trip["date"] as String,
                    style: theme.textTheme.bodySmall,
                  ),
                  SizedBox(width: 3.w),
                  Text(
                    trip["time"] as String,
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 0.5.h),
              Row(
                children: [
                  CustomIconWidget(
                    iconName: 'timer',
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    size: 14,
                  ),
                  SizedBox(width: 1.w),
                  Text(
                    trip["duration"] as String,
                    style: theme.textTheme.bodySmall,
                  ),
                  SizedBox(width: 3.w),
                  CustomIconWidget(
                    iconName: 'straighten',
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    size: 14,
                  ),
                  SizedBox(width: 1.w),
                  Text(
                    trip["distance"] as String,
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ],
          ),
        ),
        _buildStatusIndicator(theme),
      ],
    );
  }

  Widget _buildStatusIndicator(ThemeData theme) {
    final status = trip["status"] as String;
    final isComplete = status == "complete";

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
      decoration: BoxDecoration(
        color: isComplete
            ? AppTheme.successGreen.withValues(alpha: 0.1)
            : AppTheme.warningAmber.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isComplete
              ? AppTheme.successGreen.withValues(alpha: 0.3)
              : AppTheme.warningAmber.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomIconWidget(
            iconName: isComplete ? 'check_circle' : 'warning',
            color: isComplete ? AppTheme.successGreen : AppTheme.warningAmber,
            size: 12,
          ),
          SizedBox(width: 1.w),
          Text(
            isComplete ? 'Complete' : 'Incomplete',
            style: theme.textTheme.labelSmall?.copyWith(
              color: isComplete ? AppTheme.successGreen : AppTheme.warningAmber,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIncompleteActions(ThemeData theme) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: onComplete,
            icon: CustomIconWidget(
              iconName: 'edit',
              color: AppTheme.warningAmber,
              size: 16,
            ),
            label: const Text('Complete Trip'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppTheme.warningAmber,
              side: const BorderSide(color: AppTheme.warningAmber),
              padding: EdgeInsets.symmetric(vertical: 1.h),
            ),
          ),
        ),
      ],
    );
  }
}
