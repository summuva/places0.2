import 'package:latlong2/latlong.dart';

class MapConstants {
  static const double defaultZoom = 13.0;
  static const double locationZoom = 16.0;
  static const double markerSize = 40.0;
  static const double minZoom = 3.0;
  static const double maxZoom = 18.0;
  
  static const LatLng defaultPosition = LatLng(-25.2637, -57.5759); // Asunción
  
  static const String tileUrl = 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';
  static const String userAgent = 'com.example.osm_location_app';
}

class AppStrings {
  static const String appTitle = 'OSM + Ubicación';
  static const String locationError = 'Error al obtener la ubicación';
  static const String gpsDisabled = 'GPS Deshabilitado';
  static const String enableGps = 'Por favor habilita el GPS para usar esta función.';
  static const String permissionsDenied = 'Permisos Denegados';
  static const String permissionsPermanentlyDenied = 
      'Los permisos de ubicación han sido denegados permanentemente.';
}