import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import '../providers/map_provider.dart';
import 'map_widgets.dart';

class MapLayers extends StatelessWidget {
  final MapProvider mapProv;

  const MapLayers({super.key, required this.mapProv});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const MapTileLayer(),
        LocationMarker(position: mapProv.currentPosition),
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
                  color: Colors.green,
                  size: 50,
                ),
              ),
            ],
          ),
      ],
    );
  }
}