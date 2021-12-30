import 'package:flutter/material.dart';
import 'package:shifts/util/constants.dart';
import 'package:shifts/util/eventLoader.dart';
import 'package:shifts/util/shitfType.dart';
import 'package:shifts/util/util.dart';

class ShiftButton extends StatelessWidget {
  late ShiftType shiftType;

  ShiftButton(this.shiftType);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width / 5,
        margin: const EdgeInsets.symmetric(
          horizontal: 4.0,
          vertical: 4.0,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          color: getColorForShift(this.shiftType),
        ),
        padding: EdgeInsets.symmetric(vertical: 7, horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              getShiftIcon(this.shiftType),
              size: 18,
              color: Colors.grey.shade700,
            ),
            SizedBox(height: 10),
            Text(
              getShiftName(this.shiftType),
              style: TextStyle(
                  color: Colors.black54,
                  fontSize: 15,
                  fontWeight: FontWeight.w400),
              textAlign: TextAlign.center,
            )
          ],
        ),
      
    );
  }
}
