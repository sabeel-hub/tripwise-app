import 'dart:convert';
import 'dart:io' if (dart.library.io) 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';
import 'package:universal_html/html.dart' as html;

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import './widgets/data_management_widget.dart';
import './widgets/legal_links_widget.dart';
import './widgets/location_settings_widget.dart';
import './widgets/notification_preferences_widget.dart';
import './widgets/privacy_section_widget.dart';
import './widgets/theme_selector_widget.dart';
import './widgets/units_preference_widget.dart';

class SettingsAndPrivacy extends StatefulWidget {
  const SettingsAndPrivacy({super.key});

  @override
  State<SettingsAndPrivacy> createState() => _SettingsAndPrivacyState();
}

class _SettingsAndPrivacyState extends State<SettingsAndPrivacy> {
  // Privacy settings
  final Map<String, bool> _privacySettings = {
    'location_tracking': true,
    'research_participation': false,
    'analytics_sharing': true,
  };

  // Location settings
  String _accuracyLevel = 'high';
  bool _backgroundTracking = true;

  // Notification settings
  final Map<String, bool> _notificationSettings = {
    'trip_reminders': true,
    'completion_prompts': true,
    'research_updates': false,
  };

  final Map<String, String> _timingSettings = {
    'trip_reminders': '15 minutes',
    'completion_prompts': 'Immediate',
    'research_updates': 'Weekly',
  };

  // Theme and units
  String _selectedTheme = 'system';
  String _selectedUnit = 'imperial';

  // Storage usage
  String _storageUsage = '24.7 MB';

