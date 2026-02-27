import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:provider/provider.dart';
import '../providers/map_provider.dart';
import 'create_place_dialog.dart';

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
      shape: const CircleBorder(),
      backgroundColor: Colors.white,
      foregroundColor: Colors.black87,
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
      shape: const CircleBorder(),
      backgroundColor: mapProv.isCreating
          ? (mapProv.selectedPosition != null ? Colors.green : Colors.grey)
          : Colors.white,
      onPressed: () async {
        if (mapProv.isCreating && mapProv.selectedPosition != null) {
          // Mostrar modal
          final place = await CreatePlaceDialog.show(
            context,
            mapProv.selectedPosition!,
          );

          if (place != null) {
            mapProv.addPlace(place);
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('✅ "${place.name}" guardado')),
              );
            }
          }
        } else {
          mapProv.toggleCreationMode();
        }
      },
      child: Icon(
        mapProv.isCreating
            ? (mapProv.selectedPosition != null ? Icons.check : Icons.close)
            // cambiar el color del icono de locacion a blanco
              : Icons.add_location_alt,
              color: Colors.black,

      ),
    );
  }
}