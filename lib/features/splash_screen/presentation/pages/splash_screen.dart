import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:weather_app/core/utils/constants/constants.dart';
import 'package:weather_app/core/utils/custom_widgets/custom_text.dart';
import 'package:weather_app/features/home_screen/presentation/pages/home_screen.dart';

class SplashScreen extends StatefulWidget {
  static const routeName = '/splashScreen';
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // time for 5 send to go automatically in homeScreen
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 5), () {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HomeScreen()));
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = mediaQueryHeight(context);
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: Container(
        constraints: const BoxConstraints.expand(),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(ImagePath.splashFrame),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: height * 0.12),
              child: customText(
                context: context,
                text: 'We show weather for you',
                fontWeight: FontWeight.w500,
                letterSpacing: 1.5,
                fontSize: height * 0.025,
              ),
            ),
            Center(
              child: Image.asset(
                ImagePath.appIcon,
                height: height * 0.3,
              ),
            ),
            SizedBox(height: height * 0.25),
            SpinKitWave(
              size: height * 0.07,
              color: Colors.blue,
            ),
          ],
        ),
      ),
      floatingActionButton: Align(
        alignment: Alignment.bottomCenter,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepOrange,
            fixedSize: Size(height * 0.2, height * 0.06),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(height * 0.015),
            ),
          ),
          child:
              customText(context: context, text: 'Skip', color: Colors.white),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HomeScreen(),
                ));
          },
        ),
      ),
    );
  }
}
