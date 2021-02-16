import 'package:Check_your_Treasury/screens/homeScreen.dart';
import 'package:Check_your_Treasury/services/api.dart';
import 'package:Check_your_Treasury/utilities/decorations.dart';
import 'package:flutter/material.dart';

class Login extends StatelessWidget {
  TextEditingController _userNameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                obscureText: true,
              ),
            ),
            SizedBox(height: 30),
            FlatButton(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
              onPressed: () {
                API().login(context, _userNameController.text,
                    _passwordController.text);
              },
              color: Colors.blue[800],
              child: Text(
                'Login',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
