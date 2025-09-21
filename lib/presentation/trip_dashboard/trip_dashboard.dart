import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import './widgets/current_trip_card.dart';
import './widgets/recent_trips_section.dart';
import './widgets/start_trip_button.dart';
import './widgets/status_indicator.dart';
import './widgets/travel_mode_selector.dart';
import './widgets/weekly_stats_card.dart';

class TripDashboard extends StatefulWidget {
  const TripDashboard({super.key});

  @override
  State<TripDashboard> createState() => _TripDashboardState();
}

class _TripDashboardState extends State<TripDashboard> {
  bool _isStartingTrip = false;
  String? _selectedTravelMode;
  Map<String, dynamic>? _currentTrip;

  // Mock data for dashboard
  final List<Map<String, dynamic>> _recentTrips = [
    {
      "id": 1,
      "origin": "Downtown Office",
      "destination": "Home",
      "mode": "bus",
      "duration": 45,
      "distance": 12.5,
      "date": DateTime.now().subtract(const Duration(hours: 2)),
      "status": "complete",
    },
    {
      "id": 2,
      "origin": "Coffee Shop",
      "destination": "Gym",
      "mode": "walk",
      "duration": 15,
      "distance": 1.2,
      "date": DateTime.now().subtract(const Duration(days: 1)),
      "status": "incomplete",
    },
    {
      "id": 3,
      "origin": "Home",
      "destination": "Airport",
      "mode": "car",
      "duration": 35,
      "distance": 28.7,
      "date": DateTime.now().subtract(const Duration(days: 2)),
      "status": "complete",
    },
    {
      "id": 4,
      "origin": "Mall",
      "destination": "Restaurant",
      "mode": "rideshare",
      "duration": 20,
      "distance": 8.3,
      "date": DateTime.now().subtract(const Duration(days: 3)),
      "status": "complete",
    },
    {
      "id": 5,
      "origin": "University",
      "destination": "Library",
      "mode": "bicycle",
      "duration": 12,
      "distance": 3.1,
      "date": DateTime.now().subtract(const Duration(days: 4)),
      "status": "complete",
    },
  ];

  final Map<String, dynamic> _weeklyStats = {
    "totalDistance": 156.8,
    "totalTrips": 12,
    "carbonFootprint": 23.4,
    "avgDuration": 28,
    "longestTrip": 45.2,
    "modeBreakdown": {
      "car": {"percentage": 45.0, "trips": 5},
      "bus": {"percentage": 25.0, "trips": 3},
      "walk": {"percentage": 15.0, "trips": 2},
      "bicycle": {"percentage": 10.0, "trips": 1},
      "rideshare": {"percentage": 5.0, "trips": 1},
    }
  };

  // System status
  bool _isGpsEnabled = true;
  bool _isBatteryOptimized = false;
  bool _isLocationPermissionGranted = true;
  bool _isOnline = true;

  @override
  void initState() {
    super.initState();
    _checkCurrentTrip();
  }

  void _checkCurrentTrip() {
    // Check if there's an active trip
    // In a real app, this would check local storage or API
    setState(() {
      _currentTrip = null; // No active trip for demo
    });
  }

  Future<void> _startTrip() async {
    if (_selectedTravelMode == null) {
      Fluttertoast.showToast(
        msg: "Please select a travel mode first",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
      return;
    }

    setState(() {
      _isStartingTrip = true;
    });

    // Simulate trip start process
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isStartingTrip = false;
      _currentTrip = {
        "id": DateTime.now().millisecondsSinceEpoch,
        "mode": _selectedTravelMode,
        "startTime": DateTime.now(),
        "duration": 0,
        "distance": 0.0,
        "status": "active",
      };
    });

