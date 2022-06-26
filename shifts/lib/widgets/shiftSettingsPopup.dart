import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shifts/main.dart';

class ShiftSettingsPopup extends StatelessWidget {
  const ShiftSettingsPopup();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(30.0))),
      title: Center(
        child: Text(
          "Stel shiften in",
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
        ),
      ),

      content: Container(
        height: 150,
        width: 300,
        child: Center(
          child: Column(children: [
            Text(
              "Kalendar aan het laden",
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
            ),
          ]),
        ),
      ),

      // usually buttons at the bottom of the dialog
      actions: [
        Center(
          child: MaterialButton(
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
            elevation: 0,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => MyHomePage(),
                ),
              );
            },
            color: Colors.grey,
            child: Text(
              'Ok',
              style: TextStyle(color: Colors.white),
            ),
          ),
        )
      ],
    );
  }
}
