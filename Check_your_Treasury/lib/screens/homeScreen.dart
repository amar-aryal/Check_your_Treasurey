import 'package:Check_your_Treasury/screens/receiptAdd.dart';
import 'package:Check_your_Treasury/screens/reminders.dart';
import 'package:Check_your_Treasury/screens/reportScreen.dart';
import 'package:Check_your_Treasury/screens/transactionsList.dart';
import 'package:Check_your_Treasury/services/api.dart';
import 'package:Check_your_Treasury/utilities/bottomNavBar.dart';
import 'package:Check_your_Treasury/utilities/customDrawer.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    print(pref.getString("token"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        centerTitle: true,
        backgroundColor: Colors.cyan,
      ),
      bottomNavigationBar: BottomBar(
        selectedIndex: 2,
      ),
      drawer: CustomDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Padding(
                padding: EdgeInsets.all(15.0),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.15,
                  child: Image.asset('assets/budget.png'),
                ),
              ),
            ),
            Text(
              'Your budgeting tool'.toUpperCase(),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 30),
            Row(
              children: [
                Options(
                  icon: Icons.post_add_sharp,
                  text: 'Add transactions',
                  navigate: TransactionsList(),
                ),
                Options(
                  icon: Icons.notifications_none_outlined,
                  text: 'Add reminders',
                  navigate: Reminders(),
                ),
              ],
            ),
            Row(
              children: [
                Options(
                  icon: Icons.show_chart,
                  text: 'View reports',
                  navigate: ReportScreen(),
                ),
                Options(
                  icon: Icons.receipt,
                  text: 'Add receipts',
                  navigate: ReceiptsList(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class Options extends StatelessWidget {
  final IconData icon;
  final String text;
  final Widget navigate;

  const Options({this.icon, this.text, this.navigate});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => navigate));
      },
      child: Container(
        width: 170.0,
        height: MediaQuery.of(context).size.height * 0.25,
        margin: EdgeInsets.all(15.0),
        padding: EdgeInsets.all(30.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(45.0), color: Colors.white70
            // color: Color(0Xffd8d9e6),
            ),
        child: Column(
          children: <Widget>[
            Icon(
              icon,
              size: 60,
              color: Colors.cyan,
            ),
            SizedBox(height: 10.0),
            Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }
}
