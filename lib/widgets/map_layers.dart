import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../providers/map_provider.dart';

class MapLayers extends StatelessWidget {
  final MapProvider mapProv;

  const MapLayers({super.key, required this.mapProv});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Tile layer
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.places2',
        ),

        // Ubicación actual (azul)
        MarkerLayer(
          markers: [
            Marker(
              point: mapProv.currentPosition,
              width: 40,
              height: 40,
              child: const Icon(Icons.my_location, color: Colors.blue, size: 40),
            ),
          ],
        ),

        // Lugares guardados (verdes) usando lat/lng del modelo
        MarkerLayer(
          markers: mapProv.places.map((place) => Marker(
            point: LatLng(place.lat, place.lng),
            width: 40,
            height: 40,
            alignment: Alignment.topCenter,
            child: Tooltip(
              message: place.name,
              child: const Icon(Icons.location_on, color: Colors.green, size: 40),
            ),
          )).toList(),
        ),

        // Marcador temporal de selección (naranja)
        if (mapProv.isCreating && mapProv.selectedPosition != null)
          MarkerLayer(
            markers: [
              Marker(
                point: mapProv.selectedPosition!,
                width: 50,
                height: 50,
                alignment: Alignment.topCenter,
                child: const Icon(
                  Icons.location_on,
                  color: Colors.orange,
                  size: 50,
                ),
              ),
            ],
          ),
      ],
    );
  }
}