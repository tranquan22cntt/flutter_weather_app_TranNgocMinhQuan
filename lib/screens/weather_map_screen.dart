import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:ui_web' as ui;
import 'dart:html' as html;

class WeatherMapScreen extends StatefulWidget {
  const WeatherMapScreen({super.key});

  @override
  State<WeatherMapScreen> createState() => _WeatherMapScreenState();
}

class _WeatherMapScreenState extends State<WeatherMapScreen> {
  late WebViewController _controller;
  String _currentLayer = 'clouds';
  final Map<String, String> _layers = {
    'clouds': 'Mây che phủ',
    'precipitation_new': 'Lượng mưa',
    'wind_new': 'Tốc độ gió',
    'temp_new': 'Nhiệt độ',
  };

  String get _mapUrl =>
      'https://openweathermap.org/weathermap?basemap=map&cities=false&layer=$_currentLayer&lat=10.7626&lon=106.6602&zoom=6';

  final String _viewId = 'weather-map-view';

  @override
  void initState() {
    super.initState();
    _initMap();
  }

  void _initMap() {
    if (kIsWeb) {
      ui.platformViewRegistry.registerViewFactory(
        _viewId,
            (int viewId) => html.IFrameElement()
          ..src = _mapUrl
          ..style.border = 'none'
          ..style.width = '100%'
          ..style.height = '100%'
          ..style.borderRadius = '20px',
      );
    } else {
      _controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(const Color(0x00000000))
        ..loadRequest(Uri.parse(_mapUrl));
    }
  }

  void _changeLayer(String layer) {
    setState(() {
      _currentLayer = layer;
    });
    if (kIsWeb) {
      _initMap();
    } else {
      _controller.loadRequest(Uri.parse(_mapUrl));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A202C),
      appBar: AppBar(
        title: const Text(
          "BẢN ĐỒ THỜI TIẾT",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF2D3748),
        foregroundColor: Colors.white,
        elevation: 4,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _layers.entries.map((entry) {
                  final isSelected = _currentLayer == entry.key;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0, bottom: 15),
                    child: ChoiceChip(
                      label: Text(entry.value),
                      selected: isSelected,
                      onSelected: (_) => _changeLayer(entry.key),
                      selectedColor: const Color(0xFFFDB813),
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.black : Colors.white70,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                      backgroundColor: const Color(0xFF2D3748),
                    ),
                  );
                }).toList(),
              ),
            ),
            Expanded(
              child: Container(
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white10, width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: kIsWeb
                    ? HtmlElementView(viewType: _viewId, key: ValueKey(_currentLayer))
                    : WebViewWidget(controller: _controller),
              ),
            ),
            const SizedBox(height: 15),
            const Text(
              "Dữ liệu bản đồ vệ tinh thời gian thực từ OpenWeather",
              style: TextStyle(color: Colors.white54, fontSize: 11, fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }
}