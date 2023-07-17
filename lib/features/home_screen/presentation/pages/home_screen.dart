import 'package:weather_app/features/home_screen/presentation/export_widgets.dart';
import 'package:weather_app/features/home_screen/presentation/widgets/weather_detail_widget.dart';
import 'package:weather_app/features/splash_screen/presentation/pages/splash_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static const routeName = '/homeSceen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final homeProvider = Provider.of<HomeProvider>(context, listen: false);
      await homeProvider.fetchDefaultWeatherData();
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
    final homeProvider = Provider.of<HomeProvider>(context);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: customText(context: context, text: 'Weather App'),
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
            size: height * 0.04,
          ),
          onPressed: () {
            if (homeProvider.locationFound) {
              Navigator.pushNamed(context, SplashScreen.routeName);
            } else {
              homeProvider.fetchDefaultWeatherData();
            }
          },
        ),
        automaticallyImplyLeading: true,
      ),
      backgroundColor: Colors.grey.shade200,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white.withOpacity(0.25),
              Colors.greenAccent.withOpacity(0.50),
              Colors.white.withOpacity(0.25),
            ],
          ),
        ),
        child: RefreshIndicator(
          onRefresh: () async {
            await homeProvider.fetchDefaultWeatherData();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: height * 0.02),
                _buildSearchLocationField(homeProvider),
                if (homeProvider.isLoading)
                  SizedBox(
                    height: height * 0.1,
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: Colors.red,
                      ),
                    ),
                  )
                else if (!homeProvider.locationFound)
                  Center(child: _buildNoLocationImage())
                else
                  Visibility(
                    visible: homeProvider.locationFound,
                    child: Column(
                      children: [
                        const WeatherIcon(),
                        SizedBox(height: height * 0.02),
                        Center(
                          child: customText(
                            context: context,
                            text: homeProvider.weatherData.location,
                            fontSize: height * 0.04,
                            letterSpacing: 1.5,
                            color: Colors.green,
                          ),
                        ),
                        SizedBox(
                          height: height * 0.01,
                        ),
                        Center(
                          child: customText(
                            context: context,
                            text: homeProvider.weatherData.country,
                            fontSize: height * 0.04,
                            letterSpacing: 1.5,
                            color: Colors.green,
                          ),
                        ),
                        SizedBox(height: height * 0.02),
                        Center(
                          child: Column(
                            children: [
                              customText(
                                context: context,
                                text: homeProvider.weatherData.weatherCondition,
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
                                    context: context,
                                    iconPath: ImagePath.windSpeedIcon,
                                    text:
                                        '${homeProvider.weatherData.windSpeed.toStringAsFixed(2)} km/h',
                                  ),
                                  SizedBox(width: width * 0.05),
                                  _buildWeatherConditionIcon(
                                    context: context,
                                    iconPath: ImagePath.humidityIcon,
                                    text:
                                        '${homeProvider.weatherData.humidity}%',
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                if (homeProvider.locationFound)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Divider(
                        thickness: 2,
                      ),
                      SizedBox(
                        height: height * 0.02,
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: height * 0.03),
                        child: customText(
                          context: context,
                          text: 'Weather Details',
                          color: Colors.red,
                          fontSize: height * 0.03,
                        ),
                      ),
                      SizedBox(
                        height: height * 0.01,
                      ),
                      const WeatherDetailsWidget(),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchLocationField(HomeProvider homeProvider) {
    return SearchLocationFieldWidget(
      searchController: _searchController,
      searchWeather: () {
        _searchWeather();
        if (homeProvider.locationFound) {
          _searchController.clear();
        }
      },
    );
  }

  Widget _buildWeatherConditionIcon({
    required String iconPath,
    required String text,
    required BuildContext context,
  }) {
    double height = mediaQueryHeight(context);
    return Column(
      children: [
        Image.asset(
          iconPath,
          width: height * 0.05,
          height: height * 0.05,
        ),
        const SizedBox(height: 8),
        Text(text),
      ],
    );
  }

  Widget _buildNoLocationImage() {
    return Visibility(
      visible: !Provider.of<HomeProvider>(context).locationFound,
      child: const NoLocationImageWidget(),
    );
  }
}
