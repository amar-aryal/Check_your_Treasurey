import 'package:Check_your_Treasury/screens/receiptList.dart';
import 'package:Check_your_Treasury/screens/reminders.dart';
import 'package:Check_your_Treasury/screens/reportScreen.dart';
import 'package:Check_your_Treasury/screens/transactionsList.dart';
import 'package:Check_your_Treasury/services/api.dart';
import 'package:Check_your_Treasury/utilities/bottomNavBar.dart';
import 'package:Check_your_Treasury/utilities/constants.dart';
import 'package:Check_your_Treasury/utilities/customDrawer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'exchangeRates.dart';
import 'login.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    print(pref.getString("token"));

    checkIfTokenValid();

    if (pref.getStringList("currency") != null) {
      print("CURR " + pref.getStringList("currency").toString());

      selectedCurrency = pref.getStringList("currency")[0];
    }
  }

  checkIfTokenValid() async {
    if (pref.getString("token") != null) {
      http.Response response = await http.get(
        userProfileUrl,
        headers: {
          'Content-Type': "application/json",
          "Authorization": "Token " + pref.getString('token'),
        },
      );

      print(response.statusCode);
      if (response.statusCode == 401) {
        Navigator.pushAndRemoveUntil(
            context,
            PageRouteBuilder(
              pageBuilder: (_, __, ___) => Login(),
              transitionDuration: Duration(seconds: 0),
            ),
            (Route<dynamic> route) => false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kScaffoldBgColor,
      appBar: AppBar(
        title: Text("Home"),
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
                                // color: Colors.grey[500],
                                fontSize: 18,
                                // fontWeight: FontWeight.bold,
                              ),
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
                  SizedBox(height: MediaQuery.of(context).size.height * 0.018),
                  Text(
                    'What do you want to do?',
                    style: GoogleFonts.montserrat(
                        textStyle: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[700])),
                  ),
                  Row(
                    children: [
                      Options(
                        img: 'assets/budget.png',
                        text: 'My transactions',
                        navigate: TransactionsList(),
                        circleColor: Colors.red,
                      ),
                      Options(
                        img: 'assets/reminders.png',
                        text: 'My reminders',
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
                        circleColor: Colors.green,
                      ),
                      Options(
                        img: 'assets/bill.png',
                        text: 'My receipts',
                        navigate: ReceiptsList(),
                        circleColor: Colors.purple,
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
                textStyle: TextStyle(fontSize: 16.0),
              ),
            )
          ],
        ),
      ),
    );
  }
}