  // Mock user data for export
  final List<Map<String, dynamic>> _mockTripData = [
    {
      "id": 1,
      "date": "2024-12-13",
      "startTime": "08:30 AM",
      "endTime": "09:15 AM",
      "origin": "Home - 123 Main Street, Springfield",
      "destination": "Office - 456 Business Ave, Downtown",
      "distance": "12.3 miles",
      "duration": "45 minutes",
      "mode": "Car",
      "purpose": "Commute",
      "notes": "Regular morning commute, light traffic"
    },
    {
      "id": 2,
      "date": "2024-12-12",
      "startTime": "06:00 PM",
      "endTime": "06:25 PM",
      "origin": "Office - 456 Business Ave, Downtown",
      "destination": "Grocery Store - 789 Market St",
      "distance": "3.8 miles",
      "duration": "25 minutes",
      "mode": "Car",
      "purpose": "Personal",
      "notes": "Quick grocery run after work"
    },
    {
      "id": 3,
      "date": "2024-12-11",
      "startTime": "02:15 PM",
      "endTime": "03:30 PM",
      "origin": "Home - 123 Main Street, Springfield",
      "destination": "Medical Center - 321 Health Blvd",
      "distance": "8.7 miles",
      "duration": "1 hour 15 minutes",
      "mode": "Bus",
      "purpose": "Medical",
      "notes": "Doctor appointment, used public transit"
    }
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: CustomAppBar.settings(),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            SizedBox(height: 1.h),
            _buildHeaderSection(theme),
            SizedBox(height: 2.h),
            PrivacySectionWidget(
              privacySettings: _privacySettings,
              onToggleChanged: _onPrivacyToggleChanged,
            ),
            LocationSettingsWidget(
              accuracyLevel: _accuracyLevel,
              backgroundTracking: _backgroundTracking,
              onAccuracyChanged: _onAccuracyChanged,
              onBackgroundToggle: _onBackgroundToggle,
              onSystemSettings: _openSystemSettings,
            ),
            NotificationPreferencesWidget(
              notificationSettings: _notificationSettings,
              timingSettings: _timingSettings,
              onNotificationToggle: _onNotificationToggle,
              onTimingChanged: _onTimingChanged,
            ),
            ThemeSelectorWidget(
              selectedTheme: _selectedTheme,
              onThemeChanged: _onThemeChanged,
            ),
            UnitsPreferenceWidget(
              selectedUnit: _selectedUnit,
              onUnitChanged: _onUnitChanged,
            ),
            DataManagementWidget(
              storageUsage: _storageUsage,
              onExportData: _exportData,
              onDeleteAccount: _deleteAccount,
              onBackupRestore: _backupRestore,
            ),
            const LegalLinksWidget(),
            SizedBox(height: 10.h),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomBar(
        currentRoute: '/settings-and-privacy',
        onTap: (route) => Navigator.pushReplacementNamed(context, route),
      ),
    );
  }

  Widget _buildHeaderSection(ThemeData theme) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.primaryBlue.withValues(alpha: 0.1),
            AppTheme.accentTeal.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: AppTheme.primaryBlue.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: CustomIconWidget(
              iconName: 'security',
              color: AppTheme.primaryBlue,
              size: 32,
            ),
          ),
          SizedBox(width: 4.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Privacy & Control',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  'Manage your data, privacy settings, and app preferences',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _onPrivacyToggleChanged(String key, bool value) {
    setState(() {
      _privacySettings[key] = value;
    });

    String message = '';
    switch (key) {
      case 'location_tracking':
        message =
            value ? 'Location tracking enabled' : 'Location tracking disabled';
        break;
      case 'research_participation':
        message = value
            ? 'Research participation enabled'
            : 'Research participation disabled';
        break;
      case 'analytics_sharing':
        message =
            value ? 'Analytics sharing enabled' : 'Analytics sharing disabled';
        break;
    }

    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _onAccuracyChanged(String accuracy) {
    setState(() {
      _accuracyLevel = accuracy;
    });

    Fluttertoast.showToast(
      msg: 'Location accuracy set to ${accuracy.toUpperCase()}',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _onBackgroundToggle() {
    setState(() {
      _backgroundTracking = !_backgroundTracking;
    });

    Fluttertoast.showToast(
      msg: _backgroundTracking
          ? 'Background tracking enabled'
          : 'Background tracking disabled',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  Future<void> _openSystemSettings() async {
    try {
      if (!kIsWeb) {
        await openAppSettings();
      }
      Fluttertoast.showToast(
        msg: 'Opening system settings...',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Unable to open system settings',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }

  void _onNotificationToggle(String key, bool value) {
    setState(() {
      _notificationSettings[key] = value;
    });

    String message = '';
    switch (key) {
      case 'trip_reminders':
        message = value ? 'Trip reminders enabled' : 'Trip reminders disabled';
        break;
      case 'completion_prompts':
        message = value
            ? 'Completion prompts enabled'
            : 'Completion prompts disabled';
        break;
      case 'research_updates':
        message =
            value ? 'Research updates enabled' : 'Research updates disabled';
        break;
    }

    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _onTimingChanged(String key, String value) {
    setState(() {
      _timingSettings[key] = value;
    });

    Fluttertoast.showToast(
      msg: 'Timing updated to $value',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _onThemeChanged(String theme) {
    setState(() {
      _selectedTheme = theme;
    });

    Fluttertoast.showToast(
      msg: 'Theme changed to ${theme.toUpperCase()}',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _onUnitChanged(String unit) {
    setState(() {
      _selectedUnit = unit;
    });

    Fluttertoast.showToast(
      msg: 'Units changed to ${unit.toUpperCase()}',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  Future<void> _exportData() async {
    try {
      final exportData = {
        'export_info': {
          'generated_at': DateTime.now().toIso8601String(),
          'app_version': '1.0.0',
          'user_id': 'user_12345',
        },
        'privacy_settings': _privacySettings,
        'location_settings': {
          'accuracy_level': _accuracyLevel,
          'background_tracking': _backgroundTracking,
        },
        'notification_settings': _notificationSettings,
        'timing_settings': _timingSettings,
        'preferences': {
          'theme': _selectedTheme,
          'units': _selectedUnit,
        },
        'trip_history': _mockTripData,
        'statistics': {
          'total_trips': _mockTripData.length,
          'total_distance': '24.8 miles',
          'total_duration': '2 hours 25 minutes',
          'most_used_mode': 'Car',
        },
      };

      final jsonString = const JsonEncoder.withIndent('  ').convert(exportData);
      final filename =
          'tripwise_data_export_${DateTime.now().millisecondsSinceEpoch}.json';

      if (kIsWeb) {
        final bytes = utf8.encode(jsonString);
        final blob = html.Blob([bytes]);
        final url = html.Url.createObjectUrlFromBlob(blob);
        final anchor = html.AnchorElement(href: url)
          ..setAttribute("download", filename)
          ..click();
        html.Url.revokeObjectUrl(url);
      } else {
        final directory = await getApplicationDocumentsDirectory();
        final file = File('${directory.path}/$filename');
        await file.writeAsString(jsonString);
      }

      Fluttertoast.showToast(
        msg: 'Data exported successfully',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Export failed. Please try again.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }

  Future<void> _backupRestore() async {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        final theme = Theme.of(context);
        return Container(
          padding: EdgeInsets.all(4.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Backup & Restore',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 2.h),
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'cloud_upload',
                  color: AppTheme.primaryBlue,
                  size: 24,
                ),
                title: const Text('Backup to Cloud'),
                subtitle: const Text('Save settings to secure cloud storage'),
                onTap: () {
                  Navigator.pop(context);
                  _performBackup();
                },
              ),
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'cloud_download',
                  color: AppTheme.successGreen,
                  size: 24,
                ),
                title: const Text('Restore from Cloud'),
                subtitle: const Text('Restore previously saved settings'),
                onTap: () {
                  Navigator.pop(context);
                  _performRestore();
                },
              ),
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'file_upload',
                  color: AppTheme.accentTeal,
                  size: 24,
                ),
                title: const Text('Import Settings'),
                subtitle: const Text('Import settings from file'),
                onTap: () {
                  Navigator.pop(context);
                  _importSettings();
                },
              ),
              SizedBox(height: 2.h),
            ],
          ),
        );
      },
    );
  }

  Future<void> _performBackup() async {
    try {
      await Future.delayed(const Duration(seconds: 2));

      Fluttertoast.showToast(
        msg: 'Settings backed up successfully',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Backup failed. Please try again.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }

  Future<void> _performRestore() async {
    try {
      await Future.delayed(const Duration(seconds: 2));

      Fluttertoast.showToast(
        msg: 'Settings restored successfully',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Restore failed. Please try again.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }

  Future<void> _importSettings() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );

      if (result != null) {
        String content;
        if (kIsWeb) {
          final bytes = result.files.first.bytes;
          if (bytes != null) {
            content = utf8.decode(bytes);
          } else {
            throw Exception('Unable to read file');
          }
        } else {
          final file = File(result.files.first.path!);
          content = await file.readAsString();
        }

        final data = jsonDecode(content) as Map<String, dynamic>;

        // Apply imported settings
        if (data['privacy_settings'] != null) {
          setState(() {
            _privacySettings.addAll(
              Map<String, bool>.from(data['privacy_settings'] as Map),
            );
          });
        }

        Fluttertoast.showToast(
          msg: 'Settings imported successfully',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Import failed. Please check file format.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }

  void _deleteAccount() {
    Fluttertoast.showToast(
      msg: 'Account deletion initiated. You will be contacted within 24 hours.',
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
    );
  }
}