import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import './widgets/advanced_details_widget.dart';
import './widgets/companion_counter_widget.dart';
import './widgets/date_time_picker_widget.dart';
import './widgets/distance_duration_widget.dart';
import './widgets/location_input_widget.dart';
import './widgets/travel_mode_selector_widget.dart';
import './widgets/trip_purpose_selector_widget.dart';

class ManualTripEntry extends StatefulWidget {
  const ManualTripEntry({super.key});

  @override
  State<ManualTripEntry> createState() => _ManualTripEntryState();
}

class _ManualTripEntryState extends State<ManualTripEntry> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ScrollController _scrollController = ScrollController();

  // Form data
  String _origin = '';
  String _destination = '';
  String? _travelMode;
  DateTime? _startDateTime;
  DateTime? _endDateTime;
  int _companionCount = 0;
  List<String> _companionDetails = [];
  String? _tripPurpose;
  String _customPurpose = '';
  double? _distance;
  int? _duration;
  bool _advancedExpanded = false;
  double? _cost;
  String? _weather;
  int? _rating;
  String? _notes;

  bool _isDraftSaved = false;
  bool _isFormValid = false;

  @override
  void initState() {
    super.initState();
    _loadDraftIfExists();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _loadDraftIfExists() {
    // Simulate loading draft data
    setState(() {
      _isDraftSaved = false;
    });
  }

  void _validateForm() {
    final isValid = _origin.isNotEmpty &&
        _destination.isNotEmpty &&
        _travelMode != null &&
        _startDateTime != null &&
        _endDateTime != null &&
        (_startDateTime!.isBefore(_endDateTime!));

    if (_isFormValid != isValid) {
      setState(() {
        _isFormValid = isValid;
      });
    }
  }

  void _saveDraft() {
    setState(() {
      _isDraftSaved = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Draft saved successfully'),
        backgroundColor: AppTheme.successGreen,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _saveTrip() {
    if (!_isFormValid) return;

    // Simulate saving trip
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            CustomIconWidget(
              iconName: 'check_circle',
              color: AppTheme.successGreen,
              size: 24,
            ),
            SizedBox(width: 3.w),
            const Text('Trip Saved'),
          ],
        ),
        content: const Text('Your trip has been saved successfully!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.pushReplacementNamed(context, '/trip-dashboard');
            },
            child: const Text('Go to Dashboard'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _resetForm();
            },
            child: const Text('Add Another Trip'),
          ),
        ],
      ),
    );
  }

  void _resetForm() {
    setState(() {
      _origin = '';
      _destination = '';
      _travelMode = null;
      _startDateTime = null;
      _endDateTime = null;
      _companionCount = 0;
      _companionDetails = [];
      _tripPurpose = null;
      _customPurpose = '';
      _distance = null;
      _duration = null;
      _advancedExpanded = false;
      _cost = null;
      _weather = null;
      _rating = null;
      _notes = null;
      _isDraftSaved = false;
      _isFormValid = false;
    });
  }

  void _showExitConfirmation() {
    if (_hasUnsavedChanges()) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Unsaved Changes'),
          content: const Text(
              'You have unsaved changes. Do you want to save as draft before leaving?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: const Text('Discard'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _saveDraft();
                Navigator.of(context).pop();
              },
              child: const Text('Save Draft'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Continue Editing'),
            ),
          ],
        ),
      );
    } else {
      Navigator.of(context).pop();
    }
  }

  bool _hasUnsavedChanges() {
    return _origin.isNotEmpty ||
        _destination.isNotEmpty ||
        _travelMode != null ||
        _startDateTime != null ||
        _endDateTime != null ||
        _companionCount > 0 ||
        _tripPurpose != null ||
        _distance != null ||
        _duration != null ||
        _cost != null ||
        _weather != null ||
        _rating != null ||
        (_notes?.isNotEmpty ?? false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (!didPop) {
          _showExitConfirmation();
        }
      },
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: CustomAppBar.manualEntry(
          onSave: _isFormValid ? _saveTrip : null,
          canSave: _isFormValid,
        ),
        body: Form(
          key: _formKey,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  padding: EdgeInsets.all(4.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header section
                      Container(
                        padding: EdgeInsets.all(4.w),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primaryContainer
                              .withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: theme.colorScheme.primary
                                .withValues(alpha: 0.3),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            CustomIconWidget(
                              iconName: 'add_location',
                              color: theme.colorScheme.primary,
                              size: 24,
                            ),
                            SizedBox(width: 3.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Add New Trip',
                                    style:
                                        theme.textTheme.titleMedium?.copyWith(
                                      color: theme.colorScheme.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    'Fill in the details below to record your trip',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: theme.colorScheme.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 4.h),

                      // Origin location
                      LocationInputWidget(
                        label: 'Origin',
                        value: _origin,
                        onChanged: (value) {
                          setState(() {
                            _origin = value;
                          });
                          _validateForm();
                        },
                        isRequired: true,
                        hintText: 'Where did your trip start?',
                      ),

                      SizedBox(height: 3.h),

                      // Destination location
                      LocationInputWidget(
                        label: 'Destination',
                        value: _destination,
                        onChanged: (value) {
                          setState(() {
                            _destination = value;
                          });
                          _validateForm();
                        },
                        isRequired: true,
                        hintText: 'Where did your trip end?',
                      ),

                      SizedBox(height: 4.h),

                      // Travel mode selector
                      TravelModeSelectorWidget(
                        selectedMode: _travelMode,
                        onModeSelected: (mode) {
                          setState(() {
                            _travelMode = mode;
                          });
                          _validateForm();
                        },
                      ),

                      SizedBox(height: 4.h),

                      // Date and time pickers
                      Row(
                        children: [
                          Expanded(
                            child: DateTimePickerWidget(
                              label: 'Start Time',
                              selectedDateTime: _startDateTime,
                              onDateTimeSelected: (dateTime) {
                                setState(() {
                                  _startDateTime = dateTime;
                                });
                                _validateForm();
                              },
                              isRequired: true,
                              maximumDate: DateTime.now(),
                            ),
                          ),
                          SizedBox(width: 4.w),
                          Expanded(
                            child: DateTimePickerWidget(
                              label: 'End Time',
                              selectedDateTime: _endDateTime,
                              onDateTimeSelected: (dateTime) {
                                setState(() {
                                  _endDateTime = dateTime;
                                });
                                _validateForm();
                              },
                              isRequired: true,
                              minimumDate: _startDateTime,
                              maximumDate: DateTime.now(),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 4.h),

                      // Distance and duration
                      DistanceDurationWidget(
                        distance: _distance,
                        duration: _duration,
                        onDistanceChanged: (distance) {
                          setState(() {
                            _distance = distance;
                          });
                        },
                        onDurationChanged: (duration) {
                          setState(() {
                            _duration = duration;
                          });
                        },
                        travelMode: _travelMode,
                      ),

                      SizedBox(height: 4.h),

                      // Companion counter
                      CompanionCounterWidget(
                        companionCount: _companionCount,
                        onCountChanged: (count) {
                          setState(() {
                            _companionCount = count;
                          });
                        },
                        companionDetails: _companionDetails,
                        onDetailsChanged: (details) {
                          setState(() {
                            _companionDetails = details;
                          });
                        },
                      ),

                      SizedBox(height: 4.h),

                      // Trip purpose selector
                      TripPurposeSelectorWidget(
                        selectedPurpose: _tripPurpose,
                        onPurposeSelected: (purpose) {
                          setState(() {
                            _tripPurpose = purpose;
                          });
                        },
                        customPurpose: _customPurpose,
                        onCustomPurposeChanged: (custom) {
                          setState(() {
                            _customPurpose = custom;
                          });
                        },
                      ),

                      SizedBox(height: 4.h),

                      // Advanced details section
                      AdvancedDetailsWidget(
                        isExpanded: _advancedExpanded,
                        onExpandedChanged: (expanded) {
                          setState(() {
                            _advancedExpanded = expanded;
                          });
                        },
                        cost: _cost,
                        onCostChanged: (cost) {
                          setState(() {
                            _cost = cost;
                          });
                        },
                        weather: _weather,
                        onWeatherChanged: (weather) {
                          setState(() {
                            _weather = weather;
                          });
                        },
                        rating: _rating,
                        onRatingChanged: (rating) {
                          setState(() {
                            _rating = rating;
                          });
                        },
                        notes: _notes,
                        onNotesChanged: (notes) {
                          setState(() {
                            _notes = notes;
                          });
                        },
                      ),

                      SizedBox(height: 6.h),

                      // Action buttons
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed:
                                  _hasUnsavedChanges() ? _saveDraft : null,
                              icon: CustomIconWidget(
                                iconName: 'save',
                                color: _hasUnsavedChanges()
                                    ? theme.colorScheme.primary
                                    : theme.colorScheme.onSurfaceVariant
                                        .withValues(alpha: 0.5),
                                size: 18,
                              ),
                              label: Text(
                                  _isDraftSaved ? 'Draft Saved' : 'Save Draft'),
                            ),
                          ),
                          SizedBox(width: 4.w),
                          Expanded(
                            flex: 2,
                            child: ElevatedButton.icon(
                              onPressed: _isFormValid ? _saveTrip : null,
                              icon: CustomIconWidget(
                                iconName: 'check',
                                color: _isFormValid
                                    ? theme.colorScheme.onPrimary
                                    : theme.colorScheme.onSurfaceVariant
                                        .withValues(alpha: 0.5),
                                size: 18,
                              ),
                              label: const Text('Save Trip'),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 2.h),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: CustomBottomBar.manualEntry(
          onTap: (route) {
            if (route != '/manual-trip-entry') {
              if (_hasUnsavedChanges()) {
                _showExitConfirmation();
              } else {
                Navigator.pushReplacementNamed(context, route);
              }
            }
          },
        ),
      ),
    );
  }
}
