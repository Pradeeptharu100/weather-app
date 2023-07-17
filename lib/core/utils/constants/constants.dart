import 'package:flutter/material.dart';

// normal fontsize
double defultFontSize(BuildContext context) {
  return MediaQuery.of(context).size.height * 0.022;
}

// tablet fontsize
double tabletFontSize(BuildContext context) {
  return MediaQuery.of(context).size.height * 0.023;
}

// icon moible size
double iconSizeMobile(BuildContext context) {
  return MediaQuery.of(context).size.height * 0.023;
}

// icon tablet size
double iconSizeTablet(BuildContext context) {
  return MediaQuery.of(context).size.height * 0.027;
}

double iconSizeTabletLandscape(BuildContext context) {
  return MediaQuery.of(context).size.height * 0.04;
}

// padding for tablet 30
double paddingTablet20(BuildContext context) {
  return MediaQuery.of(context).size.height * 0.02;
}

double paddingTablet30(BuildContext context) {
  return MediaQuery.of(context).size.height * 0.025;
}

double paddingTablet40(BuildContext context) {
  return MediaQuery.of(context).size.height * 0.04;
}

double paddingTablet50(BuildContext context) {
  return MediaQuery.of(context).size.height * 0.05;
}

double paddingTabletLandscape35(BuildContext context) {
  return MediaQuery.of(context).size.height * 0.035;
}

// padding for mobile 10
double paddingMobile10(BuildContext context) {
  return MediaQuery.of(context).size.height * 0.012;
}

double tabletLandscapeFontSize(BuildContext context) {
  return MediaQuery.of(context).size.height * 0.031;
}

// App Colors
class AppColor {
  static const backgroundColor = Colors.white;
  static const cardColor = Color.fromARGB(238, 241, 243, 245);
  static const Color titleTextColor = Color(0xff000000);
  static const Color scaffoldBackgroundColor = Color(0xff6ef9e6);
  static const Color cardTransparentColor = Color(0xff95f6f5);
}

// hint teststyle
TextStyle hintStyle(
    {double? fontSize,
    Color? color,
    FontWeight? fontWeight,
    double? letterSpacing,
    TextOverflow? overflow}) {
  return TextStyle(
    fontSize: fontSize,
    color: color,
    fontWeight: fontWeight,
    letterSpacing: letterSpacing,
    overflow: overflow,
  );
}

// Media Querry height
double mediaQueryHeight(BuildContext context) {
  return MediaQuery.of(context).size.height;
}

// Medai Querry Width
double mediaQueryWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

//  Sized Box With height 10
Widget commonSizedBox(BuildContext context) {
  return SizedBox(
    height: mediaQueryHeight(context) * 0.02,
  );
}

// Check isTablet Or Not
bool isTablet(BuildContext context) {
  final shortesSide = MediaQuery.of(context).size.shortestSide;
  return shortesSide >= 600;
}

// Image Path
class ImagePath {
  static const splashFrame = 'assets/images/frame.png';
  static const windSpeedIcon = 'assets/images/wind.png';
  static const humidityIcon = 'assets/images/humidity.png';
  static const noLocationFound = 'assets/images/no_location_found.png';
  static const appIcon = 'assets/images/weather.png';
  static const feel_likeIcon = 'assets/weather_detail_images/feel_like.png';
  static const sunriseIcon = 'assets/weather_detail_images/sunrise.png';
  static const temp_max = 'assets/weather_detail_images/max_temp.png';
  static const temp_min = 'assets/weather_detail_images/min_temp.png';
}
