import 'package:flutter/material.dart';
import 'package:shifts/util/shitfType.dart';
import 'package:weather_icons/weather_icons.dart';

class Constants {
  static const Color blue = Color.fromRGBO(149, 184, 208, 1);
  static const Color green = Color.fromRGBO(187, 222, 215, 1);
  static const Color pink = Color.fromRGBO(221, 198, 235, 1);

  static Color delete = Color.fromRGBO(255, 155, 155, 1).withOpacity(0.5);

  static Color grey = Colors.grey.shade200;

  static const IconData vroege = WeatherIcons.horizon_alt;
  static const IconData latee = WeatherIcons.day_cloudy_high;
  static const IconData nacht = WeatherIcons.night_clear;
  static const IconData ander = WeatherIcons.day_sunny;

}
