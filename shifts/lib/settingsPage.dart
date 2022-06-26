import 'package:flutter/material.dart';
import 'package:shifts/util/constants.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Constants.blue,
          title: Text(
            'Instellingen',
            style: TextStyle(color: Colors.black87),
          ),
        ),
        body: Container(
          color: Constants.blue,
          child: Column(children: [
            Text("Test"),
          ]),
        ));
  }
}
