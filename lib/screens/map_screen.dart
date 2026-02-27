import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:provider/provider.dart';
import '../providers/map_provider.dart';
import '../widgets/map_buttons.dart';
import '../widgets/map_layers.dart';
import '../widgets/instruction_banner.dart';
import '../widgets/bottom_nav_bar.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with TickerProviderStateMixin {
  final MapController _mapController = MapController();
  int _selectedIndex = 0;

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
      body: Stack(
        children: [
          // Mapa ocupa toda la pantalla
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

          // Título sobre el mapa
          Positioned(
            top: MediaQuery.of(context).padding.top, 
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                mapProv.isCreating ? 'Toca el mapa para marcar' : 'Places',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: mapProv.isCreating ? Colors.green.shade800 : Colors.black87,
                  shadows: const [
                    Shadow(
                      color: Colors.white,
                      blurRadius: 30,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Banner de instrucciones
          if (mapProv.isCreating)
            InstructionBanner(hasSelection: mapProv.selectedPosition != null),
        ],
      ),
      floatingActionButton: MapButtons(
        mapController: _mapController,
        vsync: this,
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
      ),
    );
  }
}