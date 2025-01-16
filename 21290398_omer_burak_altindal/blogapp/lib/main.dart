import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'pages/login_page.dart';
import 'pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Oturum kontrolü
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  MyApp({required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Debug etiketi kaldırıldı
      theme: ThemeData.light(), // Light mode için tema
      darkTheme: ThemeData.dark(), // Dark mode için tema
      themeMode: ThemeMode.system, // Sistemin light/dark moduna göre otomatik
      home: isLoggedIn
          ? HomePage() // Oturum açılmışsa ana sayfaya yönlendir
          : LoginPage(), // Oturum açılmamışsa giriş sayfasına yönlendir
    );
  }
}
