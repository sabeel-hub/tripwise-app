import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class TravelModeSelector extends StatelessWidget {
  final String selectedMode;
  final Function(String) onModeSelected;

  const TravelModeSelector({
    super.key,
    required this.selectedMode,
    required this.onModeSelected,
  });

  static const List<Map<String, String>> travelModes = [
    {'mode': 'walk', 'icon': 'directions_walk', 'label': 'Walk'},
    {'mode': 'bus', 'icon': 'directions_bus', 'label': 'Bus'},
    {'mode': 'car', 'icon': 'directions_car', 'label': 'Car'},
    {'mode': 'train', 'icon': 'train', 'label': 'Train'},
    {'mode': 'bicycle', 'icon': 'directions_bike', 'label': 'Bicycle'},
    {'mode': 'motorcycle', 'icon': 'motorcycle', 'label': 'Motorcycle'},
    {'mode': 'rideshare', 'icon': 'local_taxi', 'label': 'Rideshare'},
    {'mode': 'flight', 'icon': 'flight', 'label': 'Flight'},
    {'mode': 'boat', 'icon': 'directions_boat', 'label': 'Boat'},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 12.h,
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        itemCount: travelModes.length,
        separatorBuilder: (context, index) => SizedBox(width: 3.w),
        itemBuilder: (context, index) {
          final mode = travelModes[index];
          final isSelected = selectedMode == mode['mode'];

          return GestureDetector(
            onTap: () {
              HapticFeedback.selectionClick();
              onModeSelected(mode['mode']!);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppTheme.primaryBlue
                    : AppTheme.lightTheme.colorScheme.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color:
                      isSelected ? AppTheme.primaryBlue : AppTheme.borderSubtle,
                  width: 1,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: AppTheme.primaryBlue.withValues(alpha: 0.3),
                          offset: const Offset(0, 2),
                          blurRadius: 8,
                          spreadRadius: 0,
                        ),
                      ]
                    : null,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomIconWidget(
                    iconName: mode['icon']!,
                    color: isSelected
                        ? AppTheme.backgroundWhite
                        : AppTheme.textSecondary,
                    size: 24,
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    mode['label']!,
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: isSelected
                          ? AppTheme.backgroundWhite
                          : AppTheme.textSecondary,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
