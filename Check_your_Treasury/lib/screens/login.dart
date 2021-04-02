import 'package:Check_your_Treasury/screens/addTransaction.dart';
import 'package:Check_your_Treasury/screens/homeScreen.dart';
import 'package:Check_your_Treasury/screens/register.dart';
import 'package:Check_your_Treasury/services/api.dart';
import 'package:Check_your_Treasury/utilities/decorations.dart';
import 'package:flutter/material.dart';

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
      backgroundColor: Colors.blue,
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
                    style: TextStyle(color: Colors.cyan, fontSize: 18),
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
                    color: Colors.blue[800],
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
                    style: TextStyle(fontSize: 18, color: Colors.cyan),
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
                  size: MediaQuery.of(context).size.height * 0.08,
                )),
          ),
        ]),
      ),
    );
  }

  _login() {
    if (_userNameController.text == "" || _passwordController.text == "") {
      showMyDialog(context, "Empty fields!", "Do not leave the fields empty");
    } else {
      API().login(context, _userNameController.text, _passwordController.text);
    }
  }
}
