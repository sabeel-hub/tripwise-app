import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import './widgets/battery_optimization_warning.dart';
import './widgets/gps_accuracy_indicator.dart';
import './widgets/travel_mode_selector.dart';
import './widgets/trip_controls_sheet.dart';
import './widgets/trip_info_card.dart';

class ActiveTripTracking extends StatefulWidget {
  const ActiveTripTracking({super.key});

  @override
  State<ActiveTripTracking> createState() => _ActiveTripTrackingState();
}

class _ActiveTripTrackingState extends State<ActiveTripTracking>
    with TickerProviderStateMixin {
  // Map and location controllers
  GoogleMapController? _mapController;
  Position? _currentPosition;
  late AnimationController _pulseController;

  // Trip data
  final List<LatLng> _routePoints = [];
  final Set<Polyline> _polylines = {};
  final Set<Marker> _markers = {};

  // Trip state
  bool _isTracking = false;
  bool _isPaused = false;
  DateTime? _tripStartTime;
  double _totalDistance = 0.0;
  String _selectedMode = 'car';
  String _detectedMode = 'car';
  double _modeConfidence = 0.85;
  int _companionCount = 0;
  String _tripNote = '';

  // UI state
  bool _showBatteryWarning = true;
  bool _isLocationEnabled = true;
  double _gpsAccuracy = 8.5;

  // Mock trip data
  final Map<String, dynamic> _mockTripData = {
    "startTime": DateTime.now().subtract(const Duration(minutes: 23)),
    "currentDistance": 4.2,
    "detectedModes": [
      {"mode": "car", "confidence": 0.85, "duration": 15},
      {"mode": "walk", "confidence": 0.92, "duration": 8},
    ],
    "routePoints": [
      {"lat": 37.7749, "lng": -122.4194, "timestamp": "2025-01-13T13:40:24Z"},
      {"lat": 37.7849, "lng": -122.4094, "timestamp": "2025-01-13T13:45:24Z"},
      {"lat": 37.7949, "lng": -122.3994, "timestamp": "2025-01-13T13:50:24Z"},
    ],
    "gpsAccuracy": 8.5,
    "batteryOptimized": false,
  };

  @override
  void initState() {
    super.initState();
    _initializeTrip();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _mapController?.dispose();
    super.dispose();
  }

  Future<void> _initializeTrip() async {
    await _requestLocationPermission();
    await _getCurrentLocation();
    _startTrip();
  }

  Future<void> _requestLocationPermission() async {
    final status = await Permission.location.request();
    setState(() {
      _isLocationEnabled = status.isGranted;
    });
  }

  Future<void> _getCurrentLocation() async {
    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        _currentPosition = position;
        _gpsAccuracy = position.accuracy;
      });
      _updateMapLocation();
    } catch (e) {
      // Handle location error
      setState(() {
        _currentPosition = Position(
          latitude: 37.7749,
          longitude: -122.4194,
          timestamp: DateTime.now(),
          accuracy: 10.0,
          altitude: 0.0,
          altitudeAccuracy: 0.0,
          heading: 0.0,
          headingAccuracy: 0.0,
          speed: 0.0,
          speedAccuracy: 0.0,
        );
      });
    }
  }

  void _startTrip() {
    setState(() {
      _isTracking = true;
      _tripStartTime = DateTime.now();
    });
    _startLocationTracking();
  }

  void _startLocationTracking() {
    // Simulate location updates
    Future.delayed(const Duration(seconds: 5), () {
      if (_isTracking && !_isPaused) {
        _updateTripData();
        _startLocationTracking();
      }
    });
  }

  void _updateTripData() {
    if (!mounted) return;

    setState(() {
      _totalDistance += 0.1; // Simulate distance increment
      _gpsAccuracy = 5.0 + (DateTime.now().millisecond % 20);

      // Add route point
      if (_currentPosition != null) {
        final newPoint = LatLng(
          _currentPosition!.latitude +
              (DateTime.now().millisecond % 100) / 100000,
          _currentPosition!.longitude +
              (DateTime.now().millisecond % 100) / 100000,
        );
        _routePoints.add(newPoint);
        _updatePolyline();
      }
    });
  }

  void _updatePolyline() {
    if (_routePoints.length < 2) return;

    setState(() {
      _polylines.clear();
      _polylines.add(
        Polyline(
          polylineId: const PolylineId('trip_route'),
          points: _routePoints,
          color: AppTheme.primaryBlue,
          width: 4,
          patterns: [],
        ),
      );
    });
  }

  void _updateMapLocation() {
    if (_currentPosition == null) return;

    setState(() {
      _markers.clear();
      _markers.add(
        Marker(
          markerId: const MarkerId('current_location'),
          position:
              LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        ),
      );
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    if (_currentPosition != null) {
      _centerMapOnLocation();
    }
  }

  void _centerMapOnLocation() {
    if (_mapController != null && _currentPosition != null) {
      _mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
          16.0,
        ),
      );
    }
  }

  void _onModeSelected(String mode) {
    HapticFeedback.selectionClick();
    setState(() {
      _selectedMode = mode;
      _detectedMode = mode;
      _modeConfidence = 0.95; // High confidence for manual selection
    });
  }

  void _onCompanionCountChanged(int count) {
    setState(() {
      _companionCount = count;
    });
  }

  void _onNoteChanged(String note) {
    setState(() {
      _tripNote = note;
    });
  }

  void _onPauseResume() {
    setState(() {
      _isPaused = !_isPaused;
    });

    if (_isPaused) {
      // Pause tracking
    } else {
      // Resume tracking
      _startLocationTracking();
    }
  }

  void _onEndTrip() {
    setState(() {
      _isTracking = false;
      _isPaused = false;
    });

    // Navigate to trip summary or dashboard
    Navigator.pushReplacementNamed(context, '/trip-dashboard');
  }

  String _formatDuration() {
    if (_tripStartTime == null) return '00:00:00';

    final duration = DateTime.now().difference(_tripStartTime!);
    final hours = duration.inHours.toString().padLeft(2, '0');
    final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');

    return '$hours:$minutes:$seconds';
  }

  String _formatDistance() {
    return '${_totalDistance.toStringAsFixed(1)} km';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.activeTrip(
        onStopTrip: _onEndTrip,
      ),
      body: Stack(
        children: [
          // Google Maps
          _buildMap(),

          // GPS Accuracy Indicator
          Positioned(
            top: 0,
            right: 0,
            child: GpsAccuracyIndicator(
              accuracy: _gpsAccuracy,
              isLocationEnabled: _isLocationEnabled,
            ),
          ),

          // Trip Info Card
          Positioned(
            top: 8.h,
            left: 0,
            right: 0,
            child: TripInfoCard(
              duration: _formatDuration(),
              distance: _formatDistance(),
              detectedMode: _detectedMode,
              confidence: _modeConfidence,
            ),
          ),

          // Travel Mode Selector
          Positioned(
            top: 22.h,
            left: 0,
            right: 0,
            child: TravelModeSelector(
              selectedMode: _selectedMode,
              onModeSelected: _onModeSelected,
            ),
          ),

          // Battery Warning
          if (_showBatteryWarning)
            Positioned(
              top: 35.h,
              left: 0,
              right: 0,
              child: BatteryOptimizationWarning(
                onDismiss: () => setState(() => _showBatteryWarning = false),
                onOpenSettings: () {
                  // Open device settings
                  setState(() => _showBatteryWarning = false);
                },
              ),
            ),

          // Center Location Button
          Positioned(
            bottom: 35.h,
            right: 4.w,
            child: FloatingActionButton(
              mini: true,
              onPressed: _centerMapOnLocation,
              backgroundColor: AppTheme.backgroundWhite,
              child: CustomIconWidget(
                iconName: 'my_location',
                color: AppTheme.primaryBlue,
                size: 24,
              ),
            ),
          ),

          // Trip Controls Bottom Sheet
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: TripControlsSheet(
              onEndTrip: _onEndTrip,
              companionCount: _companionCount,
              onCompanionCountChanged: _onCompanionCountChanged,
              tripNote: _tripNote,
              onNoteChanged: _onNoteChanged,
              isPaused: _isPaused,
              onPauseResume: _onPauseResume,
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomBar.activeTrip(),
    );
  }

  Widget _buildMap() {
    return GoogleMap(
      onMapCreated: _onMapCreated,
      initialCameraPosition: CameraPosition(
        target: _currentPosition != null
            ? LatLng(_currentPosition!.latitude, _currentPosition!.longitude)
            : const LatLng(37.7749, -122.4194),
        zoom: 16.0,
      ),
      markers: _markers,
      polylines: _polylines,
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
      mapToolbarEnabled: false,
      compassEnabled: true,
      trafficEnabled: false,
      buildingsEnabled: true,
      indoorViewEnabled: false,
      mapType: MapType.normal,
      onTap: (LatLng position) {
        // Handle map tap if needed
      },
      gestureRecognizers: const <Factory<OneSequenceGestureRecognizer>>{},
    );
  }
}