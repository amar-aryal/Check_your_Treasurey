import 'package:Check_your_Treasury/screens/addTransaction.dart';
import 'package:Check_your_Treasury/screens/login.dart';
import 'package:Check_your_Treasury/services/api.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController _userNameController = TextEditingController();

  TextEditingController _emailController = TextEditingController();

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
              onPressed: _register,
              color: Colors.blue[800],
              child: Text(
                'Register',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 15),
            Text('Already have an account?', style: TextStyle(fontSize: 16)),
            SizedBox(height: 15),
            FlatButton(
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Login()));
              },
              child: Text(
                'Login',
                style: TextStyle(fontSize: 18, color: Colors.cyan),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _register() {
    if (_userNameController.text == "" ||
        _emailController.text == "" ||
        _passwordController.text == "") {
      showMyDialog(context, "Empty fields!", "Do not leave the fieds empty");
    } else {
      API().register(context, _userNameController.text, _emailController.text,
          _passwordController.text);
    }
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
