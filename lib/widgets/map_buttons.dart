import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:provider/provider.dart';
import '../providers/map_provider.dart';

class MapButtons extends StatelessWidget {
  final MapController mapController;
  final TickerProvider vsync;

  const MapButtons({super.key, required this.mapController, required this.vsync});

  @override
  Widget build(BuildContext context) {
    final mapProv = context.watch<MapProvider>();

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _LocationButton(mapController: mapController, vsync: vsync, mapProv: mapProv),
        const SizedBox(height: 10),
        _CreatePlaceButton(mapProv: mapProv),
      ],
    );
  }
}

class _LocationButton extends StatelessWidget {
  final MapController mapController;
  final TickerProvider vsync;
  final MapProvider mapProv;

  const _LocationButton({
    required this.mapController,
    required this.vsync,
    required this.mapProv,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: 'location_btn',
      onPressed: mapProv.isLoading
          ? null
          : () => mapProv.getUserLocation(
                mapController: mapController,
                vsync: vsync,
              ),
      child: mapProv.isLoading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
            )
          : const Icon(Icons.my_location),
    );
  }
}

class _CreatePlaceButton extends StatelessWidget {
  final MapProvider mapProv;

  const _CreatePlaceButton({required this.mapProv});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: 'create_btn',
      backgroundColor: mapProv.isCreating
          ? (mapProv.selectedPosition != null ? Colors.green : Colors.grey)
          : Theme.of(context).primaryColor,
      onPressed: () {
        if (mapProv.isCreating && mapProv.selectedPosition != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Lugar seleccionado en: ${mapProv.selectedPosition!.latitude}, ${mapProv.selectedPosition!.longitude}',
              ),
            ),
          );
          mapProv.toggleCreationMode();
        } else {
          mapProv.toggleCreationMode();
        }
      },
      child: Icon(
        mapProv.isCreating
            ? (mapProv.selectedPosition != null ? Icons.check : Icons.close)
            : Icons.add_location_alt,
      ),
    );
  }
}