import '../export_widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeProvider extends ChangeNotifier {
  final WeatherService _weatherService = WeatherService();
  final TextEditingController controller = TextEditingController();
  late WeatherData _weatherData = WeatherData(
    country: '',
    mainCondition: '',
    feelsLikeTemperature: 0,
    location: '',
    temperature: 0.0,
    humidity: 0.0,
    windSpeed: 0.0,
    weatherIcon: '',
    sunrise: 0,
    tempMax: 0,
    tempMin: 0,
    weatherCondition: '',
  );
  bool _locationFound = true;
  bool _isLoading = false;
  WeatherData get weatherData => _weatherData;
  bool get locationFound => _locationFound;
  bool get isLoading => _isLoading;
  bool isEditing = false;
  String? previousSearch;
  bool _isDataSaved = false;
  bool get isDataSaved => _isDataSaved;
  final FocusNode _focusNode = FocusNode();
  FocusNode get focusNode => _focusNode;

  void updateDataSavedStatus(bool newValue) {
    _isDataSaved = newValue;
    notifyListeners();
  }

  void updateEditingState(bool editing) {
    isEditing = editing;
    notifyListeners();
  }

  Future<void> fetchDefaultWeatherData() async {
    _isLoading = true;
    notifyListeners();

    try {
      previousSearch = await _getPreviousSearch();
      if (previousSearch != null && previousSearch!.isNotEmpty) {
        _weatherData =
            await _weatherService.getWeatherDataByLocation(previousSearch!);
        _locationFound = true;
      } else {
        _weatherData =
            await _weatherService.getWeatherDataByLocation('Kathmandu');
        _locationFound = true;
      }
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
      await _savePreviousSearch(searchLocation);
    } catch (e) {
      _locationFound = false;
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> _savePreviousSearch(String searchValue) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('previousSearch', searchValue);
  }

  Future<String?> _getPreviousSearch() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('previousSearch');
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
