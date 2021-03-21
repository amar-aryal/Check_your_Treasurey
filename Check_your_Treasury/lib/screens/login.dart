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
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
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
            SizedBox(height: 15),
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
                style: TextStyle(color: Colors.cyan),
              ),
            ),
            SizedBox(height: 20),
            FlatButton(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
              onPressed: _login,
              color: Colors.blue[800],
              child: Text(
                'Login',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 15),
            Text('Do not have an account?', style: TextStyle(fontSize: 16)),
            SizedBox(height: 15),
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
    );
  }

  _login() {
    if (_userNameController.text == "" || _passwordController.text == "") {
      showMyDialog(context, "Empty fields!", "Do not leave the fieds empty");
    } else {
      API().login(context, _userNameController.text, _passwordController.text);
    }
  }
}
