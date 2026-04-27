import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:flutter_weather_app_tran_ngoc_minh_quan/main.dart';
import 'package:flutter_weather_app_tran_ngoc_minh_quan/providers/weather_provider.dart';

void main() {
  group('Kiểm tra Giao diện Weather App (Comprehensive)', () {

    setUpAll(() async {
      dotenv.testLoad(fileInput: 'OPENWEATHER_API_KEY=test_key_123');
    });

    testWidgets('1. Kiểm tra cấu trúc khởi tạo và nút tìm kiếm', (WidgetTester tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (_) => WeatherProvider(),
          child: const MyApp(),
        ),
      );

      expect(find.byType(MaterialApp), findsOneWidget);

      expect(find.byType(FloatingActionButton), findsOneWidget);
      expect(find.byIcon(Icons.search_rounded), findsOneWidget);
    });

    testWidgets('2. Kiểm tra hiển thị trạng thái chờ (Loading)', (WidgetTester tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (_) => WeatherProvider(),
          child: const MyApp(),
        ),
      );

      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('3. Kiểm tra điều hướng sang màn hình tìm kiếm', (WidgetTester tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (_) => WeatherProvider(),
          child: const MyApp(),
        ),
      );

      await tester.pumpAndSettle();

      final searchButton = find.byType(FloatingActionButton);
      if (searchButton.evaluate().isNotEmpty) {
        await tester.tap(searchButton);
        await tester.pumpAndSettle();
        expect(find.textContaining('Nhập tên thành phố'), findsOneWidget);
      }
    });
  });
}