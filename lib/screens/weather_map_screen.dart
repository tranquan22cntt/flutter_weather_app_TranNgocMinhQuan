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
  late final WebViewController _controller;
  final String _mapUrl = 'https://openweathermap.org/weathermap?basemap=map&cities=false&layer=clouds&lat=10.7626&lon=106.6602&zoom=6';
  final String _viewId = 'weather-map-view';

  @override
  void initState() {
    super.initState();

    if (kIsWeb) {
      ui.platformViewRegistry.registerViewFactory(
        _viewId,
            (int viewId) => html.IFrameElement()
          ..src = _mapUrl
          ..style.border = 'none'
          ..style.width = '100%'
          ..style.height = '100%',
      );
    } else {
      _controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(const Color(0x00000000))
        ..loadRequest(Uri.parse(_mapUrl));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
            "Bản đồ thời tiết",
            style: TextStyle(fontWeight: FontWeight.bold)
        ),
        backgroundColor: const Color(0xFF2D3748),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: kIsWeb
          ? HtmlElementView(viewType: _viewId)
          : WebViewWidget(controller: _controller),
    );
  }
}