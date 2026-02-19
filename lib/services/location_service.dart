import 'package:geolocator/geolocator.dart';

class LocationService {
  static Future<Position?> getCurrentLocation() async {
    try {
      if (!await _checkLocationServices()) return null;
      
      final permission = await _requestLocationPermission();
      if (permission != LocationPermission.whileInUse && 
          permission != LocationPermission.always) return null;

      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      return null;
    }
  }

  static Future<bool> _checkLocationServices() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  static Future<LocationPermission> _requestLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    
    return permission;
  }
}