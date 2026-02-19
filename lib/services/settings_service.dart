import 'package:shared_preferences/shared_preferences.dart';
import '../models/settings_model.dart';

class SettingsService {
  static const String _autoLocationKey = 'auto_location';
  static const String _highAccuracyKey = 'high_accuracy';
  static const String _showLocationButtonKey = 'show_location_button';
  static const String _updateIntervalKey = 'update_interval';

  static Future<LocationSettings> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    
    return LocationSettings(
      autoLocationEnabled: prefs.getBool(_autoLocationKey) ?? true,
      highAccuracyEnabled: prefs.getBool(_highAccuracyKey) ?? true,
      showLocationButton: prefs.getBool(_showLocationButtonKey) ?? true,
      updateInterval: LocationUpdateInterval.values[
        prefs.getInt(_updateIntervalKey) ?? LocationUpdateInterval.normal.index
      ],
    );
  }

  static Future<void> saveSettings(LocationSettings settings) async {
    final prefs = await SharedPreferences.getInstance();
    
    await Future.wait([
      prefs.setBool(_autoLocationKey, settings.autoLocationEnabled),
      prefs.setBool(_highAccuracyKey, settings.highAccuracyEnabled),
      prefs.setBool(_showLocationButtonKey, settings.showLocationButton),
      prefs.setInt(_updateIntervalKey, settings.updateInterval.index),
    ]);
  }
}