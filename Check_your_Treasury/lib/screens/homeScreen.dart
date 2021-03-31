import 'dart:io';

import 'package:Check_your_Treasury/screens/receiptAdd.dart';
import 'package:Check_your_Treasury/screens/reminders.dart';
import 'package:Check_your_Treasury/screens/reportScreen.dart';
import 'package:Check_your_Treasury/screens/transactionsList.dart';
import 'package:Check_your_Treasury/services/api.dart';
import 'package:Check_your_Treasury/utilities/bottomNavBar.dart';
import 'package:Check_your_Treasury/utilities/constants.dart';
import 'package:Check_your_Treasury/utilities/customDrawer.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:device_info/device_info.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FirebaseMessaging _firebaseMessaging;
  String messageTitle = "Empty";
  String notificationAlert = "alert";

  @override
  void initState() {
    super.initState();
    //device ID
    _getId().then((id) => print(id));

    _firebaseMessaging = FirebaseMessaging();
    _firebaseMessaging.getToken().then((token) => print(token));

    getMessage();

    print(pref.getString("token"));
  }

  void getMessage() {
    _firebaseMessaging.configure(
      onMessage: (message) async {
        setState(() {
          messageTitle = message["notification"]["title"];
          notificationAlert = "New Notification Alert";
        });
      },
      onResume: (message) async {
        setState(() {
          messageTitle = message["data"]["title"];
          notificationAlert = "Application opened from Notification";
        });
      },
    );
  }

  Future<String> _getId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.androidId; // unique ID on Android
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[100],
      appBar: AppBar(
        title: Text(messageTitle),
        centerTitle: true,
        backgroundColor: kPrimaryColor,
      ),
      bottomNavigationBar: BottomBar(
        selectedIndex: 2,
      ),
      drawer: CustomDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(width: MediaQuery.of(context).size.width * 0.04),
                  CircleAvatar(
                    radius: MediaQuery.of(context).size.height * 0.05,
                    child: Image.asset('assets/account.png'),
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.04),
                  Expanded(
                    child: FutureBuilder(
                        future: API().getUserProfile(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            var data = snapshot.data;
                            return Text(
                              data["username"],
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            );
                          } else {
                            return Container();
                          }
                        }),
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30)),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Options(
                        img: 'assets/budget.png',
                        text: 'Add transactions',
                        navigate: TransactionsList(),
                        circleColor: Colors.purple,
                      ),
                      Options(
                        img: 'assets/reminders.png',
                        text: 'Add reminders',
                        navigate: Reminders(),
                        circleColor: Colors.blue,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Options(
                        img: 'assets/chart.png',
                        text: 'View reports',
                        navigate: ReportScreen(),
                        circleColor: Colors.red,
                      ),
                      Options(
                        img: 'assets/bill.png',
                        text: 'Add receipts',
                        navigate: ReceiptsList(),
                        circleColor: Colors.green,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Options extends StatelessWidget {
  final String img;
  final String text;
  final Widget navigate;
  final Color circleColor;

  const Options({this.img, this.text, this.navigate, this.circleColor});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => navigate));
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.415,
        margin: EdgeInsets.all(15.0),
        padding: EdgeInsets.all(30.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(45.0), color: Colors.white70
            // color: Color(0Xffd8d9e6),
            ),
        child: Column(
          children: <Widget>[
            CircleAvatar(
              backgroundColor: circleColor,
              radius: MediaQuery.of(context).size.width * 0.1,
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.075,
                child: Image.asset(img),
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              text,
              textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(
                textStyle: TextStyle(fontSize: 18.0),
              ),
            )
          ],
        ),
      ),
    );
  }
}
