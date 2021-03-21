import 'package:Check_your_Treasury/screens/budgetList.dart';
import 'package:Check_your_Treasury/screens/receiptAdd.dart';
import 'package:Check_your_Treasury/screens/reportScreen.dart';
import 'package:Check_your_Treasury/screens/userProfile.dart';
import 'package:Check_your_Treasury/services/api.dart';
import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
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
              radius: 30,
              child: Icon(Icons.person),
            )),
            decoration: BoxDecoration(
              color: Colors.cyan[100],
            ),
          ),
          ListTile(
            leading: Icon(Icons.person, color: Colors.cyan),
            title: Text('Profile'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => UserProfile()));
            },
          ),
          ListTile(
            leading: Icon(Icons.receipt, color: Colors.orange),
            title: Text('Save receipts'),
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Receipt()));
            },
          ),
          ListTile(
            leading: Icon(Icons.money_sharp, color: Colors.green),
            title: Text('Plan your budget'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => BudgetList()));
            },
          ),
          ListTile(
            leading: Icon(Icons.show_chart, color: Colors.red),
            title: Text('View reports'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ReportScreen()));
            },
          ),
          ListTile(
            leading: Icon(Icons.logout, color: Colors.blue),
            title: Text('Logout'),
            onTap: () {
              API().logout(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.arrow_back),
            title: Text('Back'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
