import 'dart:convert';

import 'package:Check_your_Treasury/screens/addTransaction.dart';
import 'package:Check_your_Treasury/screens/updateProfile.dart';
import 'package:Check_your_Treasury/services/api.dart';
import 'package:Check_your_Treasury/utilities/constants.dart';
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
        backgroundColor: Color(0xffede2c2),
        appBar: AppBar(
          title: Text('Profile'),
          centerTitle: true,
          backgroundColor: kPrimaryColor,
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
                      child: Stack(
                        children: [
                          Column(
                            children: [
                              Center(
                                child: Card(
                                  margin: EdgeInsets.only(
                                      top: MediaQuery.of(context).size.height *
                                          0.2),
                                  elevation: 1.5,
                                  child: Column(
                                    children: [
                                      SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.08),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 30),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.person,
                                                color: Colors.grey),
                                            SizedBox(width: 10),
                                            Text(
                                                'Username:   ${data["username"]}',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                )),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.03),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 30),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.mail,
                                                color: Colors.grey),
                                            SizedBox(width: 10),
                                            Text('Email:  ${data["email"]}',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                )),
                                          ],
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
                                              builder: (context) =>
                                                  UpdateProfile(
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
                                      SizedBox(height: 30),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Positioned(
                              top: MediaQuery.of(context).size.height * 0.1,
                              left: MediaQuery.of(context).size.width * 0.32,
                              child: Center(
                                child: CircleAvatar(
                                  radius:
                                      MediaQuery.of(context).size.height * 0.08,
                                  child: Image.asset('assets/account.png'),
                                ),
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
