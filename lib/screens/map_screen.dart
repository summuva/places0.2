import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:provider/provider.dart';
import '../providers/map_provider.dart';
import '../widgets/map_buttons.dart';
import '../widgets/map_layers.dart';
import '../widgets/instruction_banner.dart';

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
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: mapProv.currentPosition,
              initialZoom: 13.0,
              onTap: (_, point) {
                if (mapProv.isCreating) {
                  mapProv.selectPosition(point);
                }
              },
            ),
            children: [
              MapLayers(mapProv: mapProv),
            ],
          ),
          if (mapProv.isCreating)
            InstructionBanner(hasSelection: mapProv.selectedPosition != null),
        ],
      ),
      floatingActionButton: MapButtons(
        mapController: _mapController,
        vsync: this,
      ),
    );
  }
}