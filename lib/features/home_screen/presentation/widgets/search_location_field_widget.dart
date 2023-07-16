import '../export_widgets.dart';

class SearchLocationFieldWidget extends StatelessWidget {
  const SearchLocationFieldWidget({
    Key? key,
    required TextEditingController searchController,
    required VoidCallback searchWeather,
  })  : _searchController = searchController,
        _searchWeather = searchWeather,
        super(key: key);

  final TextEditingController _searchController;
  final VoidCallback _searchWeather;

  @override
  Widget build(BuildContext context) {
    double height = mediaQueryHeight(context);
    double width = mediaQueryWidth(context);

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: height * 0.02,
        vertical: height * 0.01,
      ),
      child: Consumer<HomeProvider>(
        builder: (context, homeProvider, _) {
          return TextFormField(
            onFieldSubmitted: (value) {
              _searchController.text = value;
            },
            style: TextStyle(fontSize: height * 0.025),
            controller: _searchController,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(
                horizontal: width * 0.06,
                vertical: height * 0.02,
              ),
              labelText: 'Search Location',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(height * 0.015),
              ),
              suffixIcon: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  fixedSize: Size(width * 0.25, height * 0.07),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(height * 0.015),
                  ),
                ),
                onPressed: () {
                  _searchWeather();
                  if (homeProvider.locationFound) {
                    _searchController.clear();
                  }
                },
                child: customText(
                  context: context,
                  text: 'Update',
                  color: Colors.white,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
