import '../export_widgets.dart';

class SearchLocationFieldWidget extends StatefulWidget {
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
  State<SearchLocationFieldWidget> createState() =>
      _SearchLocationFieldWidgetState();
}

class _SearchLocationFieldWidgetState extends State<SearchLocationFieldWidget> {
  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
  }

  late FocusNode _focusNode;

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
            focusNode: _focusNode,
            onFieldSubmitted: (value) {
              widget._searchController.text = value;
              widget._searchWeather();
              widget._searchController.clear();
            },
            onChanged: (value) {
              Provider.of<HomeProvider>(context, listen: false)
                  .updateEditingState(value.isNotEmpty);
              if (value.isEmpty) {
                _focusNode.unfocus();
              }
            },
            style: TextStyle(fontSize: height * 0.025),
            controller: widget._searchController,
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
                  if (widget._searchController.text.isEmpty) {
                    return;
                  }
                  widget._searchWeather();
                  widget._searchController.clear();
                },
                child: customText(
                  context: context,
                  text: homeProvider.isEditing ? 'Update' : 'Save',
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
