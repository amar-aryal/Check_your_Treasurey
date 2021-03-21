// import 'dart:io';

// import 'package:Check_your_Treasury/screens/pdfPreview.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:pie_chart/pie_chart.dart';

// void main() => runApp(MyApp());

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: PDF(),
//     );
//   }
// }

// class PDF extends StatelessWidget {
//   final PieChart inc;
//   final PieChart exp;
//   final pdf = pw.Document();

//   PDF({this.inc, this.exp});

//   writeOnPdf() {
//     pdf.addPage(pw.MultiPage(
//       pageFormat: PdfPageFormat.a5,
//       margin: pw.EdgeInsets.all(32),
//       build: (pw.Context context) {
//         return <pw.Widget>[
//           pw.Header(level: 0, child: pw.Text("Easy Approach Document")),
//           pw.Paragraph(
//               text:
//                   "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Malesuada fames ac turpis egestas sed tempus urna. Quisque sagittis purus sit amet. A arcu cursus vitae congue mauris rhoncus aenean vel elit. Ipsum dolor sit amet consectetur adipiscing elit pellentesque. Viverra justo nec ultrices dui sapien eget mi proin sed."),
//           pw.Paragraph(
//               text:
//                   "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Malesuada fames ac turpis egestas sed tempus urna. Quisque sagittis purus sit amet. A arcu cursus vitae congue mauris rhoncus aenean vel elit. Ipsum dolor sit amet consectetur adipiscing elit pellentesque. Viverra justo nec ultrices dui sapien eget mi proin sed."),
//           pw.Header(level: 1, child: pw.Text("Second Heading")),
//           pw.Paragraph(
//               text:
//                   "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Malesuada fames ac turpis egestas sed tempus urna. Quisque sagittis purus sit amet. A arcu cursus vitae congue mauris rhoncus aenean vel elit. Ipsum dolor sit amet consectetur adipiscing elit pellentesque. Viverra justo nec ultrices dui sapien eget mi proin sed."),
//           pw.Paragraph(
//               text:
//                   "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Malesuada fames ac turpis egestas sed tempus urna. Quisque sagittis purus sit amet. A arcu cursus vitae congue mauris rhoncus aenean vel elit. Ipsum dolor sit amet consectetur adipiscing elit pellentesque. Viverra justo nec ultrices dui sapien eget mi proin sed."),
//           pw.Paragraph(
//               text:
//                   "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Malesuada fames ac turpis egestas sed tempus urna. Quisque sagittis purus sit amet. A arcu cursus vitae congue mauris rhoncus aenean vel elit. Ipsum dolor sit amet consectetur adipiscing elit pellentesque. Viverra justo nec ultrices dui sapien eget mi proin sed."),
//         ];
//       },
//     ));
//   }

//   Future savePdf() async {
//     Directory documentDirectory = await getExternalStorageDirectory();

//     String documentPath = documentDirectory.path;

//     File file = File("$documentPath/example.pdf");

//     file.writeAsBytesSync(await pdf.save());
//   }

//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("PDF Flutter"),
//       ),

//       body: Container(
//         width: double.infinity,
//         height: double.infinity,
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Text(
//               "PDF TUTORIAL",
//               style: TextStyle(fontSize: 34),
//             )
//           ],
//         ),
//       ),

//       floatingActionButton: FloatingActionButton(
//         onPressed: () async {
//           writeOnPdf();
//           await savePdf();

//           Directory documentDirectory =
//               await getApplicationDocumentsDirectory();

//           String documentPath = documentDirectory.path;

//           String fullPath = "$documentPath/example.pdf";

//           print(documentDirectory);

//           Navigator.push(
//               context,
//               MaterialPageRoute(
//                   builder: (context) => PdfPreviewScreen(
//                         path: fullPath,
//                       )));
//         },
//         child: Icon(Icons.save),
//       ), // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }
// }

import 'dart:isolate';
import 'dart:ui';

import 'package:Check_your_Treasury/services/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(
      debug: true // optional: set false to disable printing logs to console
      );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: PDF(),
    );
  }
}

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
        backgroundColor: Colors.cyan,
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
            FlatButton(
              child: Text("Start Downloading", style: TextStyle(fontSize: 18)),
              color: Colors.cyan,
              textColor: Colors.white,
              onPressed: () async {
                final status = await Permission.storage.request();

                if (status.isGranted) {
                  final externalDir = await getExternalStorageDirectory();

                  final id = await FlutterDownloader.enqueue(
                    url:
                        "http://10.0.2.2:8000/report?year=${widget.year}&month=${widget.month}",
                    headers: {
                      "Authorization": "Token " + pref.getString("token"),
                    },
                    savedDir: externalDir.path,
                    fileName: "report",
                    showNotification: true,
                    openFileFromNotification: true,
                  );
                } else {
                  print("Permission deined");
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
