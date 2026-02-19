class LocationSettings {
  final bool autoLocationEnabled;
  final bool highAccuracyEnabled;
  final bool showLocationButton;
  final LocationUpdateInterval updateInterval;

  const LocationSettings({
    this.autoLocationEnabled = true,
    this.highAccuracyEnabled = true,
    this.showLocationButton = true,
    this.updateInterval = LocationUpdateInterval.normal,
  });

  LocationSettings copyWith({
    bool? autoLocationEnabled,
    bool? highAccuracyEnabled,
    bool? showLocationButton,
    LocationUpdateInterval? updateInterval,
  }) {
    return LocationSettings(
      autoLocationEnabled: autoLocationEnabled ?? this.autoLocationEnabled,
      highAccuracyEnabled: highAccuracyEnabled ?? this.highAccuracyEnabled,
      showLocationButton: showLocationButton ?? this.showLocationButton,
      updateInterval: updateInterval ?? this.updateInterval,
    );
  }
}

enum LocationUpdateInterval {
  fast(5, 'Rápido (5s)'),
  normal(10, 'Normal (10s)'),
  slow(30, 'Lento (30s)'),
  manual(0, 'Manual');

  const LocationUpdateInterval(this.seconds, this.displayName);
  final int seconds;
  final String displayName;
}