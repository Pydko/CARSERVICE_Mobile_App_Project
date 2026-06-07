import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'controllers/provider.dart';
import 'data/database.dart';
import 'ui/screens/loginScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // DB'yi UI açılmadan önce başlat — tablo oluşturma + admin seed burada biter
  await DatabaseHelper.instance.database;

  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => AppProvider())],
      child: const CarServiceApp(),
    ),
  );
}

class CarServiceApp extends StatelessWidget {
  const CarServiceApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Car Service App',
      themeMode: ThemeMode.light, // Uygulamayı karanlık moddan bağımsız ışık moduna sabitler
      theme: ThemeData(
        brightness: Brightness.light, // Yazıların varsayılan rengini siyah yapar
        scaffoldBackgroundColor: Colors.grey[200],
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
        ),
        cardColor: Colors.white,
        inputDecorationTheme: const InputDecorationTheme(
          labelStyle: TextStyle(color: Colors.black54), // TextField etiketleri
          floatingLabelStyle: TextStyle(color: Colors.black), // Tıklanınca yukarı çıkan etiket
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
      home: const LoginScreen(),
    );
  }
}

class SmoothPageRoute extends PageRouteBuilder {
  final Widget page;
  SmoothPageRoute({required this.page})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        );
}