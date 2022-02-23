import 'package:flutter/material.dart';
import 'package:shifts/util/constants.dart';
import 'package:shifts/util/shitfType.dart';
import 'package:shifts/util/util.dart';

class ShiftEvent extends StatelessWidget {
  final ShiftType shiftType;

  ShiftEvent(this.shiftType);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.grey.shade300,
      
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      child: Padding(
        padding: EdgeInsets.only(top: 5, bottom: 5, right: 20, left: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                color: getColorForShift(shiftType).withOpacity(0.5),
              ),
              padding: EdgeInsets.all(12),
              child: Padding(
                padding: EdgeInsets.only(bottom: 4),
                child: Icon(
                  getShiftIcon(shiftType),
                  size: 25,
                  color: Colors.grey.shade500,
                ),
              ),
            ),
            SizedBox(
              width: 20,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                getShiftName(shiftType),
                style: TextStyle(
                    color: Colors.black54,
                    fontSize: 18,
                    fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 3,
              ),
              Text(
                getShiftTime(shiftType),
                style: TextStyle(
                    color: Colors.black54,
                    fontSize: 15,
                    fontWeight: FontWeight.w400),
              ),
            ]),
          ],
        ),
      ),
    );
  }
}
