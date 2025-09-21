import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class DistanceDurationWidget extends StatefulWidget {
  final double? distance;
  final int? duration;
  final Function(double?) onDistanceChanged;
  final Function(int?) onDurationChanged;
  final String? travelMode;

  const DistanceDurationWidget({
    super.key,
    this.distance,
    this.duration,
    required this.onDistanceChanged,
    required this.onDurationChanged,
    this.travelMode,
  });

  @override
  State<DistanceDurationWidget> createState() => _DistanceDurationWidgetState();
}

class _DistanceDurationWidgetState extends State<DistanceDurationWidget> {
  final TextEditingController _distanceController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  bool _showValidationWarning = false;

  @override
  void initState() {
    super.initState();
    _updateControllers();
  }

  @override
  void didUpdateWidget(DistanceDurationWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.distance != widget.distance ||
        oldWidget.duration != widget.duration) {
      _updateControllers();
    }
  }

  void _updateControllers() {
    _distanceController.text = widget.distance?.toStringAsFixed(1) ?? '';
    _durationController.text = widget.duration?.toString() ?? '';
  }

  @override
  void dispose() {
    _distanceController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Distance & Duration',
          style: theme.textTheme.titleSmall?.copyWith(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 2.h),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _distanceController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                    ],
                    onChanged: (value) {
                      final distance = double.tryParse(value);
                      widget.onDistanceChanged(distance);
                      _validateInputs();
                    },
                    decoration: InputDecoration(
                      labelText: 'Distance',
                      hintText: '0.0',
                      suffixText: 'miles',
                      prefixIcon: Padding(
                        padding: EdgeInsets.all(3.w),
                        child: CustomIconWidget(
                          iconName: 'straighten',
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
              ),
            ),
            SizedBox(width: 4.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _durationController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    onChanged: (value) {
                      final duration = int.tryParse(value);
                      widget.onDurationChanged(duration);
                      _validateInputs();
                    },
                    decoration: InputDecoration(
                      labelText: 'Duration',
                      hintText: '0',
                      suffixText: 'min',
                      prefixIcon: Padding(
                        padding: EdgeInsets.all(3.w),
                        child: CustomIconWidget(
                          iconName: 'schedule',
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
              ),
            ),
          ],
        ),
        SizedBox(height: 2.h),
        Container(
          padding: EdgeInsets.all(3.w),
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: theme.colorScheme.primary.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              CustomIconWidget(
                iconName: 'info_outline',
                color: theme.colorScheme.primary,
                size: 16,
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: Text(
                  'These values will be auto-calculated from map data when available',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (_showValidationWarning) ...[
          SizedBox(height: 1.h),
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: AppTheme.warningAmber.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppTheme.warningAmber.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'warning',
                  color: AppTheme.warningAmber,
                  size: 16,
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Text(
                    _getValidationMessage(),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.warningAmber,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  void _validateInputs() {
    if (widget.distance == null ||
        widget.duration == null ||
        widget.travelMode == null) {
      setState(() {
        _showValidationWarning = false;
      });
      return;
    }

    final distance = widget.distance!;
    final duration = widget.duration!;
    final mode = widget.travelMode!;

    // Calculate expected speed (miles per hour)
    final speed = distance / (duration / 60.0);

    bool isUnrealistic = false;

    switch (mode) {
      case 'walk':
        isUnrealistic = speed > 5 || speed < 1;
        break;
      case 'bicycle':
        isUnrealistic = speed > 25 || speed < 5;
        break;
      case 'car':
        isUnrealistic = speed > 80 || speed < 10;
        break;
      case 'bus':
        isUnrealistic = speed > 60 || speed < 5;
        break;
      case 'train':
        isUnrealistic = speed > 200 || speed < 20;
        break;
      case 'motorcycle':
        isUnrealistic = speed > 100 || speed < 15;
        break;
      case 'flight':
        isUnrealistic = speed > 600 || speed < 100;
        break;
      default:
        isUnrealistic = false;
    }

    setState(() {
      _showValidationWarning = isUnrealistic;
    });
  }

  String _getValidationMessage() {
    if (widget.distance == null ||
        widget.duration == null ||
        widget.travelMode == null) {
      return '';
    }

    final distance = widget.distance!;
    final duration = widget.duration!;
    final speed = distance / (duration / 60.0);

    return 'Speed of ${speed.toStringAsFixed(1)} mph seems unusual for ${widget.travelMode}. Please verify your inputs.';
  }
}
