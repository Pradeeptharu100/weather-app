import 'dart:convert';
import 'package:http/http.dart' as http;

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

class WeatherData {
  final String location;
  final double temperature;
  final double humidity;
  final double windSpeed;
  final String weatherIcon;
  final String feelLikeCondition;
  final String mainCondition;
  final int sunrise;
  final double tempMin;
  final double tempMax;

  WeatherData({
    required this.location,
    required this.temperature,
    required this.humidity,
    required this.windSpeed,
    required this.weatherIcon,
    required this.feelLikeCondition,
    required this.mainCondition,
    required this.sunrise,
    required this.tempMin,
    required this.tempMax,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    final main = json['main'];
    final wind = json['wind'];
    final name = json['name'];
    final weather = json['weather'][0];
    final sys = json['sys'];

    return WeatherData(
      location: name,
      temperature: (main['temp'] - 273.15).toDouble(),
      humidity: main['humidity'].toDouble(),
      windSpeed: (wind['speed'] * 3.6).toDouble(),
      weatherIcon: weather['icon'],
      feelLikeCondition: weather['description'],
      mainCondition: weather['main'],
      sunrise: sys['sunrise'],
      tempMin: (main['temp_min'] - 273.15).toDouble(),
      tempMax: (main['temp_max'] - 273.15).toDouble(),
    );
  }
}
