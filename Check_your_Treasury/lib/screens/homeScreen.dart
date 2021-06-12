import 'package:Check_your_Treasury/screens/receiptList.dart';
import 'package:Check_your_Treasury/screens/reminders.dart';
import 'package:Check_your_Treasury/screens/reportScreen.dart';
import 'package:Check_your_Treasury/screens/transactionsList.dart';
import 'package:Check_your_Treasury/services/api.dart';
import 'package:Check_your_Treasury/utilities/bottomNavBar.dart';
import 'package:Check_your_Treasury/utilities/constants.dart';
import 'package:Check_your_Treasury/utilities/customDrawer.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'exchangeRates.dart';
import 'login.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  final String username;
  HomeScreen({this.username});
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    print(pref.getString("token"));

    checkIfTokenValid();

    if (pref.getStringList(widget.username) != null) {
      print("CURR " + pref.getStringList(widget.username).toString());

      selectedCurrency = pref.getStringList(widget.username)[0];
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
    return WillPopScope(
      onWillPop: () {
        onWillPop(context);
      },
      child: Scaffold(
        backgroundColor: kPrimaryColor,
        appBar: AppBar(
          title: Text("Home", style: GoogleFonts.montserrat()),
          centerTitle: true,
          backgroundColor: kPrimaryColor,
          elevation: 0,
        ),
        bottomNavigationBar: BottomBar(
          selectedIndex: 2,
        ),
        drawer: CustomDrawer(),
        body: SingleChildScrollView(
          child: Stack(children: [
            Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.16,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(width: MediaQuery.of(context).size.width * 0.04),
                      CircleAvatar(
                        radius: MediaQuery.of(context).size.height * 0.04,
                        child: Image.asset('assets/account.png'),
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width * 0.04),
                      Expanded(
                        child: FutureBuilder(
                            future: API().getUserProfile(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                var data = snapshot.data;
                                return Text(data["username"],
                                    style: GoogleFonts.montserrat(
                                      textStyle: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                      ),
                                    ));
                              } else {
                                return Container();
                              }
                            }),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.18),
                Container(
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.1),
                      Text(
                        'Expenses this month',
                        style: GoogleFonts.montserrat(
                          textStyle: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[700]),
                        ),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.2,
                        child: RecentExpenses(),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.04),
                      Text(
                        'Incomes this month',
                        style: GoogleFonts.montserrat(
                          textStyle: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[700]),
                        ),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.2,
                        child: RecentIncomes(),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.04),
                      Text(
                        'Actions',
                        style: GoogleFonts.montserrat(
                          textStyle: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[700]),
                        ),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.08),
                      Slider(),
                    ],
                  ),
                ),
              ],
            ),
            FLoatingWidget(),
          ]),
        ),
      ),
    );
  }
}

