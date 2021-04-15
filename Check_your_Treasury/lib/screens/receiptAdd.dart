import 'package:Check_your_Treasury/screens/addTransaction.dart';
import 'package:Check_your_Treasury/screens/receiptList.dart';
import 'package:Check_your_Treasury/screens/reportScreen.dart';
import 'package:Check_your_Treasury/services/api.dart';
import 'package:Check_your_Treasury/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class Receipt extends StatefulWidget {
  Receipt({Key key}) : super(key: key);

  @override
  _ReceiptState createState() => _ReceiptState();
}

class _ReceiptState extends State<Receipt> {
  Future<File> file0;

  String status = '';

  File tmpFile;

  String errMessage = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        centerTitle: true,
        title: Text("Receipts"),
      ),
      body: Container(
        padding: EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 20.0),
            showImage(file0),
            SizedBox(height: 30.0),
            ButtonTheme(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              minWidth: MediaQuery.of(context).size.width * 0.5,
              child: FlatButton(
                padding: EdgeInsets.symmetric(vertical: 10),
                color: kPrimaryColor,
                onPressed: startUpload,
                child: Text(
                  "UPLOAD",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
            Text(errMessage)
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: ((builder) => bottomSheet()),
          );
        },
        child: Icon(Icons.camera_alt_rounded),
      ),
    );
  }

  Widget showImage(Future data) {
    return FutureBuilder<File>(
        future: data,
        builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              null != snapshot.data) {
            tmpFile = snapshot.data;

            return Flexible(child: Image.file(snapshot.data, fit: BoxFit.fill));
          } else if (null != snapshot.error) {
            return Text("No Image Selected");
          } else {
            return Center(
              child: Container(
                height: MediaQuery.of(context).size.height * 0.25,
                width: MediaQuery.of(context).size.width * 0.8,
                color: Colors.grey[300],
                child: Icon(
                  Icons.photo,
                  size: MediaQuery.of(context).size.width * 0.1,
                  color: Colors.grey,
                ),
              ),
            );
          }
        });
  }

  Widget bottomSheet() {
    return Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(children: <Widget>[
        Text("Select source"),
        SizedBox(height: 20.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FlatButton.icon(
              icon: Icon(
                Icons.camera,
                color: Colors.blue[900],
              ),
              onPressed: () {
                takePhoto(ImageSource.camera);
                Navigator.pop(context);
              },
              label: Text("Camera"),
            ),
            FlatButton.icon(
              icon: Icon(
                Icons.image,
                color: Colors.green,
              ),
              onPressed: () {
                takePhoto(ImageSource.gallery);
                Navigator.pop(context);
              },
              label: Text("Gallery"),
            )
          ],
        )
      ]),
    );
  }

  void takePhoto(ImageSource source) async {
    setState(() {
      file0 = ImagePicker.pickImage(source: source);
    });
  }

  setStatus(String message) {
    setState(() {
      status = message;
    });
  }

  startUpload() {
    setState(() {
      errMessage = "uploading";
    });
    if (null == tmpFile) {
      errMessage = "Please select an image";
      setStatus(errMessage);
      return;
    }

    uploadImage(tmpFile);
  }

  void uploadImage(File file) async {
    String fileName = file.path.split('/').last;
    print(fileName);
    FormData data = FormData.fromMap(
      {
        "receiptImage": await MultipartFile.fromFile(
          file.path,
          filename: fileName,
        ),
      },
    );

    Dio dio = new Dio();
    dio.options.headers["authorization"] = "Token " + pref.getString("token");

    dio.post(url + "receipts/", data: data).then((response) {
      print(response.statusCode);
      if (response.statusCode == 201) {
        showMyDialog(
                context, "Receipt saved", "The receipt image has been saved")
            .then((data) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => ReceiptsList()));
        });

        setState(() {
          errMessage = "Uploaded";
        });
      } else {
        showMyDialog(
            context, 'Error!', 'There was some problem.Please try again');
      }
    }).catchError((error) => setStatus(errMessage = error.toString()));
  }
}
