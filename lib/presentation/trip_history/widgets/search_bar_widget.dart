import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SearchBarWidget extends StatefulWidget {
  final String? initialQuery;
  final ValueChanged<String>? onSearchChanged;
  final VoidCallback? onVoiceSearch;
  final VoidCallback? onFilterTap;
  final bool showVoiceSearch;
  final bool showFilter;
  final List<String>? recentSearches;
  final ValueChanged<String>? onRecentSearchTap;

  const SearchBarWidget({
    super.key,
    this.initialQuery,
    this.onSearchChanged,
    this.onVoiceSearch,
    this.onFilterTap,
    this.showVoiceSearch = true,
    this.showFilter = true,
    this.recentSearches,
    this.onRecentSearchTap,
  });

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  late TextEditingController _searchController;
  late FocusNode _focusNode;
  bool _showSuggestions = false;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.initialQuery);
    _focusNode = FocusNode();

    _focusNode.addListener(() {
      setState(() {
        _showSuggestions =
            _focusNode.hasFocus && (widget.recentSearches?.isNotEmpty ?? false);
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: theme.colorScheme.outline.withValues(alpha: 0.2),
            ),
            boxShadow: [
              BoxShadow(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.05)
                    : Colors.black.withValues(alpha: 0.08),
                offset: const Offset(0, 2),
                blurRadius: 8,
                spreadRadius: 0,
              ),
            ],
          ),
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 4.w),
                child: CustomIconWidget(
                  iconName: 'search',
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  size: 20,
                ),
              ),
              Expanded(
                child: TextField(
                  controller: _searchController,
                  focusNode: _focusNode,
                  onChanged: (value) {
                    widget.onSearchChanged?.call(value);
                    setState(() {
                      _showSuggestions = _focusNode.hasFocus &&
                          (widget.recentSearches?.isNotEmpty ?? false);
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Search trips, locations, or notes...',
                    hintStyle: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 4.w,
                      vertical: 1.5.h,
                    ),
                  ),
                  style: theme.textTheme.bodyMedium,
                ),
              ),
              if (_searchController.text.isNotEmpty)
                IconButton(
                  onPressed: () {
                    _searchController.clear();
                    widget.onSearchChanged?.call('');
                    setState(() {});
                  },
                  icon: CustomIconWidget(
                    iconName: 'clear',
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    size: 20,
                  ),
                  tooltip: 'Clear search',
                ),
              if (widget.showVoiceSearch)
                IconButton(
                  onPressed: widget.onVoiceSearch,
                  icon: CustomIconWidget(
                    iconName: 'mic',
                    color: AppTheme.primaryBlue,
                    size: 20,
                  ),
                  tooltip: 'Voice search',
                ),
              if (widget.showFilter)
                IconButton(
                  onPressed: widget.onFilterTap,
                  icon: CustomIconWidget(
                    iconName: 'filter_list',
                    color: AppTheme.primaryBlue,
                    size: 20,
                  ),
                  tooltip: 'Filter trips',
                ),
            ],
          ),
        ),
        if (_showSuggestions && widget.recentSearches != null)
          _buildRecentSearches(theme),
      ],
    );
  }

  Widget _buildRecentSearches(ThemeData theme) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'history',
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  size: 16,
                ),
                SizedBox(width: 2.w),
                Text(
                  'Recent Searches',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
          ...widget.recentSearches!.take(5).map(
                (search) => InkWell(
                  onTap: () {
                    _searchController.text = search;
                    widget.onRecentSearchTap?.call(search);
                    _focusNode.unfocus();
                  },
                  child: Container(
                    width: double.infinity,
                    padding:
                        EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                    child: Row(
                      children: [
                        SizedBox(width: 6.w),
                        CustomIconWidget(
                          iconName: 'search',
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.4),
                          size: 16,
                        ),
                        SizedBox(width: 3.w),
                        Expanded(
                          child: Text(
                            search,
                            style: theme.textTheme.bodyMedium,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        CustomIconWidget(
                          iconName: 'north_west',
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.4),
                          size: 16,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
        ],
      ),
    );
  }
}
