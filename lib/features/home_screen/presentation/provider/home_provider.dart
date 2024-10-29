import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

import '../export_widgets.dart';

class HomeProvider extends ChangeNotifier {
  //Controller
  final WeatherService _weatherService = WeatherService();
  final TextEditingController controller = TextEditingController();
  // Variables
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
  bool isEditing = false;
  String? previousSearch;
  bool _isDataSaved = false;
  bool _locationFound = true;
  bool _isLoading = false;
  Timer? _debounceTimer;

  // Getters
  WeatherData get weatherData => _weatherData;
  bool get locationFound => _locationFound;
  bool get isLoading => _isLoading;
  bool get isDataSaved => _isDataSaved;
  final FocusNode _focusNode = FocusNode();
  FocusNode get focusNode => _focusNode;
// Methods

  HomeProvider() {
    fetchDefaultWeatherData();
  }
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
    _debounceTimer?.cancel();
    controller.dispose();
    super.dispose();
  }

  void onSearchChanged(BuildContext context) {
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      if (controller.text.isNotEmpty) {
        final homeProvider = Provider.of<HomeProvider>(context, listen: false);
        homeProvider.searchWeather(controller.text);
      }
    });
  }
}
