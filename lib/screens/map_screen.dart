import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../providers/map_provider.dart';
import '../models/place_model.dart';
import '../utils/map_animator.dart';
import '../widgets/map_buttons.dart';
import '../widgets/map_layers.dart';
import '../widgets/instruction_banner.dart';
import '../widgets/tag_carousel.dart';
import '../widgets/place_detail_sheet.dart';

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

  void _onPlaceTap(Place place) {
    MapAnimator.animatedMove(
      _mapController,
      this,
      LatLng(place.lat, place.lng),
      16.0,
    );
    PlaceDetailSheet.show(context, place);
  }

  @override
  Widget build(BuildContext context) {
    final mapProv = context.watch<MapProvider>();

    return Stack(
      children: [
        // Mapa
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
            MapLayers(
              mapProv: mapProv,
              onPlaceTap: _onPlaceTap,
            ),
          ],
        ),

        // Título + Carrusel
        Positioned(
          top: MediaQuery.of(context).padding.top,
          left: 0,
          right: 0,
          child: Column(
            children: [
              Text(
                mapProv.isCreating ? '' : 'Places',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: mapProv.isCreating ? Colors.green.shade800 : Colors.black87,
                  shadows: const [
                    Shadow(color: Colors.white, blurRadius: 30),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              if (!mapProv.isCreating)
                TagCarousel(
                  selectedCategories: mapProv.activeFilters,
                  onCategoryToggled: (category) {
                    mapProv.toggleFilter(category);
                  },
                ),
            ],
          ),
        ),

        // Banner de instrucciones
        if (mapProv.isCreating)
          InstructionBanner(hasSelection: mapProv.selectedPosition != null),

        // FAB
        Positioned(
          right: 16,
          bottom: 16,
          child: MapButtons(
            mapController: _mapController,
            vsync: this,
          ),
        ),
      ],
    );
  }
}