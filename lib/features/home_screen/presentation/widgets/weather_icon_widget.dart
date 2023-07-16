import '../export_widgets.dart';

class WeatherIcon extends StatelessWidget {
  const WeatherIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = mediaQueryHeight(context);

    return Consumer<HomeProvider>(
      builder: (context, homeProvider, _) {
        String weatherIcon = homeProvider.weatherData.weatherIcon;
        if (weatherIcon.isNotEmpty) {
          String iconUrl = 'http://openweathermap.org/img/w/$weatherIcon.png';
          return GestureDetector(
            onTap: () {
              return;
            },
            child: Transform.scale(
              scale: mediaQueryHeight(context) * 0.003,
              child: Image.network(
                iconUrl,
                height: height * 0.2,
                width: height * 0.6,
                errorBuilder: (context, exception, stackTrace) {
                  return const NoLocationImageWidget();
                },
              ),
            ),
          );
        } else {
          return const NoLocationImageWidget();
        }
      },
    );
  }
}
