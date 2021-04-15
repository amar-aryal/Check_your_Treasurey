import 'package:Check_your_Treasury/screens/budgetList.dart';
import 'package:Check_your_Treasury/screens/exchangeRates.dart';
import 'package:Check_your_Treasury/screens/receiptList.dart';
import 'package:Check_your_Treasury/screens/reportScreen.dart';
import 'package:Check_your_Treasury/screens/userProfile.dart';
import 'package:Check_your_Treasury/services/api.dart';
import 'package:Check_your_Treasury/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomDrawer extends StatelessWidget {
  TextStyle style = GoogleFonts.montserrat(
      textStyle: TextStyle(
    fontSize: 18,
  ));
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Center(
                child: CircleAvatar(
              radius: 50,
              child: Image.asset('assets/account.png'),
            )),
            decoration: BoxDecoration(
              color: kScaffoldBgColor,
            ),
          ),
          ListTile(
            leading: Icon(Icons.person, color: Colors.cyan),
            title: Text('Profile', style: style),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => UserProfile()));
            },
          ),
          // ListTile(
          //   leading: Icon(Icons.receipt, color: Colors.orange),
          //   title: Text('Save receipts', style: style),
          //   onTap: () {
          //     Navigator.push(context,
          //         MaterialPageRoute(builder: (context) => ReceiptsList()));
          //   },
          // ),
          // ListTile(
          //   leading: Icon(Icons.money_sharp, color: Colors.green),
          //   title: Text('Plan your budget', style: style),
          //   onTap: () {
          //     Navigator.push(context,
          //         MaterialPageRoute(builder: (context) => BudgetList()));
          //   },
          // ),
          ListTile(
            leading: Icon(Icons.show_chart, color: Colors.red),
            title: Text('View reports', style: style),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ReportScreen()));
            },
          ),
          ListTile(
            leading: Icon(Icons.monetization_on, color: Colors.yellow[600]),
            title: Text('Exchange rates', style: style),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ExchangeRate()));
            },
          ),
          ListTile(
            leading: Icon(Icons.logout, color: Colors.blue),
            title: Text('Logout', style: style),
            onTap: () {
              API().logout(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.arrow_back),
            title: Text('Back', style: style),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
