import '../export_widgets.dart';

class WeatherConditionIcon extends StatelessWidget {
  const WeatherConditionIcon({
    Key? key,
    required String iconPath,
    required String text,
  })  : _iconPath = iconPath,
        _text = text,
        super(key: key);

  final String _iconPath;
  final String _text;

  @override
  Widget build(BuildContext context) {
    double height = mediaQueryHeight(context);

    return Consumer<HomeProvider>(
      builder: (context, homeProvider, _) {
        return Column(
          children: [
            Image.asset(
              _iconPath,
              height: height * 0.04,
            ),
            SizedBox(height: height * 0.02),
            customText(context: context, text: _text),
          ],
        );
      },
    );
  }
}
