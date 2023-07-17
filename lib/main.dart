import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/features/home_screen/presentation/provider/home_provider.dart';
import 'package:weather_app/features/splash_screen/presentation/pages/splash_screen.dart';

void main() {
  runApp(const WeatherApp());
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HomeProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Weather App',
        theme: ThemeData(
          appBarTheme: AppBarTheme(
              centerTitle: true,
              // backgroundColor: Color(0xff6ef9e6),
              backgroundColor: Colors.grey.shade200),
          scaffoldBackgroundColor: Colors.white,
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
