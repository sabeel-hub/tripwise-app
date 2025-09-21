import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class TripPurposeSelectorWidget extends StatefulWidget {
  final String? selectedPurpose;
  final Function(String) onPurposeSelected;
  final String? customPurpose;
  final Function(String) onCustomPurposeChanged;

  const TripPurposeSelectorWidget({
    super.key,
    this.selectedPurpose,
    required this.onPurposeSelected,
    this.customPurpose,
    required this.onCustomPurposeChanged,
  });

  @override
  State<TripPurposeSelectorWidget> createState() =>
      _TripPurposeSelectorWidgetState();
}

class _TripPurposeSelectorWidgetState extends State<TripPurposeSelectorWidget> {
  final TextEditingController _customController = TextEditingController();

  static const List<Map<String, dynamic>> _tripPurposes = [
    {
      "id": "commute",
      "name": "Commute",
      "icon": "work",
      "description": "Regular travel to/from work",
    },
    {
      "id": "business",
      "name": "Business",
      "icon": "business_center",
      "description": "Work-related meetings or activities",
    },
    {
      "id": "personal",
      "name": "Personal",
      "icon": "person",
      "description": "Personal errands and appointments",
    },
    {
      "id": "leisure",
      "name": "Leisure",
      "icon": "beach_access",
      "description": "Recreation and entertainment",
    },
    {
      "id": "shopping",
      "name": "Shopping",
      "icon": "shopping_bag",
      "description": "Retail and grocery shopping",
    },
    {
      "id": "medical",
      "name": "Medical",
      "icon": "local_hospital",
      "description": "Healthcare appointments",
    },
    {
      "id": "education",
      "name": "Education",
      "icon": "school",
      "description": "School or educational activities",
    },
    {
      "id": "custom",
      "name": "Other",
      "icon": "more_horiz",
      "description": "Specify custom purpose",
    },
  ];

  @override
  void initState() {
    super.initState();
    _customController.text = widget.customPurpose ?? '';
  }

  @override
  void dispose() {
    _customController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Trip Purpose',
          style: theme.textTheme.titleSmall?.copyWith(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 2.h),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 3.w,
            mainAxisSpacing: 2.h,
            childAspectRatio: 2.5,
          ),
          itemCount: _tripPurposes.length,
          itemBuilder: (context, index) {
            final purpose = _tripPurposes[index];
            final isSelected = widget.selectedPurpose == purpose["id"];

            return GestureDetector(
              onTap: () => widget.onPurposeSelected(purpose["id"] as String),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: isSelected
                      ? theme.colorScheme.primaryContainer
                      : theme.colorScheme.surface,
                  border: Border.all(
                    color: isSelected
                        ? theme.colorScheme.primary
                        : theme.colorScheme.outline,
                    width: isSelected ? 2 : 1,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: purpose["icon"] as String,
                      color: isSelected
                          ? theme.colorScheme.onPrimaryContainer
                          : theme.colorScheme.onSurfaceVariant,
                      size: 20,
                    ),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: Text(
                        purpose["name"] as String,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: isSelected
                              ? theme.colorScheme.onPrimaryContainer
                              : theme.colorScheme.onSurface,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        if (widget.selectedPurpose == 'custom') ...[
          SizedBox(height: 2.h),
          TextFormField(
            controller: _customController,
            onChanged: widget.onCustomPurposeChanged,
            decoration: InputDecoration(
              labelText: 'Custom Purpose',
              hintText: 'Enter your trip purpose',
              prefixIcon: Padding(
                padding: EdgeInsets.all(3.w),
                child: CustomIconWidget(
                  iconName: 'edit',
                  color: theme.colorScheme.onSurfaceVariant,
                  size: 20,
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: theme.colorScheme.outline,
                  width: 1,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: theme.colorScheme.outline,
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: theme.colorScheme.primary,
                  width: 2,
                ),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 4.w,
                vertical: 2.h,
              ),
            ),
            maxLength: 50,
          ),
        ],
        if (widget.selectedPurpose != null &&
            widget.selectedPurpose != 'custom') ...[
          SizedBox(height: 1.h),
          Text(
            _getPurposeDescription(widget.selectedPurpose!),
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ],
    );
  }

  String _getPurposeDescription(String purposeId) {
    final purpose = _tripPurposes.firstWhere(
      (p) => p["id"] == purposeId,
      orElse: () => {"description": ""},
    );
    return purpose["description"] as String;
  }
}
