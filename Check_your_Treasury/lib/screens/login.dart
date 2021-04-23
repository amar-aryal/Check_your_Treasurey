import 'dart:convert';

import 'package:Check_your_Treasury/screens/addTransaction.dart';
import 'package:http/http.dart' as http;
import 'package:Check_your_Treasury/screens/register.dart';
import 'package:Check_your_Treasury/screens/selectCurrency.dart';
import 'package:Check_your_Treasury/services/api.dart';
import 'package:Check_your_Treasury/utilities/decorations.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController _userNameController = TextEditingController();

  TextEditingController _passwordController = TextEditingController();

  bool _obscure = true;

  @override
  void dispose() {
    _userNameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff4242b3),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Stack(children: [
          Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30))),
            margin: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.14,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Divider(),
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: TextFormField(
                    controller: _userNameController,
                    decoration: buildInputDecorationWithIcon(
                        'Enter your username', Icons.person),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.008),
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: TextFormField(
                    controller: _passwordController,
                    decoration: buildInputDecorationWithIcon(
                        'Enter your password', Icons.lock),
                    obscureText: _obscure,
                  ),
                ),
                FlatButton(
                  onPressed: () {
                    setState(() {
                      _obscure ? _obscure = false : _obscure = true;
                    });
                  },
                  child: Text(
                    _obscure ? 'Show password' : 'Hide password',
                    style: TextStyle(color: Color(0xff4242b3), fontSize: 18),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.008),
                ButtonTheme(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  minWidth: MediaQuery.of(context).size.width * 0.8,
                  child: FlatButton(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    onPressed: _login,
                    color: Color(0xff4242b3),
                    child: Text(
                      'LOGIN',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.09),
                Text('Do not have an account?', style: TextStyle(fontSize: 16)),
                SizedBox(height: MediaQuery.of(context).size.height * 0.008),
                FlatButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Register()));
                  },
                  child: Text(
                    'Register',
                    style: TextStyle(fontSize: 18, color: Color(0xff4242b3)),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.052,
            left: MediaQuery.of(context).size.width * 0.40,
            child: CircleAvatar(
                radius: 40,
                backgroundColor: Colors.grey[300],
                child: Icon(
                  Icons.person,
                  color: Color(0xff4242b3),
                  size: MediaQuery.of(context).size.height * 0.08,
                )),
          ),
        ]),
      ),
    );
  }

  login(BuildContext context, String username, String password) async {
    pref = await SharedPreferences.getInstance();
    String token;
    Map<String, String> user = {
      'username': username,
      'password': password,
    };
    http.Response response = await http.post(
      loginUrl,
      headers: {
        'Content-Type': "application/json",
      },
      body: json.encode(user),
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      print(response.body);
      token = data["token"];
      print(token);
      pref.setString("token", token);

      Navigator.pushAndRemoveUntil(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => SelectCurrency(),
            transitionDuration: Duration(seconds: 0),
          ),
          (Route<dynamic> route) => false);
    } else if (response.statusCode == 400) {
      showMyDialog(context, 'Incorrect username/password!',
          'Your username or password was incorrect');
    } else {
      showMyDialog(
          context, 'Error!', 'There was some problem.Please try again');
    }
  }

  _login() {
    if (_userNameController.text == "" || _passwordController.text == "") {
      showMyDialog(context, "Empty fields!", "Do not leave the fields empty");
    } else {
      login(context, _userNameController.text, _passwordController.text);
    }
  }
}
