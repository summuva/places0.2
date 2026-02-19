import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart'; // Import needed for LatLng
import 'package:provider/provider.dart';
import '../providers/map_provider.dart';
import '../widgets/map_widgets.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with TickerProviderStateMixin {
  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MapProvider>().getUserLocation(
        mapController: _mapController,
        vsync: this,
        animate: false,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final mapProv = context.watch<MapProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(mapProv.isCreating ? 'Toca el mapa para marcar' : 'Places'),
        backgroundColor: mapProv.isCreating ? Colors.green.shade100 : null,
      ),
      body: _MapLayers(mapProv: mapProv),
      floatingActionButton: _MapButtons(
        mapController: _mapController,
        vsync: this,
      ),
    );
  }
}

class _MapButtons extends StatelessWidget {
  final MapController mapController;
  final TickerProvider vsync;

  const _MapButtons({required this.mapController, required this.vsync});

  @override
  Widget build(BuildContext context) {
    final mapProv = context.watch<MapProvider>();

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // Location Button
        FloatingActionButton(
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
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)
                )
              : const Icon(Icons.my_location),
        ),
        
        const SizedBox(height: 10),
        
        // Create/Add Place Button
        FloatingActionButton(
          heroTag: 'create_btn',
          // Change color based on state
          backgroundColor: mapProv.isCreating 
              ? (mapProv.selectedPosition != null ? Colors.green : Colors.grey)
              : Theme.of(context).primaryColor,
          onPressed: () {
            if (mapProv.isCreating && mapProv.selectedPosition != null) {
              // Confirm action
              // Here you would navigate to a form or save the place
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Lugar seleccionado en: ${mapProv.selectedPosition!.latitude}, ${mapProv.selectedPosition!.longitude}'))
              );
              mapProv.toggleCreationMode();
            } else {
              // Toggle mode (On/Off)
              mapProv.toggleCreationMode();
            }
          },
          // Change icon: Add -> Close (if picking) -> Check (if picked)
          child: Icon(
            mapProv.isCreating 
              ? (mapProv.selectedPosition != null ? Icons.check : Icons.close)
              : Icons.add_location_alt,
          ),
        ),
      ],
    );
  }
}

class _InstructionBanner extends StatelessWidget {
  final bool hasSelection;

  const _InstructionBanner({required this.hasSelection});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 10,
      left: 0,
      right: 0,
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
          ),
          child: Text(
            hasSelection ? '¡Ubicación seleccionada!' : 'Toca una ubicación',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}

class _MapLayers extends StatelessWidget {
  final MapProvider mapProv;

  const _MapLayers({required this.mapProv});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const MapTileLayer(),
        LocationMarker(position: mapProv.currentPosition),
        
        // Marcador de selección (solo si está creando)
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
                  size: 50
                ),
              ),
            ],
          ),
      ],
    );
  }
}