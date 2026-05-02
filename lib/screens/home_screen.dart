import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';
import '../widgets/current_weather_card.dart';
import '../widgets/weather_detail_item.dart';
import '../widgets/hourly_forecast_list.dart';
import 'search_screen.dart';
import 'weather_map_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WeatherProvider>().fetchWeatherByLocation();
    });
  }

  Color _getBackgroundColor(String? condition) {
    if (condition == null) return const Color(0xFF1A202C);
    switch (condition.toLowerCase()) {
      case 'clear': return const Color(0xFF87CEEB);
      case 'rain':
      case 'drizzle': return const Color(0xFF718096);
      case 'clouds': return const Color(0xFFCBD5E0);
      default: return const Color(0xFF1A202C);
    }
  }

  Color _getPrimaryColor(String? condition) {
    if (condition == null) return const Color(0xFF2D3748);
    switch (condition.toLowerCase()) {
      case 'clear': return const Color(0xFFFDB813);
      case 'rain': return const Color(0xFF4A5568);
      case 'clouds': return const Color(0xFFA0AEC0);
      default: return const Color(0xFF2D3748);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WeatherProvider>(
      builder: (context, provider, child) {
        final weather = provider.currentWeather;
        final bgColor = _getBackgroundColor(weather?.mainCondition);
        final primaryColor = _getPrimaryColor(weather?.mainCondition);

        return Scaffold(
          backgroundColor: bgColor,
          body: _buildBody(provider, weather, primaryColor),
          floatingActionButton: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FloatingActionButton(
                heroTag: 'map',
                mini: true,
                backgroundColor: Colors.white,
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const WeatherMapScreen())),
                child: const Icon(Icons.map_rounded, color: Colors.green),
              ),
              const SizedBox(height: 12),
              FloatingActionButton(
                heroTag: 'search',
                backgroundColor: Colors.white,
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SearchScreen())),
                child: const Icon(Icons.search_rounded, color: Colors.blueAccent),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBody(WeatherProvider provider, dynamic weather, Color primaryColor) {
    if (provider.status == WeatherStatus.loading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Colors.white),
            SizedBox(height: 20),
            Text("Đang cập nhật thời tiết...", style: TextStyle(color: Colors.white70)),
          ],
        ),
      );
    }

    if (provider.status == WeatherStatus.error && weather == null) {
      String cleanError = provider.errorMessage.replaceAll('Exception:', '').replaceAll('Lỗi:', '').trim();
      if (cleanError.isEmpty) cleanError = "Không thể kết nối với máy chủ thời tiết.";

      return Center(
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.cloud_off_rounded, size: 100, color: Colors.white24),
              const SizedBox(height: 20),
              Text(
                cleanError,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w300),
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: () => provider.fetchWeatherByLocation(),
                icon: const Icon(Icons.refresh),
                label: const Text("THỬ LẠI"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white24,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
              ),
              const SizedBox(height: 15),
              TextButton(
                onPressed: () => provider.fetchWeatherByCity("Hanoi"),
                // SỬA LỖI: Đổi Colors.blueSky thành Colors.blue
                child: const Text("Xem thời tiết Hà Nội (Mẫu)", style: TextStyle(color: Colors.blue)),
              ),
            ],
          ),
        ),
      );
    }

    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () => provider.fetchWeatherByLocation(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              if (weather != null) ...[
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  color: primaryColor.withOpacity(0.9),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: CurrentWeatherCard(weather: weather),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      WeatherDetailItem(icon: Icons.water_drop, value: '${weather.humidity}%', label: 'Độ ẩm'),
                      WeatherDetailItem(icon: Icons.air, value: '${weather.windSpeed}m/s', label: 'Gió'),
                      WeatherDetailItem(icon: Icons.thermostat, value: '${weather.feelsLike.round()}°', label: 'Cảm giác'),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                HourlyForecastList(forecasts: provider.forecast),
              ]
            ],
          ),
        ),
      ),
    );
  }
}