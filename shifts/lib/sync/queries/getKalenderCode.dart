import 'package:shared_preferences/shared_preferences.dart';
import 'package:shifts/util/codeGenerator.dart';

Future<String> getCalendarCode() async {
  late SharedPreferences _prefs;
  _prefs = await SharedPreferences.getInstance();

  String? code = _prefs.getString("kalenderCode");

  if (code == null) {
    code = generateCalendarCode();
    _prefs.setString("kalenderCode", code);
  }

  return code;
}

Future<String> resetCalendarCode() async {
  late SharedPreferences _prefs;
  _prefs = await SharedPreferences.getInstance();

  String code = generateCalendarCode();
  _prefs.setString("kalenderCode", code);

  return code;
}

Future<String> setCalendarCode(String code) async {
  late SharedPreferences _prefs;
  _prefs = await SharedPreferences.getInstance();

  _prefs.setString("kalenderCode", code);

  return code;
}
