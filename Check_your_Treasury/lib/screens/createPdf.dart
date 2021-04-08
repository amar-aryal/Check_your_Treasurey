import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:Check_your_Treasury/services/api.dart';
import 'package:Check_your_Treasury/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class PDF extends StatefulWidget {
  final String year;
  final String month;

  PDF({this.year, this.month});

  @override
  _PDFState createState() => _PDFState();
}

class _PDFState extends State<PDF> {
  int progress = 0;

  ReceivePort _receivePort = ReceivePort();

  static downloadingCallback(id, status, progress) {
    ///Looking up for a send port
    SendPort sendPort = IsolateNameServer.lookupPortByName("downloading");

    ///ssending the data
    sendPort.send([id, status, progress]);
  }

  @override
  void initState() {
    super.initState();

    ///register a send port for the other isolates
    IsolateNameServer.registerPortWithName(
        _receivePort.sendPort, "downloading");

    ///Listening for the data is comming other isolataes
    _receivePort.listen((message) {
      setState(() {
        progress = message[2];
      });

      print(progress);
    });

    FlutterDownloader.registerCallback(downloadingCallback);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Download Report'),
        centerTitle: true,
        backgroundColor: kPrimaryColor,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "$progress",
              style: TextStyle(fontSize: 60),
            ),
            SizedBox(
              height: 60,
            ),
            ButtonTheme(
              padding: EdgeInsets.symmetric(vertical: 10),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              minWidth: MediaQuery.of(context).size.width * 0.8,
              child: FlatButton(
                child: Text("DOWNLOAD PDF", style: TextStyle(fontSize: 18)),
                color: kPrimaryColor,
                textColor: Colors.white,
                onPressed: () async {
                  final status = await Permission.storage.request();

                  if (status.isGranted) {
                    Directory externalDir = await getExternalStorageDirectory();
                    String newPath = "";
                    List<String> paths = externalDir.path.split("/");
                    for (int x = 1; x < paths.length; x++) {
                      String folder = paths[x];
                      if (folder != "Android") {
                        newPath += "/" + folder;
                      } else {
                        break;
                      }
                    }
                    newPath = newPath + "/Reports";
                    externalDir = Directory(newPath);
                    bool hasExisted = await externalDir.exists();
                    if (!hasExisted) {
                      externalDir.create();
                    }
                    print(hasExisted);
                    if (hasExisted) {
                      final id = await FlutterDownloader.enqueue(
                        url: url +
                            "report?year=${widget.year}&month=${widget.month}",
                        headers: {
                          "Authorization": "Token " + pref.getString("token"),
                        },
                        savedDir: externalDir.path,
                        fileName: "report.pdf",
                        showNotification: true,
                        openFileFromNotification: true,
                      );
                    }
                  } else {
                    print("Permission deined");
                  }
                },
              ),
            ),
            SizedBox(height: 80),
            ButtonTheme(
              padding: EdgeInsets.symmetric(vertical: 10),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              minWidth: MediaQuery.of(context).size.width * 0.8,
              child: FlatButton(
                child: Text("EXPORT TO EXCEL", style: TextStyle(fontSize: 18)),
                color: kPrimaryColor,
                textColor: Colors.white,
                onPressed: () async {
                  final status = await Permission.storage.request();

                  if (status.isGranted) {
                    Directory externalDir = await getExternalStorageDirectory();

                    String newPath = "";
                    List<String> paths = externalDir.path.split("/");
                    for (int x = 1; x < paths.length; x++) {
                      String folder = paths[x];
                      if (folder != "Android") {
                        newPath += "/" + folder;
                      } else {
                        break;
                      }
                    }
                    newPath = newPath + "/Reports";
                    externalDir = Directory(newPath);
                    bool hasExisted = await externalDir.exists();
                    if (!hasExisted) {
                      externalDir.create();
                    }
                    print(hasExisted);
                    if (hasExisted) {
                      final id = await FlutterDownloader.enqueue(
                        url: url +
                            "export?year=${widget.year}&month=${widget.month}",
                        headers: {
                          "Authorization": "Token " + pref.getString("token"),
                        },
                        savedDir: externalDir.path,
                        fileName: "ExcelReport.xlsx",
                        showNotification: true,
                        openFileFromNotification: true,
                      );
                    }
                  } else {
                    print("Permission deined");
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
