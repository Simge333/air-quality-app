class AirQuality {
  final int aqi;
  final String level;
  final String description;

  AirQuality({
    required this.aqi,
    required this.level,
    required this.description,
  });

  factory AirQuality.fromJson(Map<String, dynamic> json) {
    return AirQuality(
      aqi: json['aqi'],
      level: json['level'],
      description: json['description'],
    );
  }
}
