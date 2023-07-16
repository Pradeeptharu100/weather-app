import 'package:weather_app/features/home_screen/presentation/export_widgets.dart';
import 'weather_detail_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final homeProvider = Provider.of<HomeProvider>(context, listen: false);
      homeProvider.fetchDefaultWeatherData();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _searchWeather() {
    final homeProvider = Provider.of<HomeProvider>(context, listen: false);
    String searchLocation = _searchController.text;
    homeProvider.searchWeather(searchLocation);
    if (homeProvider.locationFound) {
      _searchController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppColor.scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: height * 0.02),
              _buildSearchLocationField(),
              Consumer<HomeProvider>(
                builder: (context, homeProvider, _) {
                  if (!homeProvider.locationFound) {
                    return _buildNoLocationImage();
                  } else if (homeProvider.isLoading) {
                    return _buildLoadingIndicator();
                  } else {
                    return _buildWeatherIcon();
                  }
                },
              ),
              SizedBox(height: height * 0.02),
              Center(
                child: Consumer<HomeProvider>(
                  builder: (context, homeProvider, _) {
                    return customText(
                      context: context,
                      text: homeProvider.weatherData.location,
                      fontSize: height * 0.03,
                      letterSpacing: 1.5,
                    );
                  },
                ),
              ),
              SizedBox(height: height * 0.02),
              Center(
                child: Consumer<HomeProvider>(
                  builder: (context, homeProvider, _) {
                    return Column(
                      children: [
                        customText(
                          context: context,
                          text: homeProvider.weatherData.feelLikeCondition,
                          fontSize: height * 0.04,
                          letterSpacing: 1.5,
                        ),
                        SizedBox(height: height * 0.01),
                        customText(
                          context: context,
                          text:
                              '${homeProvider.weatherData.temperature.toStringAsFixed(0)}°C',
                          fontSize: height * 0.07,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1.5,
                        ),
                        SizedBox(height: height * 0.01),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildWeatherConditionIcon(
                              iconPath: ImagePath.windSpeedIcon,
                              text:
                                  '${homeProvider.weatherData.windSpeed.toStringAsFixed(2)} km/h',
                            ),
                            SizedBox(width: width * 0.05),
                            _buildWeatherConditionIcon(
                              iconPath: ImagePath.humidityIcon,
                              text: '${homeProvider.weatherData.humidity}%',
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),
              const Divider(
                thickness: 1,
              ),
              SizedBox(
                height: height * 0.02,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: height * 0.03),
                child: customText(
                    context: context,
                    text: 'Weather Details',
                    fontSize: height * 0.03),
              ),
              SizedBox(
                height: height * 0.01,
              ),
              const WeatherDetailsWidget(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchLocationField() {
    return SearchLocationFieldWidget(
      searchController: _searchController,
      searchWeather: () {
        _searchWeather();
        if (Provider.of<HomeProvider>(context, listen: false).locationFound) {
          _searchController.clear();
        }
      },
    );
  }

  Widget _buildNoLocationImage() {
    return const NoLocationImageWidget();
  }

  Widget _buildWeatherIcon() {
    return const WeatherIcon();
  }

  Widget _buildWeatherConditionIcon(
      {required String iconPath, required String text}) {
    return WeatherConditionIcon(
      iconPath: iconPath,
      text: text,
    );
  }

  Widget _buildLoadingIndicator() {
    return const LoadingIndicator();
  }
}
