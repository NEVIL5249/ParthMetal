import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/otp_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/price_chart_screen.dart';
import 'screens/about_us_screen.dart';

void main() {
  runApp(const ParthMetalApp());
}

class ParthMetalApp extends StatelessWidget {
  const ParthMetalApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Parth Metal Catalog',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/otp': (context) => const OtpScreen(),
        '/dashboard': (context) => const DashboardScreen(),
        '/price_chart': (context) => const PriceChartScreen(),
        '/about': (context) => const AboutUsScreen(),
      },
    );
  }
}
