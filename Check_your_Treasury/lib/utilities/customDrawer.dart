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
            child: Text('Drawer Header'),
            decoration: BoxDecoration(
              color: Colors.cyan[100],
            ),
          ),
          ListTile(
            leading: Icon(Icons.logout),
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
