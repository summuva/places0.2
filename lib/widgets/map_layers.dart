import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../providers/map_provider.dart';
import '../models/place_model.dart';
import 'markers/location_marker.dart';
import 'markers/place_marker.dart';
import 'markers/selection_marker.dart';

class MapLayers extends StatelessWidget {
  final MapProvider mapProv;
  final void Function(Place place)? onPlaceTap;

  const MapLayers({super.key, required this.mapProv, this.onPlaceTap});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.places2',
        ),

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

        MarkerLayer(
          markers: mapProv.filteredPlaces.map((place) => Marker(
            point: LatLng(place.lat, place.lng),
            width: 50,
            height: 50,
            alignment: Alignment.topCenter,
            child: PlaceMarker(
              place: place,
              onTap: () => onPlaceTap?.call(place),
            ),
          )).toList(),
        ),

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