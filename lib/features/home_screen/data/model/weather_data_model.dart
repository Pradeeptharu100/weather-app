import 'package:weather_app/features/home_screen/data/model/country_name_model.dart';

class WeatherData {
  final String location;
  final double temperature;
  final double humidity;
  final double windSpeed;
  final String weatherIcon;
  final String weatherCondition;
  final String mainCondition;
  final int sunrise;
  final double tempMin;
  final double tempMax;
  final double feelsLikeTemperature;
  final String country;

  WeatherData({
    required this.location,
    required this.temperature,
    required this.humidity,
    required this.windSpeed,
    required this.weatherIcon,
    required this.feelsLikeTemperature,
    required this.mainCondition,
    required this.sunrise,
    required this.tempMin,
    required this.tempMax,
    required this.weatherCondition,
    required this.country,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    final main = json['main'];
    final wind = json['wind'];
    final name = json['name'];
    final weather = json['weather'][0];
    final sys = json['sys'];

    final countryCode = sys['country'];
    final country = _getCountryFullName(countryCode);

    return WeatherData(
      location: name,
      temperature: (main['temp'] - 273.15).toDouble(),
      humidity: main['humidity'].toDouble(),
      windSpeed: (wind['speed'] * 3.6).toDouble(),
      weatherIcon: weather['icon'],
      feelsLikeTemperature: (main['feels_like'] - 273.15).toDouble(),
      weatherCondition: weather['description'],
      mainCondition: weather['main'],
      sunrise: sys['sunrise'],
      tempMin: (main['temp_min'] - 273.15).toDouble(),
      tempMax: (main['temp_max'] - 273.15).toDouble(),
      country: country,
    );
  }

  static String _getCountryFullName(String countryCode) {
    const countryMap = countryCodeMap;

    return countryMap[countryCode] ?? countryCode;
  }
}
