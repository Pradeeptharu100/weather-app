import '../export_widgets.dart';

class NoLocationImageWidget extends StatelessWidget {
  const NoLocationImageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    double height = mediaQueryHeight(context);

    return Consumer<HomeProvider>(
      builder: (context, homeProvider, _) {
        return Image.asset(
          ImagePath.noLocationFound,
          height: height * 0.4,
          width: height * 0.8,
          fit: BoxFit.fitHeight,
        );
      },
    );
  }
}
