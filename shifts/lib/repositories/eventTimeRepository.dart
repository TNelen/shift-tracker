import 'package:shared_preferences/shared_preferences.dart';
import 'package:shifts/models/eventTime.dart';

class EventTimeRepository {
  late SharedPreferences _prefs;

  Future<bool> init() async {
    bool ready = false;
    _prefs = await SharedPreferences.getInstance();
    ready = true;
    return ready;
  }

  //default values
  static const String tijd_vroege = "6:30 - 14:36";
  static const String tijd_late = "13:54 - 22:00";
  static const String tijd_nacht = "21:30 - 7:00";
  static const String tijd_ander = "21:30 - 7:00";

  String getTimeVroege() {
    return _prefs.getString("timeVroege") ?? tijd_vroege;
  }

  String getTimeLate() {
    return _prefs.getString("timeLate") ?? tijd_late;
  }

  String getTimeNacht() {
    return _prefs.getString("timeNacht") ?? tijd_nacht;
  }

  String getTimeAnder() {
    return _prefs.getString("timeAnder") ?? tijd_ander;
  }
}
