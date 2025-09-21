import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class CompanionCounterWidget extends StatefulWidget {
  final int companionCount;
  final Function(int) onCountChanged;
  final List<String> companionDetails;
  final Function(List<String>) onDetailsChanged;

  const CompanionCounterWidget({
    super.key,
    required this.companionCount,
    required this.onCountChanged,
    required this.companionDetails,
    required this.onDetailsChanged,
  });

  @override
  State<CompanionCounterWidget> createState() => _CompanionCounterWidgetState();
}

class _CompanionCounterWidgetState extends State<CompanionCounterWidget> {
  bool _showDetails = false;
  final List<TextEditingController> _controllers = [];

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    _controllers.clear();
    for (int i = 0; i < widget.companionCount; i++) {
      final controller = TextEditingController();
      if (i < widget.companionDetails.length) {
        controller.text = widget.companionDetails[i];
      }
      _controllers.add(controller);
    }
  }

  @override
  void didUpdateWidget(CompanionCounterWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.companionCount != widget.companionCount) {
      _initializeControllers();
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Companions',
          style: theme.textTheme.titleSmall?.copyWith(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 2.h),
        Container(
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            border: Border.all(
              color: theme.colorScheme.outline,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(8),
            color: theme.colorScheme.surface,
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Number of companions',
                    style: theme.textTheme.bodyMedium,
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: widget.companionCount > 0
                            ? () {
                                final newCount = widget.companionCount - 1;
                                widget.onCountChanged(newCount);
                                _updateDetails(newCount);
                              }
                            : null,
                        icon: CustomIconWidget(
                          iconName: 'remove_circle_outline',
                          color: widget.companionCount > 0
                              ? theme.colorScheme.primary
                              : theme.colorScheme.onSurfaceVariant
                                  .withValues(alpha: 0.5),
                          size: 24,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 4.w, vertical: 1.h),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          widget.companionCount.toString(),
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: theme.colorScheme.onPrimaryContainer,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: widget.companionCount < 10
                            ? () {
                                final newCount = widget.companionCount + 1;
                                widget.onCountChanged(newCount);
                                _updateDetails(newCount);
                              }
                            : null,
                        icon: CustomIconWidget(
                          iconName: 'add_circle_outline',
                          color: widget.companionCount < 10
                              ? theme.colorScheme.primary
                              : theme.colorScheme.onSurfaceVariant
                                  .withValues(alpha: 0.5),
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              if (widget.companionCount > 0) ...[
                SizedBox(height: 2.h),
                InkWell(
                  onTap: () {
                    setState(() {
                      _showDetails = !_showDetails;
                    });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Add companion details (optional)',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      CustomIconWidget(
                        iconName: _showDetails ? 'expand_less' : 'expand_more',
                        color: theme.colorScheme.primary,
                        size: 20,
                      ),
                    ],
                  ),
                ),
                if (_showDetails) ...[
                  SizedBox(height: 2.h),
                  ...List.generate(
                    widget.companionCount,
                    (index) => Padding(
                      padding: EdgeInsets.only(bottom: 2.h),
                      child: TextFormField(
                        controller: _controllers.length > index
                            ? _controllers[index]
                            : null,
                        onChanged: (value) =>
                            _updateDetailAtIndex(index, value),
                        decoration: InputDecoration(
                          labelText: 'Companion ${index + 1}',
                          hintText:
                              'Name or relationship (e.g., spouse, child)',
                          prefixIcon: Padding(
                            padding: EdgeInsets.all(3.w),
                            child: CustomIconWidget(
                              iconName: 'person',
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
                    ),
                  ),
                ],
              ],
            ],
          ),
        ),
      ],
    );
  }

  void _updateDetails(int newCount) {
    final currentDetails = List<String>.from(widget.companionDetails);

    if (newCount > currentDetails.length) {
      // Add empty strings for new companions
      while (currentDetails.length < newCount) {
        currentDetails.add('');
      }
    } else if (newCount < currentDetails.length) {
      // Remove excess details
      currentDetails.removeRange(newCount, currentDetails.length);
    }

    widget.onDetailsChanged(currentDetails);
  }

  void _updateDetailAtIndex(int index, String value) {
    final currentDetails = List<String>.from(widget.companionDetails);

    // Ensure the list is long enough
    while (currentDetails.length <= index) {
      currentDetails.add('');
    }

    currentDetails[index] = value;
    widget.onDetailsChanged(currentDetails);
  }
}
