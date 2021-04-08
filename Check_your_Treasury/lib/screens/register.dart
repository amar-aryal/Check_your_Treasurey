import 'package:Check_your_Treasury/models/user.dart';
import 'package:Check_your_Treasury/screens/addTransaction.dart';
import 'package:Check_your_Treasury/screens/login.dart';
import 'package:Check_your_Treasury/services/api.dart';
import 'package:Check_your_Treasury/utilities/decorations.dart';
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

  String passVal = '';

  String emailVal = '';

  @override
  void dispose() {
    _userNameController.dispose();
    _passwordController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Stack(
          children: [
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
                  SizedBox(height: MediaQuery.of(context).size.height * 0.01),
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
                      decoration: buildInputDecorationWithIcon(
                          'Enter your username', Icons.person),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.008),
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: buildInputDecorationWithIcon(
                          'Enter your email', Icons.mail),
                    ),
                  ),
                  Text(
                    emailVal,
                    style: TextStyle(color: Colors.red),
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
                  Text(
                    passVal,
                    style: TextStyle(color: Colors.red),
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
                  SizedBox(height: MediaQuery.of(context).size.height * 0.009),
                  ButtonTheme(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    minWidth: MediaQuery.of(context).size.width * 0.8,
                    child: FlatButton(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      onPressed: _register,
                      color: Colors.blue[800],
                      child: Text(
                        'REGISTER',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.08),
                  Text('Already have an account?',
                      style: TextStyle(fontSize: 16)),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.007),
                  FlatButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Login()));
                    },
                    child: Text(
                      'Login',
                      style: TextStyle(fontSize: 18, color: Colors.cyan),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.048,
              left: MediaQuery.of(context).size.width * 0.40,
              child: CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.grey[200],
                  child: Icon(
                    Icons.person,
                    size: MediaQuery.of(context).size.height * 0.08,
                  )),
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
      if (!isEmail(_emailController.text)) {
        setState(() {
          emailVal = 'Invalid email';
        });
      } else if (_passwordController.text.length < 8) {
        setState(() {
          passVal = 'Password must contain at least 8 characters';
        });
      } else {
        setState(() {
          emailVal = '';
          passVal = '';
        });
        User user = User(
          username: _userNameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
        API().register(context, user);
      }
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

  bool isEmail(String string) {
    // Null or empty string is invalid
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
