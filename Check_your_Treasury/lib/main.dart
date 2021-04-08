import 'package:Check_your_Treasury/screens/exchangeRates.dart';
import 'package:Check_your_Treasury/screens/homeScreen.dart';
import 'package:Check_your_Treasury/screens/login.dart';
import 'package:Check_your_Treasury/screens/reminders.dart';
import 'package:Check_your_Treasury/services/api.dart';
import 'package:Check_your_Treasury/utilities/constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  pref = await SharedPreferences.getInstance();

  await Firebase.initializeApp();

  await FlutterDownloader.initialize(
      debug: true // optional: set false to disable printing logs to console
      );

  runApp(MyApp());
}

// Future _showReminderNotification(String billname, int id) async {
//   var androidDetails = new AndroidNotificationDetails(
//       "channel_id", "channel_name", "channel_description",
//       icon: '@mipmap/ic_launcher', importance: Importance.Max);
//   var iosDetails = new IOSNotificationDetails();
//   var generalNotificationDetails =
//       new NotificationDetails(androidDetails, iosDetails);

//   await flutterLocalNotif.show(id, "Reminder",
//       "You have $billname due tomorrow", generalNotificationDetails,
//       payload: "Reminder");
// }

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
          textTheme: TextTheme(bodyText1: GoogleFonts.roboto()),
          buttonTheme: ButtonThemeData(
            buttonColor: Colors.cyan,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          floatingActionButtonTheme:
              FloatingActionButtonThemeData(backgroundColor: kPrimaryColor)),
      home: pref.getString("token") == null ? Login() : HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
