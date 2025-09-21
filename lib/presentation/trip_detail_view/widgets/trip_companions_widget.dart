import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class TripCompanionsWidget extends StatefulWidget {
  final Map<String, dynamic> tripData;
  final bool isEditing;
  final Function(List<Map<String, dynamic>>)? onCompanionsChanged;

  const TripCompanionsWidget({
    super.key,
    required this.tripData,
    this.isEditing = false,
    this.onCompanionsChanged,
  });

  @override
  State<TripCompanionsWidget> createState() => _TripCompanionsWidgetState();
}

class _TripCompanionsWidgetState extends State<TripCompanionsWidget> {
  List<Map<String, dynamic>> companions = [];
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    companions = List<Map<String, dynamic>>.from(
      widget.tripData['companions'] as List<dynamic>? ?? [],
    );
  }

  void _addCompanion() {
    if (_nameController.text.trim().isNotEmpty) {
      final newCompanion = {
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'name': _nameController.text.trim(),
        'age': _ageController.text.trim().isNotEmpty
            ? _ageController.text.trim()
            : null,
        'relationship': 'Friend',
      };

      setState(() {
        companions.add(newCompanion);
      });

      widget.onCompanionsChanged?.call(companions);
      _nameController.clear();
      _ageController.clear();
      Navigator.of(context).pop();
    }
  }

  void _removeCompanion(String companionId) {
    setState(() {
      companions.removeWhere((companion) => companion['id'] == companionId);
    });
    widget.onCompanionsChanged?.call(companions);
  }

  void _showAddCompanionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Companion'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name *',
                hintText: 'Enter companion name',
              ),
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _ageController,
              decoration: const InputDecoration(
                labelText: 'Age (Optional)',
                hintText: 'Enter age',
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: _addCompanion,
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

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
          Row(
            children: [
              CustomIconWidget(
                iconName: 'group',
                color: AppTheme.primaryBlue,
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Travel Companions',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 16.sp,
                  ),
                ),
              ),
              if (widget.isEditing)
                IconButton(
                  onPressed: _showAddCompanionDialog,
                  icon: CustomIconWidget(
                    iconName: 'add_circle_outline',
                    color: AppTheme.primaryBlue,
                    size: 24,
                  ),
                  tooltip: 'Add companion',
                ),
            ],
          ),
          const SizedBox(height: 16),
          companions.isNotEmpty
              ? ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: companions.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final companion = companions[index];
                    return _buildCompanionItem(context, companion, isDark);
                  },
                )
              : _buildEmptyCompanions(context, isDark),
        ],
      ),
    );
  }

  Widget _buildCompanionItem(
      BuildContext context, Map<String, dynamic> companion, bool isDark) {
    final theme = Theme.of(context);

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
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: AppTheme.primaryBlue.withValues(alpha: 0.1),
            child: CustomIconWidget(
              iconName: 'person',
              color: AppTheme.primaryBlue,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  companion['name'] as String,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    fontSize: 14.sp,
                  ),
                ),
                if (companion['age'] != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    'Age: ${companion['age']}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isDark
                          ? AppTheme.textSecondaryDark
                          : AppTheme.textSecondary,
                      fontSize: 11.sp,
                    ),
                  ),
                ],
                const SizedBox(height: 2),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppTheme.accentTeal.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    companion['relationship'] as String? ?? 'Companion',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.accentTeal,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (widget.isEditing)
            IconButton(
              onPressed: () => _removeCompanion(companion['id'] as String),
              icon: CustomIconWidget(
                iconName: 'remove_circle_outline',
                color: AppTheme.errorRed,
                size: 20,
              ),
              tooltip: 'Remove companion',
              splashRadius: 20,
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyCompanions(BuildContext context, bool isDark) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          CustomIconWidget(
            iconName: 'person_outline',
            color: isDark ? AppTheme.textSecondaryDark : AppTheme.textSecondary,
            size: 48,
          ),
          const SizedBox(height: 16),
          Text(
            'Solo Trip',
            style: theme.textTheme.titleMedium?.copyWith(
              color:
                  isDark ? AppTheme.textSecondaryDark : AppTheme.textSecondary,
              fontSize: 14.sp,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            widget.isEditing
                ? 'Tap the + button to add travel companions'
                : 'You traveled alone on this trip.',
            style: theme.textTheme.bodySmall?.copyWith(
              color:
                  isDark ? AppTheme.textSecondaryDark : AppTheme.textSecondary,
              fontSize: 11.sp,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    super.dispose();
  }
}