class FLoatingWidget extends StatelessWidget {
  const FLoatingWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).size.height * 0.15,
      left: MediaQuery.of(context).size.width * 0.085,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 25),
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 1.0,
            spreadRadius: 1.0,
            offset: Offset(
              1.0,
              2.0,
            ),
          ),
        ], color: Colors.white, borderRadius: BorderRadius.circular(15)),
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.009),
            Text(
              'Operations',
              style: GoogleFonts.montserrat(
                textStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700]),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.009),
            Row(
              children: [
                Optionss(
                  img: 'assets/budget.png',
                  text: 'Transactions',
                  navigate: TransactionsList(),
                  circleColor: Colors.purple,
                ),
                SizedBox(width: MediaQuery.of(context).size.width * 0.1),
                Optionss(
                  img: 'assets/reminders.png',
                  text: 'Reminders',
                  navigate: Reminders(),
                  circleColor: Colors.blue,
                ),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.018),
            Row(
              children: [
                Optionss(
                  img: 'assets/chart.png',
                  text: 'Reports',
                  navigate: ReportScreen(),
                  circleColor: Colors.red,
                ),
                SizedBox(width: MediaQuery.of(context).size.width * 0.1),
                Optionss(
                  img: 'assets/bill.png',
                  text: 'Receipts',
                  navigate: ReceiptsList(),
                  circleColor: Colors.green,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class Optionss extends StatelessWidget {
  final String img;
  final String text;
  final Widget navigate;
  final Color circleColor;

  const Optionss({this.img, this.text, this.navigate, this.circleColor});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => navigate));
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.3,
        child: Column(
          children: <Widget>[
            CircleAvatar(
              backgroundColor: circleColor,
              radius: MediaQuery.of(context).size.width * 0.05,
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.03,
                child: Image.asset(img),
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              text,
              textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(
                textStyle: TextStyle(fontSize: 12.0),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class Slider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        viewportFraction: 1,
        autoPlay: true,
        autoPlayAnimationDuration: Duration(milliseconds: 1000),
      ),
      items: [
        Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.2,
              child: Container(
                child: Image.asset('assets/reminder_illustration.png'),
              ),
            ),
            Text('Set Reminders', style: GoogleFonts.montserrat())
          ],
        ),
        Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.2,
              child: Container(
                child: Image.asset('assets/report_illustration.png'),
              ),
            ),
            Text('View Reports', style: GoogleFonts.montserrat())
          ],
        ),
        Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.2,
              child: Container(
                child: Image.asset('assets/trans_illus.png'),
              ),
            ),
            Text('Record transactions', style: GoogleFonts.montserrat())
          ],
        ),
      ],
    );
  }
}

class RecentExpenses extends StatefulWidget {
  @override
  _RecentExpensesState createState() => _RecentExpensesState();
}

class _RecentExpensesState extends State<RecentExpenses> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: API().getRecentExpenses(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<dynamic> expenses = snapshot.data;
          print(expenses);

          if (expenses.isNotEmpty) {
            return Expanded(
              child: ListView.builder(
                itemCount: expenses.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                    child: Container(
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 1.0,
                              spreadRadius: 1.0,
                              offset: Offset(
                                1.0,
                                2.0,
                              ),
                            ),
                          ],
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15)),
                      child: ListTile(
                        leading: categoryImage(expenses[index]["category"]),
                        title: Text(expenses[index]["expensename"],
                            style: GoogleFonts.montserrat(
                                textStyle:
                                    TextStyle(fontWeight: FontWeight.bold))),
                        subtitle: Text(expenses[index]["category"],
                            style: GoogleFonts.montserrat()),
                        trailing: Text(
                          '$selectedCurrency. ${expenses[index]["amount"]}',
                          style: GoogleFonts.montserrat(
                              textStyle: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          } else {
            return Text(
              'No transactions recorded',
              style: GoogleFonts.montserrat(
                textStyle: TextStyle(color: Colors.grey, fontSize: 18),
              ),
            );
          }
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

class RecentIncomes extends StatefulWidget {
  @override
  _RecentIncomesState createState() => _RecentIncomesState();
}

class _RecentIncomesState extends State<RecentIncomes> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: API().getRecentIncomes(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<dynamic> incomes = snapshot.data;
          print(incomes);

          if (incomes.isNotEmpty) {
            return Expanded(
              child: ListView.builder(
                itemCount: incomes.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                    child: Container(
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 1.0,
                              spreadRadius: 1.0,
                              offset: Offset(
                                1.0,
                                2.0,
                              ),
                            ),
                          ],
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15)),
                      child: ListTile(
                        leading: categoryImage(incomes[index]["category"]),
                        title: Text(incomes[index]["incomename"],
                            style: GoogleFonts.montserrat(
                                textStyle:
                                    TextStyle(fontWeight: FontWeight.bold))),
                        subtitle: Text(incomes[index]["category"],
                            style: GoogleFonts.montserrat()),
                        trailing: Text(
                          '$selectedCurrency. ${incomes[index]["amount"]}',
                          style: GoogleFonts.montserrat(
                              textStyle: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          } else {
            return Text(
              'No transactions recorded',
              style: GoogleFonts.montserrat(
                textStyle: TextStyle(color: Colors.grey, fontSize: 18),
              ),
            );
          }
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
