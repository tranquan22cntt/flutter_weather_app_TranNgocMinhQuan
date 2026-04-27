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
          body: provider.status == WeatherStatus.loading
              ? const Center(child: CircularProgressIndicator(color: Colors.white))
              : SafeArea(
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
          ),
          // Các nút chức năng
          floatingActionButton: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // Nút xem Bản đồ (Bonus 15%)
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
}