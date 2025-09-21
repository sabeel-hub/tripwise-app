import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class TripNotesWidget extends StatefulWidget {
  final Map<String, dynamic> tripData;
  final bool isEditing;
  final Function(String)? onNotesChanged;

  const TripNotesWidget({
    super.key,
    required this.tripData,
    this.isEditing = false,
    this.onNotesChanged,
  });

  @override
  State<TripNotesWidget> createState() => _TripNotesWidgetState();
}

class _TripNotesWidgetState extends State<TripNotesWidget> {
  late TextEditingController _notesController;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _notesController = TextEditingController(
      text: widget.tripData['notes'] as String? ?? '',
    );
  }

  void _onNotesChanged() {
    widget.onNotesChanged?.call(_notesController.text);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final hasNotes = _notesController.text.trim().isNotEmpty;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.surfaceDark : AppTheme.surfaceGray,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppTheme.getElevationShadow(
          isLight: !isDark,
          elevation: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'note_alt',
                    color: AppTheme.primaryBlue,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Trip Notes',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 16.sp,
                      ),
                    ),
                  ),
                  if (hasNotes && !widget.isEditing)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryBlue.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${_notesController.text.length} chars',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.primaryBlue,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  const SizedBox(width: 8),
                  AnimatedRotation(
                    turns: _isExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: CustomIconWidget(
                      iconName: 'expand_more',
                      color: isDark
                          ? AppTheme.textSecondaryDark
                          : AppTheme.textSecondary,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            height: _isExpanded ? null : 0,
            child: _isExpanded
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      widget.isEditing
                          ? _buildEditableNotes(context, isDark)
                          : _buildReadOnlyNotes(context, isDark),
                    ],
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildEditableNotes(BuildContext context, bool isDark) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: (isDark ? AppTheme.backgroundDark : AppTheme.backgroundWhite)
            .withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppTheme.borderDark : AppTheme.borderSubtle,
          width: 1,
        ),
      ),
      child: TextField(
        controller: _notesController,
        onChanged: (_) => _onNotesChanged(),
        maxLines: 6,
        decoration: InputDecoration(
          hintText:
              'Add notes about your trip experience, observations, or any important details...',
          hintStyle: theme.textTheme.bodyMedium?.copyWith(
            color:
                (isDark ? AppTheme.textSecondaryDark : AppTheme.textSecondary)
                    .withValues(alpha: 0.6),
            fontSize: 12.sp,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(16),
        ),
        style: theme.textTheme.bodyMedium?.copyWith(
          fontSize: 12.sp,
        ),
      ),
    );
  }

  Widget _buildReadOnlyNotes(BuildContext context, bool isDark) {
    final theme = Theme.of(context);
    final hasNotes = _notesController.text.trim().isNotEmpty;

    if (!hasNotes) {
      return Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            CustomIconWidget(
              iconName: 'note_add',
              color:
                  isDark ? AppTheme.textSecondaryDark : AppTheme.textSecondary,
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              'No Notes Added',
              style: theme.textTheme.titleMedium?.copyWith(
                color: isDark
                    ? AppTheme.textSecondaryDark
                    : AppTheme.textSecondary,
                fontSize: 14.sp,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Add notes to remember details about this trip.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: isDark
                    ? AppTheme.textSecondaryDark
                    : AppTheme.textSecondary,
                fontSize: 11.sp,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: (isDark ? AppTheme.backgroundDark : AppTheme.backgroundWhite)
            .withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppTheme.borderDark : AppTheme.borderSubtle,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'format_quote',
                color: AppTheme.primaryBlue,
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                'Trip Notes',
                style: theme.textTheme.titleSmall?.copyWith(
                  color: AppTheme.primaryBlue,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            _notesController.text,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontSize: 12.sp,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              CustomIconWidget(
                iconName: 'schedule',
                color: isDark
                    ? AppTheme.textSecondaryDark
                    : AppTheme.textSecondary,
                size: 14,
              ),
              const SizedBox(width: 4),
              Text(
                'Added on ${widget.tripData['date'] ?? 'Unknown date'}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: isDark
                      ? AppTheme.textSecondaryDark
                      : AppTheme.textSecondary,
                  fontSize: 10.sp,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }
}
