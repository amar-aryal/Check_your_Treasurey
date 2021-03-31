import 'dart:convert';
import 'dart:io';
import 'package:Check_your_Treasury/screens/addTransaction.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

void main() => runApp(MaterialApp(home: Receipt()));

class Receipt extends StatefulWidget {
  @override
  _ReceiptState createState() => _ReceiptState();
}

class _ReceiptState extends State<Receipt> {
  File _image;
  final picker = ImagePicker();
  final String imageUrl = 'http://192.168.1.108:8000/receipts/';

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
    print(_image.path);
  }

  // void _upload() async {
  //   if (_image == null) return;
  //   String base64Image = base64Encode(_image.readAsBytesSync());
  //   String fileName = _image.path.split("/").last;

  //   // http.post(imageUrl, body: {
  //   //   "image": base64Image,
  //   //   "name": fileName,
  //   // }).then((res) {
  //   //   print(res.statusCode);
  //   // }).catchError((err) {
  //   //   print(err);
  //   // });
  //   var postUri = Uri.parse(imageUrl);

  //   http.MultipartRequest request = new http.MultipartRequest("POST", postUri);

  //   http.MultipartFile multipartFile = http.MultipartFile.fromBytes(
  //       'file', File(fileName).readAsBytesSync(),
  //       filename: fileName.split("/").last);

  //   request.files.add(multipartFile);

  //   http.StreamedResponse response = await request.send();

  //   print(response.statusCode);
  // }

  Future _upload(File imageFile) async {
    if (imageFile == null) {
      showMyDialog(
          this.context, "No image selected!", "Please select an image");
    }
    var stream = new http.ByteStream(imageFile.openRead());
    var img = imageFile.readAsBytesSync();

    var length = await imageFile.length();
    print(img);

    var uri = Uri.parse(imageUrl);

    var request = new http.MultipartRequest("POST", uri);

    var multipartFile = new http.MultipartFile('file', stream, length,
        filename: basename(imageFile.path));

    request.files.add(multipartFile);

    var response = await request.send();
    print("IMGGGE:" + imageFile.toString());

    print(response.statusCode);
    response.stream.transform(utf8.decoder).listen((value) {
      print(value);
    });
  }

  void _uploadImg(File file) async {
    String fileName = file.path.split('/').last;
    print(fileName);

    FormData data = FormData.fromMap({
      "file": await MultipartFile.fromFile(
        file.path,
        filename: fileName,
        contentType: new MediaType("application", "octet-stream"),
      ),
    });

    Dio dio = new Dio();

    dio.post(imageUrl, data: data).then((response) {
      var jsonResponse = jsonDecode(response.toString());
      var testData = jsonResponse['histogram_counts'].cast<double>();
      var averageGrindSize = jsonResponse['average_particle_size'];
    }).catchError((error) => print(error));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Picker Example'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Container(
                height: 200,
                child: _image == null
                    ? Text('No image selected.')
                    : Image.file(_image),
              ),
            ),
            FlatButton(
              onPressed: () => _upload(_image),
              child: Text('Upload'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getImage,
        tooltip: 'Pick Image',
        child: Icon(Icons.add_a_photo),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'dart:io';
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:image_picker/image_picker.dart';

// void main() => runApp(Receipt());

// class Receipt extends StatefulWidget {
//   @override
//   _ReceiptState createState() => _ReceiptState();
// }

// class _ReceiptState extends State<Receipt> {
//   final String imageUrl = 'http://10.0.2.2:8000/receipts/';

//   File file;

//   void _choose() async {
//     file = (await ImagePicker().getImage(source: ImageSource.gallery)) as File;
// // file = await ImagePicker.pickImage(source: ImageSource.gallery);
//   }

//   void _upload() {
//     if (file == null) return;
//     String base64Image = base64Encode(file.readAsBytesSync());
//     String fileName = file.path.split("/").last;

//     http.post(imageUrl, body: {
//       "image": base64Image,
//       "name": fileName,
//     }).then((res) {
//       print(res.statusCode);
//     }).catchError((err) {
//       print(err);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Column(
//           children: <Widget>[
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: <Widget>[
//                 RaisedButton(
//                   onPressed: _choose,
//                   child: Text('Choose Image'),
//                 ),
//                 SizedBox(width: 10.0),
//                 RaisedButton(
//                   onPressed: _upload,
//                   child: Text('Upload Image'),
//                 )
//               ],
//             ),
//             file == null ? Text('No Image Selected') : Image.file(file)
//           ],
//         ),
//       ),
//     );
//   }
// }

class ReceiptsList extends StatefulWidget {
  @override
  _ReceiptsListState createState() => _ReceiptsListState();
}

class _ReceiptsListState extends State<ReceiptsList> {
  Future getImages() async {
    http.Response response =
        await http.get('http://192.168.1.108:8000/receipts/');
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return data;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My receipts'),
      ),
      body: FutureBuilder(
        future: getImages(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<dynamic> data = snapshot.data;
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 4.0,
                  mainAxisSpacing: 4.0),
              itemCount: data.length,
              itemBuilder: (BuildContext context, int index) {
                return Image.network(data[index]["receiptImage"]);
              },
            );
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Receipt()));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
