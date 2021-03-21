import 'package:Check_your_Treasury/screens/homeScreen.dart';
import 'package:Check_your_Treasury/screens/login.dart';
import 'package:Check_your_Treasury/services/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  pref = await SharedPreferences.getInstance();

  await FlutterDownloader.initialize(
      debug: true // optional: set false to disable printing logs to console
      );

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

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
      home: pref.getString("token") == null ? Login() : HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
