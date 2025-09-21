import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class TripControlsSheet extends StatefulWidget {
  final VoidCallback onEndTrip;
  final int companionCount;
  final Function(int) onCompanionCountChanged;
  final String tripNote;
  final Function(String) onNoteChanged;
  final bool isPaused;
  final VoidCallback onPauseResume;

  const TripControlsSheet({
    super.key,
    required this.onEndTrip,
    required this.companionCount,
    required this.onCompanionCountChanged,
    required this.tripNote,
    required this.onNoteChanged,
    required this.isPaused,
    required this.onPauseResume,
  });

  @override
  State<TripControlsSheet> createState() => _TripControlsSheetState();
}

class _TripControlsSheetState extends State<TripControlsSheet> {
  late TextEditingController _noteController;

  @override
  void initState() {
    super.initState();
    _noteController = TextEditingController(text: widget.tripNote);
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            offset: const Offset(0, -4),
            blurRadius: 16,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildDragHandle(),
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildPauseResumeButton(),
                SizedBox(height: 3.h),
                _buildCompanionCounter(),
                SizedBox(height: 3.h),
                _buildNoteField(),
                SizedBox(height: 4.h),
                _buildEndTripButton(),
                SizedBox(height: 2.h),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDragHandle() {
    return Container(
      margin: EdgeInsets.only(top: 2.h),
      width: 12.w,
      height: 0.5.h,
      decoration: BoxDecoration(
        color: AppTheme.borderSubtle,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildPauseResumeButton() {
    return ElevatedButton.icon(
      onPressed: () {
        HapticFeedback.lightImpact();
        widget.onPauseResume();
      },
      icon: CustomIconWidget(
        iconName: widget.isPaused ? 'play_arrow' : 'pause',
        color: AppTheme.backgroundWhite,
        size: 20,
      ),
      label: Text(
        widget.isPaused ? 'Resume Trip' : 'Pause Trip',
        style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
          color: AppTheme.backgroundWhite,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor:
            widget.isPaused ? AppTheme.successGreen : AppTheme.warningAmber,
        padding: EdgeInsets.symmetric(vertical: 2.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _buildCompanionCounter() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.surfaceGray,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'group',
                color: AppTheme.textSecondary,
                size: 20,
              ),
              SizedBox(width: 2.w),
              Text(
                'Companions',
                style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                  color: AppTheme.textPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Number of people traveling with you',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textSecondary,
                ),
              ),
              Row(
                children: [
                  _buildCounterButton(
                    icon: 'remove',
                    onTap: () {
                      if (widget.companionCount > 0) {
                        HapticFeedback.selectionClick();
                        widget
                            .onCompanionCountChanged(widget.companionCount - 1);
                      }
                    },
                    enabled: widget.companionCount > 0,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 4.w),
                    padding:
                        EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                    decoration: BoxDecoration(
                      color: AppTheme.backgroundWhite,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppTheme.borderSubtle),
                    ),
                    child: Text(
                      widget.companionCount.toString(),
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  _buildCounterButton(
                    icon: 'add',
                    onTap: () {
                      if (widget.companionCount < 10) {
                        HapticFeedback.selectionClick();
                        widget
                            .onCompanionCountChanged(widget.companionCount + 1);
                      }
                    },
                    enabled: widget.companionCount < 10,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCounterButton({
    required String icon,
    required VoidCallback onTap,
    required bool enabled,
  }) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        width: 10.w,
        height: 10.w,
        decoration: BoxDecoration(
          color: enabled ? AppTheme.primaryBlue : AppTheme.borderSubtle,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: CustomIconWidget(
            iconName: icon,
            color: enabled ? AppTheme.backgroundWhite : AppTheme.textSecondary,
            size: 20,
          ),
        ),
      ),
    );
  }

  Widget _buildNoteField() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.surfaceGray,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'note_add',
                color: AppTheme.textSecondary,
                size: 20,
              ),
              SizedBox(width: 2.w),
              Text(
                'Trip Note',
                style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                  color: AppTheme.textPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          TextField(
            controller: _noteController,
            onChanged: widget.onNoteChanged,
            maxLines: 3,
            maxLength: 200,
            decoration: InputDecoration(
              hintText: 'Add any notes about this trip...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppTheme.borderSubtle),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppTheme.borderSubtle),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide:
                    const BorderSide(color: AppTheme.primaryBlue, width: 2),
              ),
              filled: true,
              fillColor: AppTheme.backgroundWhite,
              contentPadding: EdgeInsets.all(3.w),
            ),
            style: AppTheme.lightTheme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildEndTripButton() {
    return ElevatedButton.icon(
      onPressed: () {
        HapticFeedback.heavyImpact();
        _showEndTripConfirmation();
      },
      icon: CustomIconWidget(
        iconName: 'stop',
        color: AppTheme.backgroundWhite,
        size: 24,
      ),
      label: Text(
        'End Trip',
        style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
          color: AppTheme.backgroundWhite,
          fontWeight: FontWeight.w600,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppTheme.errorRed,
        padding: EdgeInsets.symmetric(vertical: 2.5.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 2,
      ),
    );
  }

  void _showEndTripConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('End Trip'),
        content: const Text(
            'Are you sure you want to end this trip? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              widget.onEndTrip();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorRed,
            ),
            child: const Text('End Trip'),
          ),
        ],
      ),
    );
  }
}
