import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AdvancedDetailsWidget extends StatefulWidget {
  final bool isExpanded;
  final Function(bool) onExpandedChanged;
  final double? cost;
  final Function(double?) onCostChanged;
  final String? weather;
  final Function(String?) onWeatherChanged;
  final int? rating;
  final Function(int?) onRatingChanged;
  final String? notes;
  final Function(String?) onNotesChanged;

  const AdvancedDetailsWidget({
    super.key,
    required this.isExpanded,
    required this.onExpandedChanged,
    this.cost,
    required this.onCostChanged,
    this.weather,
    required this.onWeatherChanged,
    this.rating,
    required this.onRatingChanged,
    this.notes,
    required this.onNotesChanged,
  });

  @override
  State<AdvancedDetailsWidget> createState() => _AdvancedDetailsWidgetState();
}

class _AdvancedDetailsWidgetState extends State<AdvancedDetailsWidget> {
  final TextEditingController _costController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  static const List<Map<String, dynamic>> _weatherOptions = [
    {"id": "sunny", "name": "Sunny", "icon": "wb_sunny"},
    {"id": "cloudy", "name": "Cloudy", "icon": "cloud"},
    {"id": "rainy", "name": "Rainy", "icon": "umbrella"},
    {"id": "snowy", "name": "Snowy", "icon": "ac_unit"},
    {"id": "foggy", "name": "Foggy", "icon": "blur_on"},
    {"id": "windy", "name": "Windy", "icon": "air"},
  ];

  @override
  void initState() {
    super.initState();
    _costController.text = widget.cost?.toStringAsFixed(2) ?? '';
    _notesController.text = widget.notes ?? '';
  }

  @override
  void didUpdateWidget(AdvancedDetailsWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.cost != widget.cost) {
      _costController.text = widget.cost?.toStringAsFixed(2) ?? '';
    }
    if (oldWidget.notes != widget.notes) {
      _notesController.text = widget.notes ?? '';
    }
  }

  @override
  void dispose() {
    _costController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () => widget.onExpandedChanged(!widget.isExpanded),
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              border: Border.all(
                color: theme.colorScheme.outline,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(8),
              color: theme.colorScheme.surface,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'tune',
                      color: theme.colorScheme.onSurfaceVariant,
                      size: 20,
                    ),
                    SizedBox(width: 3.w),
                    Text(
                      'Advanced Details',
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: theme.colorScheme.onSurface,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                CustomIconWidget(
                  iconName: widget.isExpanded ? 'expand_less' : 'expand_more',
                  color: theme.colorScheme.onSurfaceVariant,
                  size: 24,
                ),
              ],
            ),
          ),
        ),
        if (widget.isExpanded) ...[
          SizedBox(height: 3.h),
          _buildCostSection(theme),
          SizedBox(height: 3.h),
          _buildWeatherSection(theme),
          SizedBox(height: 3.h),
          _buildRatingSection(theme),
          SizedBox(height: 3.h),
          _buildNotesSection(theme),
        ],
      ],
    );
  }

  Widget _buildCostSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Trip Cost',
          style: theme.textTheme.titleSmall?.copyWith(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 1.h),
        TextFormField(
          controller: _costController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
          ],
          onChanged: (value) {
            final cost = double.tryParse(value);
            widget.onCostChanged(cost);
          },
          decoration: InputDecoration(
            hintText: '0.00',
            prefixText: '\$ ',
            prefixIcon: Padding(
              padding: EdgeInsets.all(3.w),
              child: CustomIconWidget(
                iconName: 'attach_money',
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
        ),
      ],
    );
  }

  Widget _buildWeatherSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Weather Conditions',
          style: theme.textTheme.titleSmall?.copyWith(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 2.h),
        Wrap(
          spacing: 2.w,
          runSpacing: 1.h,
          children: _weatherOptions.map((weather) {
            final isSelected = widget.weather == weather["id"];
            return GestureDetector(
              onTap: () => widget.onWeatherChanged(
                isSelected ? null : weather["id"] as String,
              ),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
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
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomIconWidget(
                      iconName: weather["icon"] as String,
                      color: isSelected
                          ? theme.colorScheme.onPrimaryContainer
                          : theme.colorScheme.onSurfaceVariant,
                      size: 16,
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      weather["name"] as String,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: isSelected
                            ? theme.colorScheme.onPrimaryContainer
                            : theme.colorScheme.onSurface,
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

  Widget _buildRatingSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Trip Rating',
          style: theme.textTheme.titleSmall?.copyWith(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 2.h),
        Row(
          children: List.generate(5, (index) {
            final starIndex = index + 1;
            final isSelected =
                widget.rating != null && widget.rating! >= starIndex;
            return GestureDetector(
              onTap: () => widget.onRatingChanged(
                widget.rating == starIndex ? null : starIndex,
              ),
              child: Padding(
                padding: EdgeInsets.only(right: 1.w),
                child: CustomIconWidget(
                  iconName: isSelected ? 'star' : 'star_border',
                  color: isSelected
                      ? AppTheme.warningAmber
                      : theme.colorScheme.onSurfaceVariant,
                  size: 28,
                ),
              ),
            );
          }),
        ),
        if (widget.rating != null) ...[
          SizedBox(height: 1.h),
          Text(
            _getRatingDescription(widget.rating!),
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildNotesSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Notes',
          style: theme.textTheme.titleSmall?.copyWith(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 1.h),
        TextFormField(
          controller: _notesController,
          onChanged: widget.onNotesChanged,
          maxLines: 3,
          maxLength: 200,
          decoration: InputDecoration(
            hintText: 'Add any additional notes about this trip...',
            prefixIcon: Padding(
              padding: EdgeInsets.only(left: 3.w, top: 3.w),
              child: CustomIconWidget(
                iconName: 'note',
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
        ),
      ],
    );
  }

  String _getRatingDescription(int rating) {
    switch (rating) {
      case 1:
        return 'Poor experience';
      case 2:
        return 'Below average';
      case 3:
        return 'Average experience';
      case 4:
        return 'Good experience';
      case 5:
        return 'Excellent experience';
      default:
        return '';
    }
  }
}
