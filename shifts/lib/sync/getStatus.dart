import 'package:shared_preferences/shared_preferences.dart';

Future<bool> ishostDevice() async {
  late SharedPreferences _prefs;
  _prefs = await SharedPreferences.getInstance();

  return _prefs.getBool("isHost") ?? true;
}

Future<bool> setHostDevice() async {
  late SharedPreferences _prefs;
  _prefs = await SharedPreferences.getInstance();

  return _prefs.setBool("isHost", true);
}

Future<bool> setClientDevice() async {
  late SharedPreferences _prefs;
  _prefs = await SharedPreferences.getInstance();

  return _prefs.setBool("isHost", false);
}
