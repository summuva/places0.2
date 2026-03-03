import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../services/location_service.dart';
import '../utils/map_animator.dart';
import '../models/place_model.dart';
import '../models/tag_model.dart';
class MapProvider extends ChangeNotifier {
  LatLng _currentPosition = const LatLng(-25.2637, -57.5759);
  bool _isLoading = false;
  bool _isCreating = false;
  LatLng? _selectedPosition;
  final List<Place> _places = [];
  final Set<TagCategory> _activeFilters = {};

  // Getters
  LatLng get currentPosition => _currentPosition;
  bool get isLoading => _isLoading;
  bool get isCreating => _isCreating;
  LatLng? get selectedPosition => _selectedPosition;
  List<Place> get places => List.unmodifiable(_places);
  Set<TagCategory> get activeFilters => Set.unmodifiable(_activeFilters);

 List<Place> get filteredPlaces {
    if (_activeFilters.isEmpty) return List.unmodifiable(_places);
    return _places.where((place) {
      return place.tags.any((tag) => _activeFilters.contains(tag.category));
    }).toList();
  }

  void toggleFilter(TagCategory category) {
    if (_activeFilters.contains(category)) {
      _activeFilters.remove(category);
    } else {
      _activeFilters.add(category);
    }
    notifyListeners();
  }
    void clearFilters() {
    _activeFilters.clear();
    notifyListeners();
  }

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
          MapAnimator.animatedMove(mapController, vsync, newPosition, 16.0);
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

  void toggleCreationMode() {
    _isCreating = !_isCreating;
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

  void addPlace(Place place) {
    _places.add(place);
    _selectedPosition = null;
    _isCreating = false;
    notifyListeners();
  }

  void removePlace(String id) {
    _places.removeWhere((p) => p.id == id);
    notifyListeners();
  }
  void cancelAddingPlace() {
    _selectedPosition = null;
    toggleCreationMode();
    notifyListeners();
  
  }

}