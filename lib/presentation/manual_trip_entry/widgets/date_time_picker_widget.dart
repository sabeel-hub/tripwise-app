import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class DateTimePickerWidget extends StatelessWidget {
  final String label;
  final DateTime? selectedDateTime;
  final Function(DateTime) onDateTimeSelected;
  final bool isRequired;
  final DateTime? minimumDate;
  final DateTime? maximumDate;

  const DateTimePickerWidget({
    super.key,
    required this.label,
    this.selectedDateTime,
    required this.onDateTimeSelected,
    this.isRequired = false,
    this.minimumDate,
    this.maximumDate,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isRequired ? '$label *' : label,
          style: theme.textTheme.titleSmall?.copyWith(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 1.h),
        InkWell(
          onTap: () => _showDateTimePicker(context),
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            decoration: BoxDecoration(
              border: Border.all(
                color: theme.colorScheme.outline,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(8),
              color: theme.colorScheme.surface,
            ),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'schedule',
                  color: theme.colorScheme.onSurfaceVariant,
                  size: 20,
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Text(
                    selectedDateTime != null
                        ? _formatDateTime(selectedDateTime!)
                        : 'Select date and time',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: selectedDateTime != null
                          ? theme.colorScheme.onSurface
                          : theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                CustomIconWidget(
                  iconName: 'arrow_drop_down',
                  color: theme.colorScheme.onSurfaceVariant,
                  size: 24,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];

    final month = months[dateTime.month - 1];
    final day = dateTime.day.toString().padLeft(2, '0');
    final year = dateTime.year;

    final hour = dateTime.hour == 0
        ? 12
        : (dateTime.hour > 12 ? dateTime.hour - 12 : dateTime.hour);
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final period = dateTime.hour >= 12 ? 'PM' : 'AM';

    return '$month $day, $year at $hour:$minute $period';
  }

  Future<void> _showDateTimePicker(BuildContext context) async {
    final theme = Theme.of(context);
    final now = DateTime.now();
    final initialDate = selectedDateTime ?? now;

    // Show date picker first
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: minimumDate ?? DateTime(2020),
      lastDate: maximumDate ?? DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: theme.copyWith(
            colorScheme: theme.colorScheme.copyWith(
              primary: theme.colorScheme.primary,
              onPrimary: theme.colorScheme.onPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (selectedDate != null && context.mounted) {
      // Show time picker
      final selectedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(initialDate),
        builder: (context, child) {
          return Theme(
            data: theme.copyWith(
              colorScheme: theme.colorScheme.copyWith(
                primary: theme.colorScheme.primary,
                onPrimary: theme.colorScheme.onPrimary,
              ),
            ),
            child: child!,
          );
        },
      );

      if (selectedTime != null) {
        final combinedDateTime = DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
          selectedTime.hour,
          selectedTime.minute,
        );
        onDateTimeSelected(combinedDateTime);
      }
    }
  }
}
