import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class TravelModeSelectorWidget extends StatelessWidget {
  final String? selectedMode;
  final Function(String) onModeSelected;

  const TravelModeSelectorWidget({
    super.key,
    this.selectedMode,
    required this.onModeSelected,
  });

  static const List<Map<String, dynamic>> _travelModes = [
    {
      "id": "walk",
      "name": "Walk",
      "icon": "directions_walk",
      "color": Color(0xFF4CAF50),
    },
    {
      "id": "bicycle",
      "name": "Bicycle",
      "icon": "directions_bike",
      "color": Color(0xFF2196F3),
    },
    {
      "id": "car",
      "name": "Car",
      "icon": "directions_car",
      "color": Color(0xFF9C27B0),
    },
    {
      "id": "bus",
      "name": "Bus",
      "icon": "directions_bus",
      "color": Color(0xFFFF9800),
    },
    {
      "id": "train",
      "name": "Train",
      "icon": "train",
      "color": Color(0xFF607D8B),
    },
    {
      "id": "motorcycle",
      "name": "Motorcycle",
      "icon": "two_wheeler",
      "color": Color(0xFFF44336),
    },
    {
      "id": "rideshare",
      "name": "Rideshare",
      "icon": "local_taxi",
      "color": Color(0xFF009688),
    },
    {
      "id": "flight",
      "name": "Flight",
      "icon": "flight",
      "color": Color(0xFF3F51B5),
    },
    {
      "id": "boat",
      "name": "Boat",
      "icon": "directions_boat",
      "color": Color(0xFF00BCD4),
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Travel Mode *',
          style: theme.textTheme.titleSmall?.copyWith(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 2.h),
        Wrap(
          spacing: 3.w,
          runSpacing: 2.h,
          children: _travelModes.map((mode) {
            final isSelected = selectedMode == mode["id"];
            return GestureDetector(
              onTap: () => onModeSelected(mode["id"] as String),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: isSelected
                      ? (mode["color"] as Color).withValues(alpha: 0.1)
                      : theme.colorScheme.surface,
                  border: Border.all(
                    color: isSelected
                        ? (mode["color"] as Color)
                        : theme.colorScheme.outline,
                    width: isSelected ? 2 : 1,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomIconWidget(
                      iconName: mode["icon"] as String,
                      color: isSelected
                          ? (mode["color"] as Color)
                          : theme.colorScheme.onSurfaceVariant,
                      size: 28,
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      mode["name"] as String,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: isSelected
                            ? (mode["color"] as Color)
                            : theme.colorScheme.onSurfaceVariant,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
