import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shifts/sync/queries/getKalenderCode.dart';
import 'package:shifts/util/codeGenerator.dart';
import 'package:shifts/widgets/loadingPopup.dart';
import 'package:shifts/widgets/syncPopup.dart';

class SettingsPopup extends StatefulWidget {
  SettingsPopup();

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

  bool isImporting = false;

  @override
  Widget build(BuildContext context) {
    return isImporting
        ? SyncPopup()
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
                        return Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8.0))),
                                elevation: 0,
                                onPressed: () {
                                  setState(() {
                                    isImporting = true;
                                  });
                                },
                                color: Colors.grey.shade800,
                                child: const Text(
                                  'Importeer andere kalender',
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            ]);
                    }
                  }),
            ),
          );
  }
}
