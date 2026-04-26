import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/weather_model.dart';

class StorageService {
  static const String _weatherKey = 'cached_weather_lab4';
  static const String _lastUpdateKey = 'last_weather_update_lab4';

  Future<void> saveWeatherData(WeatherModel weather) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_weatherKey, json.encode(weather.toJson()));
      await prefs.setInt(_lastUpdateKey, DateTime.now().millisecondsSinceEpoch);
    } catch (e) {
      print('Lỗi khi lưu cache: $e');
    }
  }

  Future<WeatherModel?> getCachedWeather() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? weatherJson = prefs.getString(_weatherKey);

      if (weatherJson != null) {
        return WeatherModel.fromJson(json.decode(weatherJson));
      }
    } catch (e) {
      print('Lỗi khi đọc cache: $e');
    }
    return null;
  }

  Future<bool> isCacheValid() async {
    final prefs = await SharedPreferences.getInstance();
    final int? lastUpdate = prefs.getInt(_lastUpdateKey);

    if (lastUpdate == null) return false;

    final int now = DateTime.now().millisecondsSinceEpoch;
    return (now - lastUpdate) < (30 * 60 * 1000);
  }

  Future<void> clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_weatherKey);
    await prefs.remove(_lastUpdateKey);
  }
}