import 'package:flutter/material.dart';
import '../presentation/active_trip_tracking/active_trip_tracking.dart';
import '../presentation/trip_history/trip_history.dart';
import '../presentation/trip_dashboard/trip_dashboard.dart';
import '../presentation/manual_trip_entry/manual_trip_entry.dart';
import '../presentation/settings_and_privacy/settings_and_privacy.dart';
import '../presentation/trip_detail_view/trip_detail_view.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String activeTripTracking = '/active-trip-tracking';
  static const String tripHistory = '/trip-history';
  static const String tripDashboard = '/trip-dashboard';
  static const String manualTripEntry = '/manual-trip-entry';
  static const String settingsAndPrivacy = '/settings-and-privacy';
  static const String tripDetailView = '/trip-detail-view';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const ActiveTripTracking(),
    activeTripTracking: (context) => const ActiveTripTracking(),
    tripHistory: (context) => const TripHistory(),
    tripDashboard: (context) => const TripDashboard(),
    manualTripEntry: (context) => const ManualTripEntry(),
    settingsAndPrivacy: (context) => const SettingsAndPrivacy(),
    tripDetailView: (context) => const TripDetailView(),
    // TODO: Add your other routes here
  };
}
