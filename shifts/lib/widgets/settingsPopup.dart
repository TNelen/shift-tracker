import 'dart:io';

import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shifts/main.dart';
import 'package:shifts/sync/eventLoader.dart';
import 'package:shifts/sync/getStatus.dart';
import 'package:shifts/sync/queries/getKalenderCode.dart';
import 'package:shifts/util/codeGenerator.dart';
import 'package:shifts/util/constants.dart';
import 'package:shifts/widgets/loadingPopup.dart';
import 'package:shifts/widgets/syncPopup.dart';

class SettingsPopup extends StatefulWidget {
  Eventloader eventloader;
  SettingsPopup(this.eventloader);

  @override
  State<StatefulWidget> createState() {
    return _SettingsPopupState();
  }
}

class _SettingsPopupState extends State<SettingsPopup> {
  @override
  void initState() {
    super.initState();
  }

  void _disableConnection() async {
    await setHostDevice();
    await resetCalendarCode();
    
    //remove all imported events from local storage
    await widget.eventloader.removeAllLocalEvents();
    _btnController.success();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => MyApp(),
      ),
    );
    ;
  }

  bool isImporting = false;

  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();

  @override
  Widget build(BuildContext context) {
    return isImporting
        ? SyncPopup(widget.eventloader)
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
              child: FutureBuilder<String>(
                  future: getCalendarCode(),
                  builder: (context, AsyncSnapshot<String> snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      default:
                        return widget.eventloader.isHostDevice
                            ? Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                    Text(
                                      'Mijn kalender code:',
                                      style: const TextStyle(
                                          color: Colors.black, fontSize: 16),
                                    ),
                                    Text(
                                      snapshot.data!,
                                      style: const TextStyle(
                                          color: Colors.black, fontSize: 16),
                                    ),
                                    MaterialButton(
                                      shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(8.0))),
                                      elevation: 0,
                                      onPressed: () {
                                        setState(() {
                                          isImporting = true;
                                        });
                                      },
                                      color: Colors.grey.shade800,
                                      child: const Text(
                                        'Importeer andere kalender',
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                    ),
                                  ])
                            : Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                    Text(
                                      'Je bent geabboneerd op een andere kalender',
                                      style: const TextStyle(
                                          color: Colors.black, fontSize: 16),
                                    ),
                                    RoundedLoadingButton(
                                      color: Colors.grey.shade800,
                                      successColor: Constants.green,
                                      errorColor: Constants.delete,
                                      controller: _btnController,
                                      onPressed: () => _disableConnection(),
                                      valueColor: Colors.black,
                                      borderRadius: 8,
                                      width: 150,
                                      height: 40,
                                      child: Text(
                                        'Verbreek verbinding',
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                    ),
                                  ]);
                    }
                  }),
            ),
          );
  }
}
