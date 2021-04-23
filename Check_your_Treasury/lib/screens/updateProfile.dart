import 'dart:convert';

import 'package:Check_your_Treasury/screens/addTransaction.dart';
import 'package:Check_your_Treasury/services/api.dart';
import 'package:Check_your_Treasury/utilities/constants.dart';
import 'package:Check_your_Treasury/utilities/decorations.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
  String emailVal = '';

  TextStyle _style = GoogleFonts.montserrat(
    textStyle: TextStyle(
      fontSize: 20,
      color: kPrimaryColor,
    ),
  );

  @override
  void initState() {
    super.initState();
    _userController = TextEditingController(text: widget.username);
    _emailController = TextEditingController(text: widget.email);
  }

  @override
  void dispose() {
    _userController.dispose();
    _emailController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update profile', style: GoogleFonts.montserrat()),
        centerTitle: true,
        backgroundColor: kPrimaryColor,
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Username',
              style: _style,
            ),
            SizedBox(height: 10),
            TextField(
              controller: _userController,
              decoration: buildInputDecoration('Enter username'),
            ),
            SizedBox(height: 20),
            Text(
              'Email',
              style: _style,
            ),
            SizedBox(height: 10),
            TextField(
              controller: _emailController,
              decoration: buildInputDecoration('Enter email'),
            ),
            Text(
              emailVal,
              style: TextStyle(color: Colors.red),
            ),
            SizedBox(height: 30),
            FlatButton(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
              onPressed: () {
                if (!isEmail(_emailController.text)) {
                  setState(() {
                    emailVal = 'Invalid email';
                  });
                } else {
                  setState(() {
                    emailVal = '';
                  });
                  _updateProfile(_userController.text, _emailController.text);
                }
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
    );
  }

  _updateProfile(String username, String email) async {
    Map<String, String> user = {
      'username': username,
      'email': email,
    };
    http.Response response = await http.put(userProfileUrl,
        headers: {
          'Content-Type': "application/json",
          "Authorization": "Token " + pref.getString('token'),
        },
        body: json.encode(user));

    var responseData = json.decode(response.body);

    if (response.statusCode == 200) {
      showMyDialog(
          context, "Successfully updated!", "Your profile has been updated");
    } else if (response.statusCode == 400 &&
        responseData["username"][0] ==
            "A user with that username already exists.") {
      showMyDialog(context, 'Username error!',
          'A user with that username already exists');
    } else {
      showMyDialog(
          context, 'Error!', 'There was some problem.Please try again');
    }
  }

  bool isEmail(String string) {
    if (string == null || string.isEmpty) {
      return false;
    }

    const pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    final regExp = RegExp(pattern);

    if (!regExp.hasMatch(string)) {
      return false;
    }
    return true;
  }
}
