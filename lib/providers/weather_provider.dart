import 'package:flutter/material.dart';
import '../models/weather_model.dart';
import '../models/forecast_model.dart';
import '../services/weather_service.dart';
import '../services/location_service.dart';
import '../services/storage_service.dart';

enum WeatherStatus { initial, loading, loaded, error }

class WeatherProvider extends ChangeNotifier {
  // Khai báo các đối tượng dịch vụ (instance)
  final WeatherService _weatherService = WeatherService();
  final LocationService _locationService = LocationService();
  final StorageService _storageService = StorageService();

  WeatherModel? _currentWeather;
  List<ForecastModel> _forecast = [];
  WeatherStatus _status = WeatherStatus.initial;
  String _errorMessage = '';

  WeatherModel? get currentWeather => _currentWeather;
  List<ForecastModel> get forecast => _forecast;

  WeatherStatus get status => _status;
  String get errorMessage => _errorMessage;

  Future<void> fetchWeatherByLocation() async {
    _status = WeatherStatus.loading;
    notifyListeners();

    try {
      final position = await _locationService.getCurrentLocation();

      _currentWeather = await _weatherService.getCurrentWeatherByCoordinates(
        position.latitude,
        position.longitude,
      );

      final cityName = await _locationService.getCityName(
        position.latitude,
        position.longitude,
      );

      _forecast = await _weatherService.getForecast(cityName);

      await _storageService.saveWeatherData(_currentWeather!);

      _status = WeatherStatus.loaded;
    } catch (e) {
      _status = WeatherStatus.error;
      _errorMessage = e.toString();

      final cached = await _storageService.getCachedWeather();
      if (cached != null) {
        _currentWeather = cached;
        _status = WeatherStatus.loaded;
      }
    }
    notifyListeners();
  }

  Future<void> fetchWeatherByCity(String cityName) async {
    _status = WeatherStatus.loading;
    notifyListeners();

    try {
      _currentWeather = await _weatherService.getCurrentWeatherByCity(cityName);
      _forecast = await _weatherService.getForecast(cityName);

      await _storageService.saveWeatherData(_currentWeather!);
      _status = WeatherStatus.loaded;
    } catch (e) {
      _status = WeatherStatus.error;
      _errorMessage = 'Không tìm thấy thành phố này.';
    }
    notifyListeners();
  }
}