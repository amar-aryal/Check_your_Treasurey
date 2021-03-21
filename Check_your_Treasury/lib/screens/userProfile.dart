import 'dart:convert';

import 'package:Check_your_Treasury/screens/addTransaction.dart';
import 'package:Check_your_Treasury/screens/updateProfile.dart';
import 'package:Check_your_Treasury/services/api.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/files.dart';

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
                          Center(
                              child: CircleAvatar(
                            radius: MediaQuery.of(context).size.height * 0.08,
                            child: Icon(
                              Icons.person,
                              size: MediaQuery.of(context).size.height * 0.06,
                            ),
                          )),
                          SizedBox(height: 30),
                          Card(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 10),
                              child: Text('Username:   ${data["username"]}',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  )),
                            ),
                          ),
                          SizedBox(height: 15),
                          Card(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 10),
                              child: Text('Email:  ${data["email"]}',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  )),
                            ),
                          ),
                          SizedBox(height: 30),
                          FlatButton(
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 30),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UpdateProfile(
                                    username: data["username"],
                                    email: data["email"],
                                  ),
                                ),
                              );
                            },
                            color: Colors.blue[800],
                            child: Text(
                              'Update profile',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
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
