import 'dart:convert';

import 'package:Check_your_Treasury/screens/addTransaction.dart';
import 'package:Check_your_Treasury/screens/receiptAdd.dart';
import 'package:Check_your_Treasury/services/api.dart';
import 'package:Check_your_Treasury/utilities/bottomNavBar.dart';
import 'package:Check_your_Treasury/utilities/constants.dart';
import 'package:Check_your_Treasury/utilities/customDrawer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:http/http.dart' as http;

class ReceiptsList extends StatefulWidget {
  @override
  _ReceiptsListState createState() => _ReceiptsListState();
}

class _ReceiptsListState extends State<ReceiptsList> {
  Future getImages() async {
    http.Response response = await http.get(
      url + 'receipts/',
      headers: {
        "Authorization": "Token " + pref.getString("token"),
      },
    );
    if (response.statusCode == 200) {
      print(response.body);
      var data = json.decode(response.body);
      return data;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        onWillPop(context);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('My receipts', style: GoogleFonts.montserrat()),
          backgroundColor: kPrimaryColor,
          centerTitle: true,
        ),
        drawer: CustomDrawer(),
        bottomNavigationBar: BottomBar(
          selectedIndex: 3,
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
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ImageEnlarge(
                            img: data[index]["receiptImage"],
                          ),
                        ),
                      );
                    },
                    onLongPress: () {
                      showModalBottomSheet(
                        context: context,
                        builder: ((builder) => bottomSheet(data[index]["id"])),
                      );
                    },
                    child: Image.network(data[index]["receiptImage"]),
                  );
                },
              );
            } else {
              return Center(child: CircularProgressIndicator());
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
      ),
    );
  }

  deleteImage(int id) async {
    http.Response response = await http.delete(
      url + "receipts/" + "$id",
      headers: {
        "Authorization": "Token " + pref.getString('token'),
      },
    );
    print(response.statusCode);
    if (response.statusCode == 204) {
      showMyDialog(
          context, 'Successfully deleted!', 'The receipt has been deleted');
    } else {
      showMyDialog(context, 'Deletion Error!',
          'The receipt could not be deleted. Please try again');
    }
  }

  Widget bottomSheet(int id) {
    return Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(children: <Widget>[
        Text("Select action", style: GoogleFonts.montserrat()),
        SizedBox(height: 20.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FlatButton.icon(
              icon: Icon(
                Icons.delete,
                color: Colors.red,
              ),
              onPressed: () {
                setState(() {
                  deleteImage(id);
                });
                Navigator.pop(context);
              },
              label: Text("Delete", style: GoogleFonts.montserrat()),
            ),
            FlatButton.icon(
              icon: Icon(
                Icons.cancel,
                color: Colors.blue[900],
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              label: Text("Cancel", style: GoogleFonts.montserrat()),
            )
          ],
        )
      ]),
    );
  }
}

class ImageEnlarge extends StatelessWidget {
  final String img;
  ImageEnlarge({this.img});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height * 0.85,
        width: double.infinity,
        child: Image.network(img),
      ),
    );
  }
}
