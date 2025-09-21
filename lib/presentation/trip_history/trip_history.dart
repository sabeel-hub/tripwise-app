import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import './widgets/empty_state_widget.dart';
import './widgets/filter_bottom_sheet_widget.dart';
import './widgets/filter_chips_widget.dart';
import './widgets/monthly_header_widget.dart';
import './widgets/search_bar_widget.dart';
import './widgets/trip_card_widget.dart';

class TripHistory extends StatefulWidget {
  const TripHistory({super.key});

  @override
  State<TripHistory> createState() => _TripHistoryState();
}

class _TripHistoryState extends State<TripHistory>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  String _searchQuery = '';
  Map<String, dynamic> _activeFilters = {};
  List<String> _recentSearches = [
    'Downtown to Airport',
    'Home to Office',
    'Mall trip'
  ];
  bool _isLoading = false;
  bool _isMultiSelectMode = false;
  Set<int> _selectedTripIds = {};
  Map<String, bool> _expandedMonths = {};

  // Mock trip data grouped by month
  final Map<String, List<Map<String, dynamic>>> _tripsByMonth = {
    'December 2025': [
      {
        "id": 1,
        "origin": "Downtown Seattle",
        "destination": "Seattle-Tacoma International Airport",
        "date": "Dec 12, 2025",
        "time": "2:30 PM",
        "duration": "45 min",
        "distance": "18.5 miles",
        "travelMode": "Car",
        "status": "complete",
        "notes": "Flight to San Francisco for business meeting",
      },
      {
        "id": 2,
        "origin": "Home - Capitol Hill",
        "destination": "Amazon Spheres",
        "date": "Dec 11, 2025",
        "time": "8:15 AM",
        "duration": "25 min",
        "distance": "3.2 miles",
        "travelMode": "Bus",
        "status": "incomplete",
        "notes": "Daily commute to work",
      },
      {
        "id": 3,
        "origin": "Pike Place Market",
        "destination": "University of Washington",
        "date": "Dec 10, 2025",
        "time": "11:00 AM",
        "duration": "35 min",
        "distance": "8.7 miles",
        "travelMode": "Walk",
        "status": "complete",
        "notes": "Weekend visit to campus",
      },
    ],
    'November 2025': [
      {
        "id": 4,
        "origin": "Bellevue Square Mall",
        "destination": "Home - Capitol Hill",
        "date": "Nov 28, 2025",
        "time": "6:45 PM",
        "duration": "40 min",
        "distance": "12.1 miles",
        "travelMode": "Car",
        "status": "complete",
        "notes": "Holiday shopping trip",
      },
      {
        "id": 5,
        "origin": "Seattle Center",
        "destination": "Fremont Neighborhood",
        "date": "Nov 25, 2025",
        "time": "3:20 PM",
        "duration": "20 min",
        "distance": "4.8 miles",
        "travelMode": "Bicycle",
        "status": "complete",
        "notes": "Thanksgiving dinner with friends",
      },
      {
        "id": 6,
        "origin": "King Street Station",
        "destination": "Portland Union Station",
        "date": "Nov 22, 2025",
        "time": "7:00 AM",
        "duration": "3h 30min",
        "distance": "173 miles",
        "travelMode": "Train",
        "status": "incomplete",
        "notes": "Weekend getaway to Portland",
      },
    ],
  };

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _initializeExpandedMonths();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _initializeExpandedMonths() {
    for (String month in _tripsByMonth.keys) {
      _expandedMonths[month] = true;
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _loadMoreTrips();
    }
  }

  Future<void> _loadMoreTrips() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    // Simulate loading delay
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _refreshTrips() async {
    HapticFeedback.lightImpact();

    setState(() {
      _isLoading = true;
    });

    // Simulate refresh delay
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isLoading = false;
    });
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  void _onVoiceSearch() {
    // Voice search implementation would go here
    HapticFeedback.lightImpact();
  }

  void _onFilterTap() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        builder: (context, scrollController) => FilterBottomSheetWidget(
          currentFilters: _activeFilters,
          onFiltersChanged: (filters) {
            setState(() {
              _activeFilters = filters;
            });
          },
        ),
      ),
    );
  }

  void _onFilterRemoved(String filterKey) {
    setState(() {
      if (filterKey.startsWith('travelMode:')) {
        final mode = filterKey.split(':')[1];
        if (_activeFilters.containsKey('travelModes')) {
          (_activeFilters['travelModes'] as List).remove(mode);
          if ((_activeFilters['travelModes'] as List).isEmpty) {
            _activeFilters.remove('travelModes');
          }
        }
      } else {
        _activeFilters.remove(filterKey);
      }
    });
  }

  void _onClearAllFilters() {
    setState(() {
      _activeFilters.clear();
    });
  }

  void _onRecentSearchTap(String search) {
    _searchController.text = search;
    _onSearchChanged(search);
  }

  void _onTripTap(Map<String, dynamic> trip) {
    if (_isMultiSelectMode) {
      _toggleTripSelection(trip["id"] as int);
    } else {
      Navigator.pushNamed(
        context,
        '/trip-detail-view',
        arguments: trip,
      );
    }
  }

  void _onTripLongPress(int tripId) {
    HapticFeedback.mediumImpact();
    setState(() {
      _isMultiSelectMode = true;
      _selectedTripIds.add(tripId);
    });
  }

  void _toggleTripSelection(int tripId) {
    setState(() {
      if (_selectedTripIds.contains(tripId)) {
        _selectedTripIds.remove(tripId);
        if (_selectedTripIds.isEmpty) {
          _isMultiSelectMode = false;
        }
      } else {
        _selectedTripIds.add(tripId);
      }
    });
  }

  void _exitMultiSelectMode() {
    setState(() {
      _isMultiSelectMode = false;
      _selectedTripIds.clear();
    });
  }

  void _onBatchDelete() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Selected Trips'),
        content: Text(
            'Are you sure you want to delete ${_selectedTripIds.length} selected trips? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _exitMultiSelectMode();
              HapticFeedback.lightImpact();
            },
            child: const Text('Delete'),
            style: TextButton.styleFrom(foregroundColor: AppTheme.errorRed),
          ),
        ],
      ),
    );
  }

  void _onBatchShare() {
    _exitMultiSelectMode();
    HapticFeedback.lightImpact();
  }

  void _onTripEdit(Map<String, dynamic> trip) {
    Navigator.pushNamed(
      context,
      '/manual-trip-entry',
      arguments: trip,
    );
  }

  void _onTripShare(Map<String, dynamic> trip) {
    HapticFeedback.lightImpact();
  }

  void _onTripDelete(Map<String, dynamic> trip) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Trip'),
        content: const Text(
            'Are you sure you want to delete this trip? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              HapticFeedback.lightImpact();
            },
            child: const Text('Delete'),
            style: TextButton.styleFrom(foregroundColor: AppTheme.errorRed),
          ),
        ],
      ),
    );
  }

  void _onTripComplete(Map<String, dynamic> trip) {
    Navigator.pushNamed(
      context,
      '/manual-trip-entry',
      arguments: trip,
    );
  }

  void _toggleMonthExpansion(String month) {
    setState(() {
      _expandedMonths[month] = !(_expandedMonths[month] ?? true);
    });
  }

  List<Map<String, dynamic>> _getFilteredTrips() {
    List<Map<String, dynamic>> allTrips = [];

    for (List<Map<String, dynamic>> monthTrips in _tripsByMonth.values) {
      allTrips.addAll(monthTrips);
    }

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      allTrips = allTrips.where((trip) {
        final query = _searchQuery.toLowerCase();
        return (trip["origin"] as String).toLowerCase().contains(query) ||
            (trip["destination"] as String).toLowerCase().contains(query) ||
            (trip["notes"] as String).toLowerCase().contains(query);
      }).toList();
    }

    // Apply other filters
    if (_activeFilters.isNotEmpty) {
      allTrips = allTrips.where((trip) {
        // Date range filter
        if (_activeFilters.containsKey('dateRange')) {
          // Implementation would check if trip date is within range
        }

        // Travel mode filter
        if (_activeFilters.containsKey('travelModes')) {
          final modes = _activeFilters['travelModes'] as List<String>;
          if (!modes.contains(trip["travelMode"])) {
            return false;
          }
        }

        // Completion status filter
        if (_activeFilters.containsKey('completionStatus')) {
          if (_activeFilters['completionStatus'] != trip["status"]) {
            return false;
          }
        }

        return true;
      }).toList();
    }

    return allTrips;
  }

  Map<String, List<Map<String, dynamic>>> _getGroupedFilteredTrips() {
    final filteredTrips = _getFilteredTrips();
    final Map<String, List<Map<String, dynamic>>> grouped = {};

    for (String month in _tripsByMonth.keys) {
      final monthTrips = _tripsByMonth[month]!
          .where((trip) =>
              filteredTrips.any((filtered) => filtered["id"] == trip["id"]))
          .toList();

      if (monthTrips.isNotEmpty) {
        grouped[month] = monthTrips;
      }
    }

    return grouped;
  }

  String _getMonthStats(List<Map<String, dynamic>> trips, String type) {
    if (type == 'distance') {
      double total = 0;
      for (var trip in trips) {
        final distance = (trip["distance"] as String).replaceAll(' miles', '');
        total += double.tryParse(distance) ?? 0;
      }
      return '${total.toStringAsFixed(1)} miles';
    } else if (type == 'duration') {
      int totalMinutes = 0;
      for (var trip in trips) {
        final duration = trip["duration"] as String;
        if (duration.contains('h')) {
          final parts = duration.split(' ');
          final hours = int.tryParse(parts[0].replaceAll('h', '')) ?? 0;
          final minutes = int.tryParse(parts[1].replaceAll('min', '')) ?? 0;
          totalMinutes += (hours * 60) + minutes;
        } else {
          final minutes = int.tryParse(duration.replaceAll(' min', '')) ?? 0;
          totalMinutes += minutes;
        }
      }
      final hours = totalMinutes ~/ 60;
      final minutes = totalMinutes % 60;
      return hours > 0 ? '${hours}h ${minutes}min' : '${minutes}min';
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final groupedTrips = _getGroupedFilteredTrips();
    final hasFilters = _activeFilters.isNotEmpty;
    final hasSearchQuery = _searchQuery.isNotEmpty;
    final isEmpty = groupedTrips.isEmpty;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: _isMultiSelectMode
          ? _buildMultiSelectAppBar(theme)
          : CustomAppBar.history(
              onSearch: () {}, // Search is handled by the search bar widget
              onFilter: _onFilterTap,
            ),
      body: Column(
        children: [
          SearchBarWidget(
            initialQuery: _searchQuery,
            onSearchChanged: _onSearchChanged,
            onVoiceSearch: _onVoiceSearch,
            onFilterTap: _onFilterTap,
            recentSearches: _recentSearches,
            onRecentSearchTap: _onRecentSearchTap,
          ),
          if (hasFilters)
            FilterChipsWidget(
              activeFilters: _activeFilters,
              onFilterRemoved: _onFilterRemoved,
              onClearAll: _onClearAllFilters,
            ),
          Expanded(
            child: isEmpty
                ? _buildEmptyState()
                : RefreshIndicator(
                    onRefresh: _refreshTrips,
                    child: ListView.builder(
                      controller: _scrollController,
                      padding: EdgeInsets.only(bottom: 2.h),
                      itemCount: _calculateItemCount(groupedTrips),
                      itemBuilder: (context, index) =>
                          _buildListItem(groupedTrips, index),
                    ),
                  ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomBar.history(
        onTap: (route) => Navigator.pushReplacementNamed(context, route),
      ),
    );
  }

  PreferredSizeWidget _buildMultiSelectAppBar(ThemeData theme) {
    return AppBar(
      backgroundColor: theme.appBarTheme.backgroundColor,
      foregroundColor: theme.appBarTheme.foregroundColor,
      elevation: 2,
      leading: IconButton(
        onPressed: _exitMultiSelectMode,
        icon: CustomIconWidget(
          iconName: 'close',
          color: theme.appBarTheme.foregroundColor!,
          size: 24,
        ),
      ),
      title: Text(
        '${_selectedTripIds.length} selected',
        style: theme.textTheme.titleMedium,
      ),
      actions: [
        IconButton(
          onPressed: _onBatchShare,
          icon: CustomIconWidget(
            iconName: 'share',
            color: theme.appBarTheme.foregroundColor!,
            size: 24,
          ),
          tooltip: 'Share selected',
        ),
        IconButton(
          onPressed: _onBatchDelete,
          icon: CustomIconWidget(
            iconName: 'delete',
            color: AppTheme.errorRed,
            size: 24,
          ),
          tooltip: 'Delete selected',
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    if (_searchQuery.isNotEmpty) {
      return const EmptyStateWidget(type: 'no_search_results');
    } else if (_activeFilters.isNotEmpty) {
      return EmptyStateWidget(
        type: 'no_filtered_results',
        onAdjustFilters: _onFilterTap,
      );
    } else {
      return EmptyStateWidget(
        type: 'no_trips',
        onStartTracking: () =>
            Navigator.pushNamed(context, '/active-trip-tracking'),
      );
    }
  }

  int _calculateItemCount(
      Map<String, List<Map<String, dynamic>>> groupedTrips) {
    int count = 0;
    for (String month in groupedTrips.keys) {
      count++; // Month header
      if (_expandedMonths[month] ?? true) {
        count += groupedTrips[month]!.length; // Trip cards
      }
    }
    if (_isLoading) count++; // Loading indicator
    return count;
  }

  Widget _buildListItem(
      Map<String, List<Map<String, dynamic>>> groupedTrips, int index) {
    int currentIndex = 0;

    for (String month in groupedTrips.keys) {
      if (currentIndex == index) {
        // Month header
        final trips = groupedTrips[month]!;
        return MonthlyHeaderWidget(
          month: month,
          tripCount: trips.length,
          totalDistance: _getMonthStats(trips, 'distance'),
          totalDuration: _getMonthStats(trips, 'duration'),
          isExpanded: _expandedMonths[month] ?? true,
          onToggle: () => _toggleMonthExpansion(month),
        );
      }
      currentIndex++;

      if (_expandedMonths[month] ?? true) {
        final trips = groupedTrips[month]!;
        for (int i = 0; i < trips.length; i++) {
          if (currentIndex == index) {
            // Trip card
            final trip = trips[i];
            return TripCardWidget(
              trip: trip,
              onTap: () => _onTripTap(trip),
              onEdit: () => _onTripEdit(trip),
              onShare: () => _onTripShare(trip),
              onDelete: () => _onTripDelete(trip),
              onComplete: () => _onTripComplete(trip),
              isSelected: _selectedTripIds.contains(trip["id"]),
              isMultiSelectMode: _isMultiSelectMode,
              onSelectionChanged: (selected) {
                if (selected == true) {
                  _onTripLongPress(trip["id"] as int);
                } else {
                  _toggleTripSelection(trip["id"] as int);
                }
              },
            );
          }
          currentIndex++;
        }
      }
    }

    // Loading indicator
    if (_isLoading) {
      return Container(
        padding: EdgeInsets.all(4.w),
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return const SizedBox.shrink();
  }
}
