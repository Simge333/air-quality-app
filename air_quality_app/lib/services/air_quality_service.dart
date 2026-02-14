import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/air_quality_model.dart';


class CachedAirQuality {
  final AirQuality data;
  final DateTime timestamp;

  CachedAirQuality({
    required this.data,
    required this.timestamp,
  });
}

class AirQualityService {
  static const String baseUrl = 'http://10.0.2.2:8000';

  // ⏱️ Cache süresi (5 dakika)
  static const Duration cacheTTL = Duration(minutes: 5);

  // 🧠 Cache
  static final Map<String, CachedAirQuality> _cache = {};

  static Future<AirQuality> fetchAirQualityByCity(String city) async {
    final normalizedCity = city.toLowerCase().trim();
    final now = DateTime.now();

    // ✅ CACHE VAR MI?
    if (_cache.containsKey(normalizedCity)) {
      final cached = _cache[normalizedCity]!;

      // ⏳ Süresi dolmamış mı?
      if (now.difference(cached.timestamp) < cacheTTL) {
        print('CACHE (TTL) kullanıldı: $normalizedCity');
        return cached.data;
      } else {
        // ❌ Süresi doldu → cache sil
        _cache.remove(normalizedCity);
        print('CACHE süresi doldu: $normalizedCity');
      }
    }

    // 🌍 API çağrısı
    final url = Uri.parse(
      '$baseUrl/air-quality/by-city?city=$normalizedCity',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final decoded =
          jsonDecode(utf8.decode(response.bodyBytes));

      final airQuality = AirQuality.fromJson(decoded);

      // 💾 Cache’e zamanıyla kaydet
      _cache[normalizedCity] = CachedAirQuality(
        data: airQuality,
        timestamp: now,
      );

      print('API çağrıldı: $normalizedCity');
      return airQuality;
    } else {
      throw Exception('Şehir bulunamadı');
    }
  }
  static Future<AirQuality> fetchAirQualityByLocation(
    double lat, double lon) async {

  final url = Uri.parse(
    '$baseUrl/air-quality?lat=$lat&lon=$lon',
  );

  final response = await http.get(url);

  if (response.statusCode == 200) {
    final decoded =
        jsonDecode(utf8.decode(response.bodyBytes));
    return AirQuality.fromJson(decoded);
  } else {
    throw Exception('Konuma göre hava alınamadı');
  }
}

}
