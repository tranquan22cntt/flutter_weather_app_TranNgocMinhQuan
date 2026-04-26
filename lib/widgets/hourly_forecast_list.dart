import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/forecast_model.dart';

class HourlyForecastList extends StatelessWidget {
  final List<ForecastModel> forecasts;

  const HourlyForecastList({super.key, required this.forecasts});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Text(
            "Dự báo 24 giờ tới",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ),
        SizedBox(
          height: 140,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            itemCount: forecasts.length > 8 ? 8 : forecasts.length,
            itemBuilder: (context, index) {
              final item = forecasts[index];
              return Container(
                width: 90,
                margin: const EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white10),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      DateFormat('HH:mm').format(item.dateTime),
                      style: const TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                    CachedNetworkImage(
                      imageUrl: 'https://openweathermap.org/img/wn/${item.icon}.png',
                      height: 50,
                      placeholder: (context, url) => const SizedBox(height: 50),
                    ),
                    Text(
                      '${item.temperature.round()}°',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}