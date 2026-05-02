import 'package:flutter/material.dart';
import '../models/weather_model.dart';
import '../models/forecast_model.dart';
import '../services/weather_service.dart';
import '../services/location_service.dart';
import '../services/storage_service.dart';

enum WeatherStatus { initial, loading, loaded, error }

class WeatherProvider extends ChangeNotifier {
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
    _errorMessage = '';
    notifyListeners();

    try {
      final position = await _locationService.getCurrentLocation();

      _currentWeather = await _weatherService.getCurrentWeatherByCoordinates(
        position.latitude,
        position.longitude,
      );

      final cityName = _currentWeather!.cityName;
      _forecast = await _weatherService.getForecast(cityName);

      // Lưu vào bộ nhớ máy
      await _storageService.saveWeatherData(_currentWeather!);

      _status = WeatherStatus.loaded;
    } catch (e) {
      debugPrint('Lỗi GPS: $e. Đang chuyển sang chế độ dự phòng thành phố mặc định.');

      try {
        await fetchWeatherByCity('Hanoi');
      } catch (cityError) {
        _status = WeatherStatus.error;
        _errorMessage = 'Không thể lấy vị trí và dữ liệu dự phòng cũng thất bại.';

        final cached = await _storageService.getCachedWeather();
        if (cached != null) {
          _currentWeather = cached;
          _status = WeatherStatus.loaded;
        }
      }
    }
    notifyListeners();
  }

  Future<void> fetchWeatherByCity(String cityName) async {
    if (_status != WeatherStatus.loading) {
      _status = WeatherStatus.loading;
      _errorMessage = '';
      notifyListeners();
    }

    try {
      _currentWeather = await _weatherService.getCurrentWeatherByCity(cityName);
      _forecast = await _weatherService.getForecast(cityName);

      await _storageService.saveWeatherData(_currentWeather!);
      _status = WeatherStatus.loaded;
    } catch (e) {
      debugPrint('Lỗi tìm kiếm: $e');
      _status = WeatherStatus.error;
      _errorMessage = 'Không tìm thấy dữ liệu cho thành phố "$cityName".';
    }
    notifyListeners();
  }
}