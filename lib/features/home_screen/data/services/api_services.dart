import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:weather_app/features/home_screen/presentation/export_widgets.dart';

class WeatherService {
  Future<WeatherData> getWeatherDataByLocation(String searchLocation) async {
    const String apiKey = '3278020c74f49a9523cea34dedc80791';
    final String apiUrl =
        'https://api.openweathermap.org/data/2.5/weather?q=$searchLocation&appid=$apiKey';

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      final weatherData = WeatherData.fromJson(responseData);
      return weatherData;
    } else {
      throw Exception('Failed to fetch weather data: ${response.statusCode}');
    }
  }
}
