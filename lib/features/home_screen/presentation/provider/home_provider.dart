import '../export_widgets.dart';

class HomeProvider extends ChangeNotifier {
  final WeatherService _weatherService = WeatherService();
  final TextEditingController controller = TextEditingController();
  late WeatherData _weatherData = WeatherData(
    mainCondition: '',
    feelLikeCondition: '',
    location: '',
    temperature: 0.0,
    humidity: 0.0,
    windSpeed: 0.0,
    weatherIcon: '',
    sunrise: 0,
    tempMax: 0,
    tempMin: 0,
  );
  bool _locationFound = true;
  bool _isLoading = false;

  WeatherData get weatherData => _weatherData;
  bool get locationFound => _locationFound;
  bool get isLoading => _isLoading;

  Future<void> fetchDefaultWeatherData() async {
    _isLoading = true;
    notifyListeners();

    try {
      _weatherData =
          await _weatherService.getWeatherDataByLocation('Kathmandu');
      _locationFound = true;
    } catch (e) {
      _locationFound = false;
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> searchWeather(String searchLocation) async {
    _isLoading = true;
    notifyListeners();

    try {
      WeatherData weatherData =
          await _weatherService.getWeatherDataByLocation(searchLocation);
      _weatherData = weatherData;
      _locationFound = true;
    } catch (e) {
      _locationFound = false;
    }

    _isLoading = false;
    notifyListeners();
  }
}
