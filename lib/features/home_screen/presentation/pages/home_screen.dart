import 'package:google_fonts/google_fonts.dart';
import 'package:weather_app/features/home_screen/presentation/export_widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<HomeProvider>(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF2E335A),
                Color(0xFF1C1B33),
              ],
            ),
          ),
        ),
        title: _buildSearchBar(homeProvider, context),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF2E335A),
              Color(0xFF1C1B33),
            ],
          ),
        ),
        child: RefreshIndicator(
          onRefresh: () async {
            await homeProvider.fetchDefaultWeatherData();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: size.height * 0.02),
                  if (homeProvider.isLoading)
                    _buildLoadingIndicator(size)
                  else if (!homeProvider.locationFound)
                    _buildNoLocationFound(size)
                  else
                    _buildWeatherContent(homeProvider, size),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar(HomeProvider homeProvider, BuildContext context) {
    return IntrinsicHeight(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: Colors.white.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: TextField(
          controller: homeProvider.controller,
          onChanged: (value) {
            homeProvider.onSearchChanged(context);
          },
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
          decoration: InputDecoration(
            hintText: 'Search Location...',
            hintStyle: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontSize: 16,
            ),
            prefixIcon: Icon(
              Icons.search_rounded,
              color: Colors.white.withOpacity(0.5),
            ),
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator(Size size) {
    return SizedBox(
      height: size.height * 1,
      child: const Center(
        child: CircularProgressIndicator(
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildNoLocationFound(size) {
    return Padding(
      padding: EdgeInsets.only(top: size.height * 0.25),
      child: SizedBox(
        height: size.height * 1,
        width: double.infinity,
        child: const Column(
          children: [
            Icon(Icons.location_off, size: 80, color: Colors.white70),
            SizedBox(height: 16),
            Text(
              'Location not found',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherContent(HomeProvider homeProvider, Size size) {
    final weather = homeProvider.weatherData;

    return Column(
      children: [
        _buildLocationHeader(weather),
        const SizedBox(height: 30),
        _buildMainWeatherInfo(weather),
        const SizedBox(height: 30),
        _buildWeatherDetails(weather),
      ],
    );
  }

  Widget _buildLocationHeader(WeatherData weather) {
    return Column(
      children: [
        Text(
          weather.location,
          style: GoogleFonts.poppins(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          weather.country,
          style: GoogleFonts.poppins(
            fontSize: 18,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }

  Widget _buildMainWeatherInfo(WeatherData weather) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            _getWeatherIcon(weather.weatherCondition),
            size: 80,
            color: Colors.white,
          ),
          const SizedBox(height: 20),
          Text(
            '${weather.temperature.toStringAsFixed(0)}°C',
            style: GoogleFonts.poppins(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            weather.weatherCondition,
            style: GoogleFonts.poppins(
              fontSize: 20,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherDetails(WeatherData weather) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 15,
      crossAxisSpacing: 15,
      childAspectRatio: 1.5,
      children: [
        _buildDetailCard(
          'Feels Like',
          '${weather.feelsLikeTemperature.toStringAsFixed(1)}°C',
          Icons.thermostat,
        ),
        _buildDetailCard(
          'Wind',
          '${weather.windSpeed.toStringAsFixed(2)} km/h',
          Icons.air,
        ),
        _buildDetailCard(
          'Humidity',
          '${weather.humidity}%',
          Icons.water_drop,
        ),
        _buildDetailCard(
          'Sunrise',
          weather.sunrise.toStringAsFixed(2),
          Icons.wb_sunny,
        ),
        _buildDetailCard(
          'Min Temp',
          '${weather.tempMin.toStringAsFixed(1)}°C',
          Icons.arrow_downward,
        ),
        _buildDetailCard(
          'Max Temp',
          '${weather.tempMax.toStringAsFixed(1)}°C',
          Icons.arrow_upward,
        ),
      ],
    );
  }

  Widget _buildDetailCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white70, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: GoogleFonts.poppins(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getWeatherIcon(String condition) {
    condition = condition.toLowerCase();
    if (condition.contains('cloud')) return Icons.cloud;
    if (condition.contains('rain')) return Icons.water_drop;
    if (condition.contains('snow')) return Icons.ac_unit;
    if (condition.contains('clear')) return Icons.wb_sunny;
    if (condition.contains('thunder')) return Icons.flash_on;
    return Icons.wb_sunny;
  }
}
