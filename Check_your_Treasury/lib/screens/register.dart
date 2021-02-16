import 'package:Check_your_Treasury/services/api.dart';
import 'package:flutter/material.dart';

class Register extends StatelessWidget {
  TextEditingController _userNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Register',
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
                decoration:
                    buildInputDecoration('Enter your username', Icons.person),
              ),
            ),
            SizedBox(height: 15),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration:
                    buildInputDecoration('Enter your email', Icons.mail),
              ),
            ),
            SizedBox(height: 15),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: TextFormField(
                controller: _passwordController,
                decoration:
                    buildInputDecoration('Enter your password', Icons.lock),
                obscureText: true,
              ),
            ),
            SizedBox(height: 30),
            FlatButton(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
              onPressed: () {
                API().register(_userNameController.text, _emailController.text,
                    _passwordController.text);
              },
              color: Colors.blue[800],
              child: Text(
                'Register',
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

  InputDecoration buildInputDecoration(String hintText, IconData icon) {
    return InputDecoration(
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(35.0),
          borderSide: BorderSide(color: Colors.grey, width: 2.0)),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(35.0),
          borderSide: BorderSide(color: Colors.grey, width: 2.0)),
      icon: Icon(
        icon,
        color: Colors.grey,
      ),
      hintText: hintText,
    );
  }
}
