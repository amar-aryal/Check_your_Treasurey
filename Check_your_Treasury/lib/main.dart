import 'package:Check_your_Treasury/screens/homeScreen.dart';
import 'package:Check_your_Treasury/screens/login.dart';
import 'package:Check_your_Treasury/screens/receiptAdd.dart';
import 'package:Check_your_Treasury/screens/reminders.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          buttonTheme: ButtonThemeData(
            buttonColor: Colors.cyan,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          floatingActionButtonTheme:
              FloatingActionButtonThemeData(backgroundColor: Colors.cyan)),
      home: Login(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomeScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Center(
            child: Padding(
              padding: EdgeInsets.all(15.0),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.15,
                child: Image.asset('assets/budget.png'),
              ),
            ),
          ),
          Text(
            'Your budgeting tool',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          CircularProgressIndicator(),
        ],
      ),
    );
  }
}
