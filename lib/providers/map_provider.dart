import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../services/location_service.dart';
import '../utils/map_animator.dart';

class MapProvider extends ChangeNotifier {
  final MapController mapController = MapController();
  
  LatLng _currentPosition = const LatLng(-25.2637, -57.5759); // Default Asunción
  bool _isLoading = false;
  
  // New state for creating places
  bool _isCreating = false;
  LatLng? _selectedPosition;

  // Getters
  LatLng get currentPosition => _currentPosition;
  bool get isLoading => _isLoading;
  bool get isCreating => _isCreating;
  LatLng? get selectedPosition => _selectedPosition;

  // ... existing getUserLocation code ...
  Future<void> getUserLocation({
    required MapController mapController,
    required TickerProvider vsync,
    bool animate = true,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final position = await LocationService.getCurrentLocation();
      if (position != null) {
        final newPosition = LatLng(position.latitude, position.longitude);
        _currentPosition = newPosition;
        
        if (animate) {
          MapAnimator.animatedMove(
            mapController,
            vsync,
            newPosition,
            16.0,
          );
        } else {
          mapController.move(newPosition, 16.0);
        }
      }
    } catch (e) {
      debugPrint('Error obtaining location: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // New Methods
  void toggleCreationMode() {
    _isCreating = !_isCreating;
    // If turning off, clear the selected position
    if (!_isCreating) {
      _selectedPosition = null;
    }
    notifyListeners();
  }

  void selectPosition(LatLng position) {
    if (_isCreating) {
      _selectedPosition = position;
      notifyListeners();
    }
  }
}