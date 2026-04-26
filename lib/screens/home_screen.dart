import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';
import '../widgets/current_weather_card.dart';
import '../widgets/weather_detail_item.dart';
import '../widgets/hourly_forecast_list.dart';
import 'search_screen.dart';

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

  LinearGradient _getWeatherGradient(String? condition) {
    if (condition == null) return const LinearGradient(colors: [Color(0xFF2c3e50), Color(0xFF000000)]);

    switch (condition.toLowerCase()) {
      case 'clear':
        return const LinearGradient(
          colors: [Color(0xFF4facfe), Color(0xFF00f2fe)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'clouds':
        return const LinearGradient(
          colors: [Color(0xFF757F9A), Color(0xFFD7DDE8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'rain':
      case 'drizzle':
        return const LinearGradient(
          colors: [Color(0xFF203a43), Color(0xFF2c5364)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'thunderstorm':
        return const LinearGradient(
          colors: [Color(0xFF0f0c29), Color(0xFF302b63), Color(0xFF24243e)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      default:
        return const LinearGradient(
          colors: [Color(0xFF3E5151), Color(0xFFDECBA4)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<WeatherProvider>(
        builder: (context, provider, child) {
          if (provider.status == WeatherStatus.loading) {
            return Container(
              width: double.infinity,
              height: double.infinity,
              color: const Color(0xFF1a1a1a),
              child: const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            );
          }

          // Trạng thái có lỗi xảy ra
          if (provider.status == WeatherStatus.error) {
            return Container(
              width: double.infinity,
              height: double.infinity,
              color: const Color(0xFF1a1a1a),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, color: Colors.redAccent, size: 60),
                    const SizedBox(height: 16),
                    Text(
                      provider.errorMessage,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () => provider.fetchWeatherByLocation(),
                      child: const Text("Thử lại"),
                    ),
                  ],
                ),
              ),
            );
          }

          final weather = provider.currentWeather;
          if (weather == null) {
            return const Center(child: Text("Không có dữ liệu thời tiết"));
          }

          return Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: _getWeatherGradient(weather.mainCondition),
            ),
            child: SafeArea(
              child: RefreshIndicator(
                onRefresh: () => provider.fetchWeatherByLocation(),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      const SizedBox(height: 40),
                      CurrentWeatherCard(weather: weather),

                      const SizedBox(height: 40),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Container(
                          padding: const EdgeInsets.all(25),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(color: Colors.white24),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              WeatherDetailItem(
                                icon: Icons.water_drop_outlined,
                                value: '${weather.humidity}%',
                                label: 'Độ ẩm',
                              ),
                              WeatherDetailItem(
                                icon: Icons.air_rounded,
                                value: '${weather.windSpeed}m/s',
                                label: 'Gió',
                              ),
                              WeatherDetailItem(
                                icon: Icons.thermostat_outlined,
                                value: '${weather.feelsLike.round()}°',
                                label: 'Cảm giác',
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),
                      HourlyForecastList(forecasts: provider.forecast),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 8,
        backgroundColor: Colors.white,
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const SearchScreen()),
        ),
        child: const Icon(Icons.search_rounded, color: Colors.blueAccent, size: 30),
      ),
    );
  }
}