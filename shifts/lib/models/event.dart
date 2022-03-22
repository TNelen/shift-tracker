import 'package:shifts/util/shitfType.dart';
import 'package:shifts/util/util.dart';

class Event {
  final ShiftType shift;

  const Event(this.shift);

  @override
  String toString() => getShiftName(shift);
}
