import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Weather {
  final double temperature;
  final double latitude;
  final double longitude;

  Weather({
    required this.temperature,
    required this.latitude,
    required this.longitude,
  });
}

class WeatherService {
  final String apiKey = '3278020c74f49a9523cea34dedc80791';
  final String baseUrl = 'https://api.openweathermap.org/data/2.5/weather';
  final String geocodingBaseUrl =
      'https://api.openweathermap.org/geo/1.0/direct';

  Future<Weather> fetchWeatherByCoordinates(
      double latitude, double longitude) async {
    final url = '$baseUrl?lat=$latitude&lon=$longitude&appid=$apiKey';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final temperature = jsonData['main']['temp'].toDouble();
      return Weather(
          temperature: temperature, latitude: latitude, longitude: longitude);
    } else {
      throw Exception('Failed to fetch weather data');
    }
  }

  Future<List<String>> searchLocation(String query) async {
    final url = '$geocodingBaseUrl?q=$query&limit=5&appid=$apiKey';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body) as List<dynamic>;
      final List<String> locations =
          jsonData.map((location) => location['name'] as String).toList();
      return locations;
    } else {
      throw Exception('Failed to fetch search results');
    }
  }

  Future<Weather> fetchWeatherByLocation(String location) async {
    final url = '$baseUrl?q=$location&appid=$apiKey';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final temperature = jsonData['main']['temp'].toDouble();
      final latitude = jsonData['coord']['lat'].toDouble();
      final longitude = jsonData['coord']['lon'].toDouble();
      return Weather(
          temperature: temperature, latitude: latitude, longitude: longitude);
    } else {
      throw Exception('Failed to fetch weather data');
    }
  }
}

class WeatherApp extends StatefulWidget {
  @override
  _WeatherAppState createState() => _WeatherAppState();
}

class _WeatherAppState extends State<WeatherApp> {
  final WeatherService _weatherService = WeatherService();
  double _latitude = 44.34;
  double _longitude = 10.99;
  Weather? _weather;
  String _searchLocation = '';
  List<String> _searchResults = [];
  String _selectedLocation = '';

  @override
  void initState() {
    super.initState();
    _fetchWeatherData();
  }

  void _fetchWeatherData() async {
    try {
      Weather weather;
      if (_selectedLocation.isNotEmpty) {
        weather =
            await _weatherService.fetchWeatherByLocation(_selectedLocation);
      } else {
        weather = await _weatherService.fetchWeatherByCoordinates(
            _latitude, _longitude);
      }
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      print(e);
    }
  }

  void _searchWeatherByLocation() async {
    try {
      final weather =
          await _weatherService.fetchWeatherByLocation(_searchLocation);
      setState(() {
        _weather = weather;
        _selectedLocation = _searchLocation;
        _searchResults.clear();
        _searchLocation = '';
      });
    } catch (e) {
      print(e);
    }
  }

  void _fetchSearchResults() async {
    try {
      final searchResults =
          await _weatherService.searchLocation(_searchLocation);
      setState(() {
        _searchResults = searchResults;
      });
    } catch (e) {
      print(e);
    }
  }

  String getFormattedTemperature() {
    if (_weather != null) {
      final temperatureC = _weather!.temperature - 273.15;
      return '${temperatureC.toStringAsFixed(1)}°C ';
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather App'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_weather != null)
              Text(
                'Temperature: ${getFormattedTemperature()}',
                style: TextStyle(fontSize: 24),
              ),
            if (_weather != null)
              Text(
                'Latitude: ${_weather!.latitude.toString()}',
                style: TextStyle(fontSize: 18),
              ),
            if (_weather != null)
              Text(
                'Longitude: ${_weather!.longitude.toString()}',
                style: TextStyle(fontSize: 18),
              ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    _searchLocation = value;
                  });
                  _fetchSearchResults();
                },
                decoration: InputDecoration(
                  hintText: 'Enter location',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.search),
                    onPressed: _searchWeatherByLocation,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            if (_searchResults.isNotEmpty)
              Column(
                children: _searchResults
                    .map((result) => ListTile(
                          title: Text(result),
                          onTap: () {
                            setState(() {
                              _selectedLocation = result;
                              _searchLocation = result;
                              _searchResults.clear();
                            });
                            _searchWeatherByLocation();
                          },
                        ))
                    .toList(),
              ),
            if (_selectedLocation.isNotEmpty)
              Text(
                'Selected Location: $_selectedLocation',
                style: TextStyle(fontSize: 18),
              ),
          ],
        ),
      ),
    );
  }
}
