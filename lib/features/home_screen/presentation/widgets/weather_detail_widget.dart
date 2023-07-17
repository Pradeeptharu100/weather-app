import 'package:intl/intl.dart';

import '../export_widgets.dart';

class WeatherDetailsWidget extends StatefulWidget {
  const WeatherDetailsWidget({Key? key}) : super(key: key);

  @override
  State<WeatherDetailsWidget> createState() => _WeatherDetailsWidgetState();
}

class _WeatherDetailsWidgetState extends State<WeatherDetailsWidget> {
  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<HomeProvider>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildWeatherDetails(
              context: context,
              image: ImagePath.feel_likeIcon,
              title: 'FeelLike',
              data: homeProvider.weatherData.feelsLikeTemperature.toString(),
            ),
            _buildWeatherDetails(
              context: context,
              image: ImagePath.windSpeedIcon,
              title: 'N wind',
              data: ' ${homeProvider.weatherData.windSpeed.toString}',
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildWeatherDetails(
              context: context,
              image: ImagePath.humidityIcon,
              title: 'Humidity',
              data: '${homeProvider.weatherData.humidity}%',
            ),
            _buildWeatherDetails(
              context: context,
              image: ImagePath.sunriseIcon,
              title: 'Sunrise',
              data: '5 Moderate',
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildWeatherDetails(
              context: context,
              image: ImagePath.temp_min,
              title: 'Temp Min',
              data: '8 km',
            ),
            _buildWeatherDetails(
              context: context,
              image: ImagePath.temp_max,
              title: 'Temp max',
              data: '1012 hPa',
            ),
          ],
        )
      ],
    );
  }

  Widget _buildWeatherDetails({
    required BuildContext context,
    required String title,
    required String image,
    required String data,
  }) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    late String updatedData;
    final homeProvider = Provider.of<HomeProvider>(context);

    switch (title) {
      case 'FeelLike':
        updatedData =
            homeProvider.weatherData.feelsLikeTemperature.toStringAsFixed(2);
        break;
      case 'N wind':
        updatedData =
            '${homeProvider.weatherData.windSpeed.toStringAsFixed(2)} km/h';
        break;
      case 'Humidity':
        updatedData = '${homeProvider.weatherData.humidity}%';
        break;
      case 'Sunrise':
        updatedData = _formatDateTime(homeProvider.weatherData.sunrise);
        break;
      case 'Temp Min':
        updatedData = _formatTemperature(homeProvider.weatherData.tempMin);
        break;
      case 'Temp max':
        updatedData = _formatTemperature(homeProvider.weatherData.tempMax);
        break;
      default:
        updatedData = data;
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: height * 0.01,
        vertical: height * 0.01,
      ),
      height: height * 0.22,
      width: width * 0.5,
      child: Card(
        shadowColor: Colors.white,
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(height * 0.02),
        ),
        // color: const Color(0x806ef9e9),
        color: Colors.white54,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset(image, fit: BoxFit.cover, height: height * 0.05),
            customText(
              context: context,
              text: title,
            ),
            customText(context: context, text: updatedData),
          ],
        ),
      ),
    );
  }

  String _formatDateTime(int timestamp) {
    final dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    final timeFormat = DateFormat.jm().format(dateTime);
    return timeFormat;
  }

  String _formatTemperature(double temperature) {
    return '${temperature.toStringAsFixed(1)} °C';
  }
}
