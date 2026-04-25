import 'package:flutter/material.dart';

class ApiConfig {
  static const String baseUrl = 'https://api.openweathermap.org/data/2.5';
  static String get apiKey => dotenv.get('OPENWEATHER_API_KEY', fallback: '');
  static const String currentWeather = '/weather';
  static const String forecast = '/forecast';
  static String buildUrl(String endpoint, Map<String, dynamic> params) {
    final uri = Uri.parse('$baseUrl$endpoint');
    final queryParams = Map<String, dynamic>.from(params);
    queryParams['appid'] = apiKey;
    queryParams['units'] = 'metric';
    queryParams['lang'] = 'vi';
    return uri.replace(queryParameters: queryParams).toString();
  }
}