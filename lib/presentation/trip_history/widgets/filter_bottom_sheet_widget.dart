import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class FilterBottomSheetWidget extends StatefulWidget {
  final Map<String, dynamic> currentFilters;
  final ValueChanged<Map<String, dynamic>>? onFiltersChanged;

  const FilterBottomSheetWidget({
    super.key,
    required this.currentFilters,
    this.onFiltersChanged,
  });

  @override
  State<FilterBottomSheetWidget> createState() =>
      _FilterBottomSheetWidgetState();
}

class _FilterBottomSheetWidgetState extends State<FilterBottomSheetWidget> {
  late Map<String, dynamic> _filters;
  DateTimeRange? _selectedDateRange;
  List<String> _selectedTravelModes = [];
  String? _selectedCompletionStatus;
  RangeValues _distanceRange = const RangeValues(0, 100);
  RangeValues _durationRange = const RangeValues(0, 180);

  final List<String> _travelModes = [
    'Car',
    'Bus',
    'Walk',
    'Bicycle',
    'Train',
    'Flight',
    'Motorcycle',
    'Rideshare',
    'Boat'
  ];

  @override
  void initState() {
    super.initState();
    _filters = Map<String, dynamic>.from(widget.currentFilters);
    _initializeFilters();
  }

  void _initializeFilters() {
    if (_filters.containsKey('dateRange') && _filters['dateRange'] != null) {
      final dateRange = _filters['dateRange'] as Map<String, dynamic>;
      _selectedDateRange = DateTimeRange(
        start: DateTime.parse(dateRange['start']),
        end: DateTime.parse(dateRange['end']),
      );
    }

    if (_filters.containsKey('travelModes')) {
      _selectedTravelModes = List<String>.from(_filters['travelModes'] ?? []);
    }

    if (_filters.containsKey('completionStatus')) {
      _selectedCompletionStatus = _filters['completionStatus'];
    }

    if (_filters.containsKey('distanceRange')) {
      final range = _filters['distanceRange'] as Map<String, dynamic>;
      _distanceRange = RangeValues(
        (range['min'] as num).toDouble(),
        (range['max'] as num).toDouble(),
      );
    }

    if (_filters.containsKey('durationRange')) {
      final range = _filters['durationRange'] as Map<String, dynamic>;
      _durationRange = RangeValues(
        (range['min'] as num).toDouble(),
        (range['max'] as num).toDouble(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(theme),
          Flexible(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDateRangeSection(theme),
                  SizedBox(height: 3.h),
                  _buildTravelModeSection(theme),
                  SizedBox(height: 3.h),
                  _buildCompletionStatusSection(theme),
                  SizedBox(height: 3.h),
                  _buildDistanceRangeSection(theme),
                  SizedBox(height: 3.h),
                  _buildDurationRangeSection(theme),
                  SizedBox(height: 4.h),
                ],
              ),
            ),
          ),
          _buildActionButtons(theme),
        ],
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
      ),
      child: Row(
        children: [
          Text(
            'Filter Trips',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: CustomIconWidget(
              iconName: 'close',
              color: theme.colorScheme.onSurface,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateRangeSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Date Range',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 1.h),
        InkWell(
          onTap: _selectDateRange,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              border: Border.all(
                color: theme.colorScheme.outline.withValues(alpha: 0.3),
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'date_range',
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  size: 20,
                ),
                SizedBox(width: 3.w),
                Text(
                  _selectedDateRange != null
                      ? '${_formatDate(_selectedDateRange!.start)} - ${_formatDate(_selectedDateRange!.end)}'
                      : 'Select date range',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: _selectedDateRange != null
                        ? theme.colorScheme.onSurface
                        : theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTravelModeSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Travel Mode',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 1.h),
        Wrap(
          spacing: 2.w,
          runSpacing: 1.h,
          children: _travelModes
              .map(
                (mode) => FilterChip(
                  label: Text(mode),
                  selected: _selectedTravelModes.contains(mode),
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _selectedTravelModes.add(mode);
                      } else {
                        _selectedTravelModes.remove(mode);
                      }
                    });
                  },
                  selectedColor: AppTheme.primaryBlue.withValues(alpha: 0.2),
                  checkmarkColor: AppTheme.primaryBlue,
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  Widget _buildCompletionStatusSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Completion Status',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 1.h),
        Row(
          children: [
            Expanded(
              child: RadioListTile<String?>(
                title: const Text('All'),
                value: null,
                groupValue: _selectedCompletionStatus,
                onChanged: (value) {
                  setState(() {
                    _selectedCompletionStatus = value;
                  });
                },
                contentPadding: EdgeInsets.zero,
              ),
            ),
            Expanded(
              child: RadioListTile<String>(
                title: const Text('Complete'),
                value: 'complete',
                groupValue: _selectedCompletionStatus,
                onChanged: (value) {
                  setState(() {
                    _selectedCompletionStatus = value;
                  });
                },
                contentPadding: EdgeInsets.zero,
              ),
            ),
            Expanded(
              child: RadioListTile<String>(
                title: const Text('Incomplete'),
                value: 'incomplete',
                groupValue: _selectedCompletionStatus,
                onChanged: (value) {
                  setState(() {
                    _selectedCompletionStatus = value;
                  });
                },
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDistanceRangeSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Distance Range (miles)',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 1.h),
        RangeSlider(
          values: _distanceRange,
          min: 0,
          max: 100,
          divisions: 20,
          labels: RangeLabels(
            '${_distanceRange.start.round()}',
            '${_distanceRange.end.round()}',
          ),
          onChanged: (values) {
            setState(() {
              _distanceRange = values;
            });
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${_distanceRange.start.round()} miles',
              style: theme.textTheme.bodySmall,
            ),
            Text(
              '${_distanceRange.end.round()} miles',
              style: theme.textTheme.bodySmall,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDurationRangeSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Duration Range (minutes)',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 1.h),
        RangeSlider(
          values: _durationRange,
          min: 0,
          max: 180,
          divisions: 18,
          labels: RangeLabels(
            '${_durationRange.start.round()}',
            '${_durationRange.end.round()}',
          ),
          onChanged: (values) {
            setState(() {
              _durationRange = values;
            });
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${_durationRange.start.round()} min',
              style: theme.textTheme.bodySmall,
            ),
            Text(
              '${_durationRange.end.round()} min',
              style: theme.textTheme.bodySmall,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButtons(ThemeData theme) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: theme.colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: _clearFilters,
              child: const Text('Clear All'),
            ),
          ),
          SizedBox(width: 4.w),
          Expanded(
            child: ElevatedButton(
              onPressed: _applyFilters,
              child: const Text('Apply Filters'),
            ),
          ),
        ],
      ),
    );
  }

  void _selectDateRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: _selectedDateRange,
    );

    if (picked != null) {
      setState(() {
        _selectedDateRange = picked;
      });
    }
  }

  void _clearFilters() {
    setState(() {
      _selectedDateRange = null;
      _selectedTravelModes.clear();
      _selectedCompletionStatus = null;
      _distanceRange = const RangeValues(0, 100);
      _durationRange = const RangeValues(0, 180);
    });
  }

  void _applyFilters() {
    final Map<String, dynamic> filters = {};

    if (_selectedDateRange != null) {
      filters['dateRange'] = {
        'start': _selectedDateRange!.start.toIso8601String(),
        'end': _selectedDateRange!.end.toIso8601String(),
      };
    }

    if (_selectedTravelModes.isNotEmpty) {
      filters['travelModes'] = _selectedTravelModes;
    }

    if (_selectedCompletionStatus != null) {
      filters['completionStatus'] = _selectedCompletionStatus;
    }

    if (_distanceRange.start > 0 || _distanceRange.end < 100) {
      filters['distanceRange'] = {
        'min': _distanceRange.start,
        'max': _distanceRange.end,
      };
    }

    if (_durationRange.start > 0 || _durationRange.end < 180) {
      filters['durationRange'] = {
        'min': _durationRange.start,
        'max': _durationRange.end,
      };
    }

    widget.onFiltersChanged?.call(filters);
    Navigator.pop(context);
  }

  String _formatDate(DateTime date) {
    return '${date.month}/${date.day}/${date.year}';
  }
}
