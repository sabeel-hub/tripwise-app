import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class TravelModeSelector extends StatelessWidget {
  final String? selectedMode;
  final Function(String)? onModeSelected;

  const TravelModeSelector({
    super.key,
    this.selectedMode,
    this.onModeSelected,
  });

  static const List<Map<String, String>> _travelModes = [
    {'mode': 'walk', 'icon': 'directions_walk', 'label': 'Walk'},
    {'mode': 'bus', 'icon': 'directions_bus', 'label': 'Bus'},
    {'mode': 'car', 'icon': 'directions_car', 'label': 'Car'},
    {'mode': 'train', 'icon': 'train', 'label': 'Train'},
    {'mode': 'bicycle', 'icon': 'directions_bike', 'label': 'Bike'},
    {'mode': 'motorcycle', 'icon': 'motorcycle', 'label': 'Motor'},
    {'mode': 'rideshare', 'icon': 'local_taxi', 'label': 'Taxi'},
    {'mode': 'flight', 'icon': 'flight', 'label': 'Flight'},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90.w,
      margin: EdgeInsets.symmetric(horizontal: 5.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Travel Mode',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          Wrap(
            spacing: 3.w,
            runSpacing: 2.h,
            children: _travelModes.map((mode) {
              final isSelected = selectedMode == mode['mode'];
              return GestureDetector(
                onTap: () => onModeSelected?.call(mode['mode']!),
                child: Container(
                  width: 18.w,
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppTheme.primaryBlue.withValues(alpha: 0.1)
                        : AppTheme.surfaceGray,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? AppTheme.primaryBlue
                          : AppTheme.borderSubtle,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      CustomIconWidget(
                        iconName: mode['icon']!,
                        color: isSelected
                            ? AppTheme.primaryBlue
                            : AppTheme.textSecondary,
                        size: 24,
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        mode['label']!,
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: isSelected
                              ? AppTheme.primaryBlue
                              : AppTheme.textSecondary,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.w400,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
