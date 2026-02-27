import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../providers/map_provider.dart';
import 'markers/location_marker.dart';
import 'markers/place_marker.dart';
import 'markers/selection_marker.dart';

class MapLayers extends StatelessWidget {
  final MapProvider mapProv;

  const MapLayers({super.key, required this.mapProv});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.places2',
        ),

        // Ubicación actual
        MarkerLayer(
          markers: [
            Marker(
              point: mapProv.currentPosition,
              width: 60,
              height: 60,
              child: const LocationMarker(),
            ),
          ],
        ),

        // Lugares guardados
        MarkerLayer(
          markers: mapProv.places.map((place) => Marker(
            point: LatLng(place.lat, place.lng),
            width: 50,
            height: 50,
            alignment: Alignment.topCenter,
            child: PlaceMarker(place: place),
          )).toList(),
        ),

        // Marcador temporal
        if (mapProv.isCreating && mapProv.selectedPosition != null)
          MarkerLayer(
            markers: [
              Marker(
                point: mapProv.selectedPosition!,
                width: 50,
                height: 50,
                alignment: Alignment.topCenter,
                child: const SelectionMarker(),
              ),
            ],
          ),
      ],
    );
  }
}