import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class FilterChipsWidget extends StatelessWidget {
  final Map<String, dynamic> activeFilters;
  final ValueChanged<String>? onFilterRemoved;
  final VoidCallback? onClearAll;

  const FilterChipsWidget({
    super.key,
    required this.activeFilters,
    this.onFilterRemoved,
    this.onClearAll,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final filterChips = _buildFilterChips();

    if (filterChips.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Active Filters',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
              const Spacer(),
              if (filterChips.length > 1)
                TextButton(
                  onPressed: onClearAll,
                  child: Text(
                    'Clear All',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: AppTheme.primaryBlue,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 1.h),
          Wrap(
            spacing: 2.w,
            runSpacing: 1.h,
            children: filterChips,
          ),
          SizedBox(height: 1.h),
        ],
      ),
    );
  }

  List<Widget> _buildFilterChips() {
    final List<Widget> chips = [];

    // Date range filter
    if (activeFilters.containsKey('dateRange') &&
        activeFilters['dateRange'] != null) {
      final dateRange = activeFilters['dateRange'] as Map<String, dynamic>;
      chips.add(_buildFilterChip(
        label: '${dateRange['start']} - ${dateRange['end']}',
        icon: Icons.date_range,
        onRemove: () => onFilterRemoved?.call('dateRange'),
      ));
    }

    // Travel mode filters
    if (activeFilters.containsKey('travelModes') &&
        (activeFilters['travelModes'] as List).isNotEmpty) {
      final modes = activeFilters['travelModes'] as List<String>;
      for (final mode in modes) {
        chips.add(_buildFilterChip(
          label: mode,
          icon: _getTravelModeIcon(mode),
          onRemove: () => onFilterRemoved?.call('travelMode:$mode'),
        ));
      }
    }

    // Completion status filter
    if (activeFilters.containsKey('completionStatus') &&
        activeFilters['completionStatus'] != null) {
      final status = activeFilters['completionStatus'] as String;
      chips.add(_buildFilterChip(
        label: status == 'complete' ? 'Complete' : 'Incomplete',
        icon: status == 'complete' ? Icons.check_circle : Icons.warning,
        onRemove: () => onFilterRemoved?.call('completionStatus'),
      ));
    }

    // Distance range filter
    if (activeFilters.containsKey('distanceRange') &&
        activeFilters['distanceRange'] != null) {
      final range = activeFilters['distanceRange'] as Map<String, dynamic>;
      chips.add(_buildFilterChip(
        label: '${range['min']} - ${range['max']} miles',
        icon: Icons.straighten,
        onRemove: () => onFilterRemoved?.call('distanceRange'),
      ));
    }

    // Duration range filter
    if (activeFilters.containsKey('durationRange') &&
        activeFilters['durationRange'] != null) {
      final range = activeFilters['durationRange'] as Map<String, dynamic>;
      chips.add(_buildFilterChip(
        label: '${range['min']} - ${range['max']} min',
        icon: Icons.timer,
        onRemove: () => onFilterRemoved?.call('durationRange'),
      ));
    }

    return chips;
  }

  Widget _buildFilterChip({
    required String label,
    required IconData icon,
    required VoidCallback onRemove,
  }) {
    return Builder(
      builder: (context) {
        final theme = Theme.of(context);
        return Container(
          decoration: BoxDecoration(
            color: AppTheme.primaryBlue.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppTheme.primaryBlue.withValues(alpha: 0.3),
            ),
          ),
          child: IntrinsicWidth(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 3.w),
                  child: Icon(
                    icon,
                    size: 16,
                    color: AppTheme.primaryBlue,
                  ),
                ),
                SizedBox(width: 1.w),
                Flexible(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 0.8.h),
                    child: Text(
                      label,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: AppTheme.primaryBlue,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                SizedBox(width: 1.w),
                GestureDetector(
                  onTap: onRemove,
                  child: Container(
                    padding: EdgeInsets.all(0.5.w),
                    child: Icon(
                      Icons.close,
                      size: 14,
                      color: AppTheme.primaryBlue,
                    ),
                  ),
                ),
                SizedBox(width: 1.w),
              ],
            ),
          ),
        );
      },
    );
  }

  IconData _getTravelModeIcon(String mode) {
    switch (mode.toLowerCase()) {
      case 'car':
        return Icons.directions_car;
      case 'bus':
        return Icons.directions_bus;
      case 'walk':
        return Icons.directions_walk;
      case 'bicycle':
        return Icons.directions_bike;
      case 'train':
        return Icons.train;
      case 'flight':
        return Icons.flight;
      case 'motorcycle':
        return Icons.motorcycle;
      case 'rideshare':
        return Icons.local_taxi;
      case 'boat':
        return Icons.directions_boat;
      default:
        return Icons.directions;
    }
  }
}
