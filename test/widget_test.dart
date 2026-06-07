import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:car_service_app/main.dart';
import 'package:car_service_app/controllers/provider.dart';

void main() {
  testWidgets('App launches and shows login screen',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [ChangeNotifierProvider(create: (_) => AppProvider())],
        child: const CarServiceApp(),
      ),
    );
    expect(find.text('Car Service App'), findsOneWidget);
    expect(find.text('Login'), findsOneWidget);
  });
}