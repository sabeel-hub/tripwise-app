import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class TripMapWidget extends StatefulWidget {
  final Map<String, dynamic> tripData;
  final VoidCallback? onFullScreen;

  const TripMapWidget({
    super.key,
    required this.tripData,
    this.onFullScreen,
  });

  @override
  State<TripMapWidget> createState() => _TripMapWidgetState();
}

class _TripMapWidgetState extends State<TripMapWidget> {
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};

  @override
  void initState() {
    super.initState();
    _setupMapData();
  }

  void _setupMapData() {
    final originLat = (widget.tripData['origin']['latitude'] as num).toDouble();
    final originLng =
        (widget.tripData['origin']['longitude'] as num).toDouble();
    final destinationLat =
        (widget.tripData['destination']['latitude'] as num).toDouble();
    final destinationLng =
        (widget.tripData['destination']['longitude'] as num).toDouble();

    _markers = {
      Marker(
        markerId: const MarkerId('origin'),
        position: LatLng(originLat, originLng),
        infoWindow: InfoWindow(
          title: 'Origin',
          snippet: widget.tripData['origin']['address'] as String,
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      ),
      Marker(
        markerId: const MarkerId('destination'),
        position: LatLng(destinationLat, destinationLng),
        infoWindow: InfoWindow(
          title: 'Destination',
          snippet: widget.tripData['destination']['address'] as String,
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ),
    };

    _polylines = {
      Polyline(
        polylineId: const PolylineId('route'),
        points: [
          LatLng(originLat, originLng),
          LatLng(destinationLat, destinationLng),
        ],
        color: AppTheme.primaryBlue,
        width: 4,
        patterns: [],
      ),
    };
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    _fitMapToRoute();
  }

  void _fitMapToRoute() {
    if (_mapController != null && _markers.isNotEmpty) {
      final bounds = _calculateBounds();
      _mapController!.animateCamera(
        CameraUpdate.newLatLngBounds(bounds, 100.0),
      );
    }
  }

  LatLngBounds _calculateBounds() {
    final originLat = (widget.tripData['origin']['latitude'] as num).toDouble();
    final originLng =
        (widget.tripData['origin']['longitude'] as num).toDouble();
    final destinationLat =
        (widget.tripData['destination']['latitude'] as num).toDouble();
    final destinationLng =
        (widget.tripData['destination']['longitude'] as num).toDouble();

    final southwest = LatLng(
      originLat < destinationLat ? originLat : destinationLat,
      originLng < destinationLng ? originLng : destinationLng,
    );
    final northeast = LatLng(
      originLat > destinationLat ? originLat : destinationLat,
      originLng > destinationLng ? originLng : destinationLng,
    );

    return LatLngBounds(southwest: southwest, northeast: northeast);
  }

  @override
  Widget build(BuildContext context) {
    final originLat = (widget.tripData['origin']['latitude'] as num).toDouble();
    final originLng =
        (widget.tripData['origin']['longitude'] as num).toDouble();

    return Container(
      width: double.infinity,
      height: 30.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: AppTheme.getElevationShadow(
          isLight: Theme.of(context).brightness == Brightness.light,
          elevation: 2,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: LatLng(originLat, originLng),
                zoom: 12.0,
              ),
              markers: _markers,
              polylines: _polylines,
              mapType: MapType.normal,
              myLocationEnabled: false,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              mapToolbarEnabled: false,
            ),
            Positioned(
              top: 12,
              right: 12,
              child: Container(
                decoration: BoxDecoration(
                  color: AppTheme.backgroundWhite.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: AppTheme.getElevationShadow(
                    isLight: true,
                    elevation: 2,
                  ),
                ),
                child: IconButton(
                  onPressed: widget.onFullScreen,
                  icon: CustomIconWidget(
                    iconName: 'fullscreen',
                    color: AppTheme.textPrimary,
                    size: 20,
                  ),
                  tooltip: 'Full screen',
                  splashRadius: 20,
                ),
              ),
            ),
            Positioned(
              bottom: 12,
              left: 12,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AppTheme.backgroundWhite.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: AppTheme.getElevationShadow(
                    isLight: true,
                    elevation: 2,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomIconWidget(
                      iconName: 'gps_fixed',
                      color: AppTheme.successGreen,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'GPS Accuracy: ${widget.tripData['gpsAccuracy'] ?? 'High'}',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.textSecondary,
                        fontSize: 10.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }
}
