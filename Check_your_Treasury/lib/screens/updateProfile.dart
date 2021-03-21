import 'dart:convert';

import 'package:Check_your_Treasury/screens/addTransaction.dart';
import 'package:Check_your_Treasury/services/api.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UpdateProfile extends StatefulWidget {
  String username;
  String email;

  UpdateProfile({this.username, this.email});
  @override
  _UpdateProfileState createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  TextEditingController _userController;
  TextEditingController _emailController;

  String profileUrl = 'http://10.0.2.2:8000/api/auth/user';

  @override
  void initState() {
    super.initState();
    _userController = TextEditingController(text: widget.username);
    _emailController = TextEditingController(text: widget.email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update profile'),
        centerTitle: true,
        backgroundColor: Colors.cyan,
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _userController,
            ),
            TextField(
              controller: _emailController,
            ),
            SizedBox(height: 30),
            FlatButton(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
              onPressed: () =>
                  _updateProfile(_userController.text, _emailController.text),
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
    );
  }

  _updateProfile(String username, String email) async {
    Map<String, String> user = {
      'username': username,
      'email': email,
    };
    http.Response response = await http.put(profileUrl,
        headers: {
          'Content-Type': "application/json",
          "Authorization": "Token " + pref.getString('token'),
        },
        body: json.encode(user));

    if (response.statusCode == 200) {
      showMyDialog(
          context, "Successfully updated!", "Your profile has been updated");
    } else {
      showMyDialog(
          context, 'Error!', 'There was some problem.Please try again');
    }
  }
}