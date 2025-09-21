import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class TripStatisticsWidget extends StatelessWidget {
  final Map<String, dynamic> tripData;

  const TripStatisticsWidget({
    super.key,
    required this.tripData,
  });

  String _calculateCarbonFootprint(String travelMode, double distance) {
    // Carbon footprint calculation in kg CO2
    const Map<String, double> emissionFactors = {
      'walk': 0.0,
      'bicycle': 0.0,
      'bus': 0.089, // kg CO2 per km
      'train': 0.041,
      'car': 0.171,
      'motorcycle': 0.113,
      'rideshare': 0.171,
      'flight': 0.255,
      'boat': 0.285,
    };

    final factor = emissionFactors[travelMode.toLowerCase()] ?? 0.171;
    final footprint = distance * factor;
    return footprint.toStringAsFixed(2);
  }

  String _calculateCost(String travelMode, double distance) {
    // Estimated cost calculation in USD
    const Map<String, double> costFactors = {
      'walk': 0.0,
      'bicycle': 0.0,
      'bus': 0.15, // USD per km
      'train': 0.12,
      'car': 0.25,
      'motorcycle': 0.18,
      'rideshare': 0.35,
      'flight': 0.45,
      'boat': 0.30,
    };

    final factor = costFactors[travelMode.toLowerCase()] ?? 0.25;
    final cost = distance * factor;
    return cost.toStringAsFixed(2);
  }

  double _calculateAverageSpeed(double distance, int durationMinutes) {
    if (durationMinutes == 0) return 0.0;
    final durationHours = durationMinutes / 60.0;
    return distance / durationHours;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final distance = (tripData['distance'] as num).toDouble();
    final duration = tripData['duration'] as int;
    final travelMode = tripData['travelMode'] as String;

    final averageSpeed = _calculateAverageSpeed(distance, duration);
    final carbonFootprint = _calculateCarbonFootprint(travelMode, distance);
    final estimatedCost = _calculateCost(travelMode, distance);

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
                iconName: 'analytics',
                color: AppTheme.primaryBlue,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                'Trip Statistics',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 16.sp,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  context,
                  'Average Speed',
                  '${averageSpeed.toStringAsFixed(1)} km/h',
                  'speed',
                  AppTheme.primaryBlue,
                  isDark,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  context,
                  'Carbon Footprint',
                  '${carbonFootprint} kg CO₂',
                  'eco',
                  AppTheme.successGreen,
                  isDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  context,
                  'Estimated Cost',
                  '\$${estimatedCost}',
                  'attach_money',
                  AppTheme.warningAmber,
                  isDark,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  context,
                  'Data Quality',
                  tripData['dataQuality'] as String? ?? 'High',
                  'verified',
                  AppTheme.accentTeal,
                  isDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildInsightCard(context, travelMode, carbonFootprint, isDark),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String title,
    String value,
    String iconName,
    Color color,
    bool isDark,
  ) {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: CustomIconWidget(
                  iconName: iconName,
                  color: color,
                  size: 16,
                ),
              ),
              const Spacer(),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 14.sp,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: theme.textTheme.bodySmall?.copyWith(
              color:
                  isDark ? AppTheme.textSecondaryDark : AppTheme.textSecondary,
              fontSize: 10.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInsightCard(BuildContext context, String travelMode,
      String carbonFootprint, bool isDark) {
    final theme = Theme.of(context);
    String insightText = '';
    String insightIcon = 'lightbulb';
    Color insightColor = AppTheme.primaryBlue;

    final footprintValue = double.tryParse(carbonFootprint) ?? 0.0;

    if (travelMode.toLowerCase() == 'walk' ||
        travelMode.toLowerCase() == 'bicycle') {
      insightText =
          'Great choice! This eco-friendly trip produced zero emissions.';
      insightIcon = 'eco';
      insightColor = AppTheme.successGreen;
    } else if (footprintValue < 1.0) {
      insightText =
          'Low carbon impact trip. Consider this mode for similar distances.';
      insightIcon = 'thumb_up';
      insightColor = AppTheme.successGreen;
    } else if (footprintValue > 5.0) {
      insightText =
          'High carbon impact. Consider alternative transport for future trips.';
      insightIcon = 'warning';
      insightColor = AppTheme.warningAmber;
    } else {
      insightText =
          'Moderate environmental impact. Good balance of convenience and sustainability.';
      insightIcon = 'balance';
      insightColor = AppTheme.accentTeal;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: insightColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: insightColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: insightColor.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: CustomIconWidget(
              iconName: insightIcon,
              color: insightColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Trip Insight',
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: insightColor,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  insightText,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontSize: 11.sp,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
