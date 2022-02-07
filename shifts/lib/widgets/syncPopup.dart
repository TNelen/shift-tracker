import 'dart:io';

import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shifts/sync/getStatus.dart';
import 'package:shifts/sync/queries/getEvents.dart';
import 'package:shifts/util/constants.dart';
import 'package:shifts/widgets/loadingPopup.dart';

class SyncPopup extends StatefulWidget {
  SyncPopup();

  @override
  State<StatefulWidget> createState() {
    return _SyncPopupState();
  }
}

class _SyncPopupState extends State<SyncPopup> {
  TextEditingController codeController = TextEditingController();
  String code = '';
  String error = '';
  bool isSuccess = false;

  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();

  @override
  void initState() {
    super.initState();
  }

  void _importCalendar(String code) async {
    if (code == "") {
      _btnController.error();
    }
    // set this calendar as a client device
    setClientDevice();
    //check if calendar exits and import it
    print("importing calendar");
    getEventsRemote(code).then(
        (value) => value.isEmpty ? _btnController.error() : "onSuccess here");
  }

  @override
  Widget build(BuildContext context) {
    return isSuccess
        ? LoadingPopup()
        : AlertDialog(
            backgroundColor: Colors.white,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(30.0))),
            title: Center(
              child: Text(
                "Instellingen",
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
            ),
            content: Container(
              height: 150,
              width: 150,
              child: Column(children: [
                TextField(
                  controller: codeController,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16.0)),
                    ),
                    labelText: 'Kalender code',
                  ),
                  onChanged: (text) {
                    setState(() {
                      _btnController.reset();
                      code = text;
                    });
                  },
                ),
              ]),
            ),
            actions: [
              Center(
                child: RoundedLoadingButton(
                  color: Colors.grey.shade800,
                  successColor: Constants.green,
                  errorColor: Constants.delete,
                  controller: _btnController,
                  onPressed: () => _importCalendar(code),
                  valueColor: Colors.black,
                  borderRadius: 8,
                  width: 150,
                  height: 40,
                  child: Text(
                    'Importeer kalender',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          );
  }
}