import 'package:flutter/material.dart';
import 'package:shifts/util/constants.dart';
import 'package:shifts/util/eventLoader.dart';
import 'package:shifts/util/shitfType.dart';
import 'package:shifts/util/util.dart';

class ShiftButton extends StatelessWidget {
  late ShiftType shiftType;
  late bool enabled;

  ShiftButton(this.shiftType, this.enabled);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 4.5,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        color: getColorForShift(this.shiftType),
      ),
      padding: EdgeInsets.symmetric(vertical: 7, horizontal: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            getShiftIcon(this.shiftType),
            size: 18,
            color: this.enabled ?  Colors.grey.shade700 : Colors.grey.shade700.withOpacity(0.2) ,
          ),
          SizedBox(height: 15),
          Text(
            getShiftName(this.shiftType),
            style: TextStyle(
                color: this.enabled ? Colors.black54 : Colors.black54.withOpacity(0.2),
                fontSize: 13,
                fontWeight: FontWeight.w400),
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
