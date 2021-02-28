import 'package:Check_your_Treasury/services/api.dart';
import 'package:flutter/material.dart';

class UserProfile extends StatefulWidget {
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.cyan[50],
        appBar: AppBar(
          title: Text('Profile'),
          centerTitle: true,
          backgroundColor: Colors.cyan,
        ),
        body: FutureBuilder(
          future: API().getUserProfile(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var data = snapshot.data;
              print(data);
              return Column(
                children: [
                  Expanded(
                    child: Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      child: Column(
                        children: [
                          Text('Username:   ${data["username"]}',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              )),
                          Text('Email:  ${data["email"]}',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              )),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ));
  }
}
