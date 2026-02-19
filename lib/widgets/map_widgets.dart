import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../constants/app_constants.dart';

class MapTileLayer extends StatelessWidget {
  const MapTileLayer({super.key});

  @override
  Widget build(BuildContext context) {
    return TileLayer(
      urlTemplate: MapConstants.tileUrl,
      userAgentPackageName: MapConstants.userAgent,
      maxZoom: MapConstants.maxZoom.toInt() + 1,
    );
  }
}

class LocationMarker extends StatelessWidget {
  final LatLng position;

  const LocationMarker({
    super.key,
    required this.position,
  });

  @override
  Widget build(BuildContext context) {
    return MarkerLayer(
      markers: [
        Marker(
          point: position,
          width: MapConstants.markerSize,
          height: MapConstants.markerSize,
          child: const Icon(
            Icons.location_pin,
            color: Colors.red,
            size: MapConstants.markerSize,
          ),
        ),
      ],
    );
  }
}

class LocationFab extends StatelessWidget {
  final bool isLoading;
  final VoidCallback? onPressed;

  const LocationFab({
    super.key,
    required this.isLoading,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: isLoading ? null : onPressed,
      child: isLoading 
        ? const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
        : const Icon(Icons.my_location),
    );
  }
}


class CreatePlace extends StatelessWidget {
  final bool isLoading;
  final VoidCallback? onPressed;

  const CreatePlace({
    super.key,
    required this.isLoading,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: isLoading ? null : onPressed,
      child: isLoading 
        ? const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
        : const Icon(Icons.add),
    );
  }
}