    Navigator.pushNamed(context, '/active-trip-tracking');
  }

  Future<void> _endTrip() async {
    if (_currentTrip == null) return;

    setState(() {
      _currentTrip = null;
    });

    Fluttertoast.showToast(
      msg: "Trip ended successfully",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  Future<void> _refreshData() async {
    // Simulate refresh
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      // Update system status
      _isOnline = true;
    });

    Fluttertoast.showToast(
      msg: "Data refreshed",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _onTripTap(Map<String, dynamic> trip) {
    Navigator.pushNamed(
      context,
      '/trip-detail-view',
      arguments: trip,
    );
  }

  void _onEditTrip(Map<String, dynamic> trip) {
    Navigator.pushNamed(
      context,
      '/manual-trip-entry',
      arguments: trip,
    );
  }

  void _onShareTrip(Map<String, dynamic> trip) {
    Fluttertoast.showToast(
      msg: "Sharing trip: ${trip['origin']} to ${trip['destination']}",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _onDeleteTrip(Map<String, dynamic> trip) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Trip'),
        content: Text(
            'Are you sure you want to delete the trip from ${trip['origin']} to ${trip['destination']}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _recentTrips.removeWhere((t) => t['id'] == trip['id']);
              });
              Navigator.pop(context);
              Fluttertoast.showToast(
                msg: "Trip deleted",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
              );
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _onCompleteTrip(Map<String, dynamic> trip) {
    setState(() {
      final index = _recentTrips.indexWhere((t) => t['id'] == trip['id']);
      if (index != -1) {
        _recentTrips[index]['status'] = 'complete';
      }
    });

    Fluttertoast.showToast(
      msg: "Trip marked as complete",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundWhite,
      appBar: CustomAppBar.dashboard(
        actions: [
          IconButton(
            onPressed: () =>
                Navigator.pushNamed(context, '/settings-and-privacy'),
            icon: CustomIconWidget(
              iconName: 'settings',
              color: AppTheme.textPrimary,
              size: 24,
            ),
            tooltip: 'Settings',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        color: AppTheme.primaryBlue,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Status Indicator
              StatusIndicator(
                isGpsEnabled: _isGpsEnabled,
                isBatteryOptimized: _isBatteryOptimized,
                isLocationPermissionGranted: _isLocationPermissionGranted,
                isOnline: _isOnline,
              ),

              // Current Trip Card (if active)
              if (_currentTrip != null)
                CurrentTripCard(
                  currentTrip: _currentTrip,
                  onEndTrip: _endTrip,
                ),

              // Start Trip Section (if no active trip)
              if (_currentTrip == null) ...[
                SizedBox(height: 2.h),
                StartTripButton(
                  onStartTrip: _startTrip,
                  isLoading: _isStartingTrip,
                ),
                SizedBox(height: 3.h),
                TravelModeSelector(
                  selectedMode: _selectedTravelMode,
                  onModeSelected: (mode) {
                    setState(() {
                      _selectedTravelMode = mode;
                    });
                  },
                ),
              ],

              SizedBox(height: 4.h),

              // Weekly Stats Card
              WeeklyStatsCard(
                weeklyStats: _weeklyStats,
                onTap: () => Navigator.pushNamed(context, '/trip-history'),
              ),

              SizedBox(height: 3.h),

              // Recent Trips Section
              RecentTripsSection(
                recentTrips: _recentTrips,
                onTripTap: _onTripTap,
                onEditTrip: _onEditTrip,
                onShareTrip: _onShareTrip,
                onDeleteTrip: _onDeleteTrip,
                onCompleteTrip: _onCompleteTrip,
              ),

              SizedBox(height: 10.h), // Bottom padding for navigation
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomBar.dashboard(
        onTap: (route) {
          if (route != '/trip-dashboard') {
            Navigator.pushReplacementNamed(context, route);
          }
        },
      ),
      floatingActionButton: _currentTrip == null
          ? FloatingActionButton(
              onPressed: _selectedTravelMode != null ? _startTrip : null,
              backgroundColor: _selectedTravelMode != null
                  ? AppTheme.primaryBlue
                  : AppTheme.textSecondary,
              child: _isStartingTrip
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: AppTheme.backgroundWhite,
                        strokeWidth: 2,
                      ),
                    )
                  : CustomIconWidget(
                      iconName: 'play_arrow',
                      color: AppTheme.backgroundWhite,
                      size: 28,
                    ),
            )
          : null,
    );
  }
}
