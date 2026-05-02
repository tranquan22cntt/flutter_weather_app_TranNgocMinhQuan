import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController cityController = TextEditingController();

    return Scaffold(
      backgroundColor: const Color(0xFF1a1a1a),
      appBar: AppBar(
        title: const Text(
          "Tìm kiếm thành phố",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            TextField(
              controller: cityController,
              style: const TextStyle(color: Colors.white),
              autofocus: true,
              decoration: InputDecoration(
                hintText: "Nhập tên thành phố (vd: Hanoi, London...)",
                hintStyle: const TextStyle(color: Colors.white38),
                filled: true,
                fillColor: Colors.white10,
                prefixIcon: const Icon(Icons.location_city, color: Colors.white70),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search, color: Colors.blueAccent),
                  onPressed: () {
                    final cityName = cityController.text.trim();
                    if (cityName.isNotEmpty) {
                      context.read<WeatherProvider>().fetchWeatherByCity(cityName);
                      Navigator.pop(context);
                    }
                  },
                ),
              ),
              onSubmitted: (value) {
                final cityName = value.trim();
                if (cityName.isNotEmpty) {
                  context.read<WeatherProvider>().fetchWeatherByCity(cityName);
                  Navigator.pop(context);
                }
              },
            ),
            const SizedBox(height: 30),
            const Text(
              "Có thể nhập tên thành phố không dấu hoặc có dấu.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white54, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}