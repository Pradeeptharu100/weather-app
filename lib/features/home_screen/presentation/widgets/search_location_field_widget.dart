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
    return Consumer<HomeProvider>(
      builder: (context, homeProvider, _) {
        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.height * 0.02,
            vertical: MediaQuery.of(context).size.height * 0.01,
          ),
          child: TextFormField(
            focusNode: homeProvider.focusNode,
            onFieldSubmitted: (value) {
              if (_searchController.text.isEmpty) {
                return;
              }
              _searchController.text = value;
              _searchWeather();
              _searchController.clear();
              homeProvider.updateDataSavedStatus(
                  true); // Update data saved status using Provider
            },
            onChanged: (value) {
              homeProvider.updateEditingState(value.isNotEmpty);
              if (value.isEmpty) {
                homeProvider.focusNode.unfocus();
              }
              homeProvider.updateDataSavedStatus(
                  false); // Update data saved status using Provider
            },
            style:
                TextStyle(fontSize: MediaQuery.of(context).size.height * 0.025),
            controller: _searchController,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.06,
                vertical: MediaQuery.of(context).size.height * 0.02,
              ),
              labelText: 'Search Location',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                    MediaQuery.of(context).size.height * 0.015),
              ),
              suffixIcon: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  fixedSize: Size(MediaQuery.of(context).size.width * 0.25,
                      MediaQuery.of(context).size.height * 0.07),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        MediaQuery.of(context).size.height * 0.015),
                  ),
                ),
                onPressed: () {
                  if (_searchController.text.isEmpty) {
                    return;
                  }
                  _searchWeather();
                  _searchController.clear();
                  homeProvider.updateDataSavedStatus(
                      true); // Update data saved status using Provider
                },
                child: customText(
                  context: context,
                  text: homeProvider.isDataSaved ||
                          _searchController.text.isEmpty
                      ? 'Save'
                      : 'Update', // Toggle button text based on isDataSaved value from Provider
                  color: Colors.white,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
