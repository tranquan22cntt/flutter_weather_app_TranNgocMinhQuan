import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/weather_model.dart';

class CurrentWeatherCard extends StatelessWidget {
  final WeatherModel weather;

  const CurrentWeatherCard({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          weather.cityName,
          style: const TextStyle(
            fontSize: 35,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 1.2,
          ),
        ),

        Text(
          DateFormat('EEEE, d MMMM').format(weather.dateTime),
          style: const TextStyle(
            fontSize: 18,
            color: Colors.white70,
            fontWeight: FontWeight.w400,
          ),
        ),

        const SizedBox(height: 20),

        Image.network(
          'https://openweathermap.org/img/wn/${weather.icon}@4x.png',
          height: 180,
          width: 180,
          errorBuilder: (context, error, stackTrace) => const Icon(
            Icons.cloud_queue,
            size: 100,
            color: Colors.white,
          ),
        ),

        Text(
          '${weather.temperature.round()}°C',
          style: const TextStyle(
            fontSize: 80,
            fontWeight: FontWeight.w200,
            color: Colors.white,
          ),
        ),

        Text(
          weather.description.toUpperCase(),
          style: const TextStyle(
            fontSize: 20,
            letterSpacing: 2,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}