import 'package:Check_your_Treasury/screens/homeScreen.dart';
import 'package:Check_your_Treasury/screens/login.dart';
import 'package:Check_your_Treasury/screens/reminders.dart';
import 'package:Check_your_Treasury/services/api.dart';
import 'package:Check_your_Treasury/utilities/constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotif =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  pref = await SharedPreferences.getInstance();

/* for local notif */

  var androidInitilize =
      new AndroidInitializationSettings('@mipmap/ic_launcher');
  var iOSinitilize = new IOSInitializationSettings();
  var initilizationsSettings =
      new InitializationSettings(androidInitilize, iOSinitilize);
  flutterLocalNotif.initialize(initilizationsSettings,
      onSelectNotification: notificationSelected);

  // int notID = 0;
  // API().getReminders().then((data) {
  //   var reminders = data;

  //   for (var rem in reminders) {
  //     DateTime checkedDate = DateTime.parse(rem["paymentDate"]);
  //     DateTime tomorrowDate = DateTime(
  //         DateTime.now().year, DateTime.now().month, DateTime.now().day + 1);
  //     print(checkedDate);
  //     print(tomorrowDate);

  //     if (checkedDate.compareTo(tomorrowDate) == 0) {
  //       print("Ok");
  //       _showReminderNotification(rem["billName"], notID);
  //       notID++;
  //     }
  //   }
  // });
  if (pref.getString("token") != null) {
    int notID = 0;
    API().getReminders().then((data) {
      var reminders = data;

      for (var rem in reminders) {
        DateTime reminderDate = DateTime.parse(rem["paymentDate"]);

        DateTime notifyDate = DateTime(
            reminderDate.year, reminderDate.month, reminderDate.day - 1);

        print(notifyDate);

        print(notifyDate.add(Duration(seconds: DateTime.now().second + 30)));

        _scheduledNotifications(notifyDate, rem["billName"], notID);

        notID++;
      }
    });
  }
  /*local notif  */

  await Firebase.initializeApp();

  await FlutterDownloader.initialize(
      debug: true // optional: set false to disable printing logs to console
      );

  runApp(MyApp());
}

Future _showReminderNotification(String billname, int id) async {
  var androidDetails = new AndroidNotificationDetails(
      "channel_id", "channel_name", "channel_description",
      icon: '@mipmap/ic_launcher', importance: Importance.Max);
  var iosDetails = new IOSNotificationDetails();
  var generalNotificationDetails =
      new NotificationDetails(androidDetails, iosDetails);

  await flutterLocalNotif.show(id, "Reminder",
      "You have $billname due tomorrow", generalNotificationDetails,
      payload: "Reminder");
}

Future _scheduledNotifications(DateTime date, String bill, int id) async {
  var scheduledNotificationDateTime = DateTime.now().add(Duration(seconds: 35));
  var androidDetails = new AndroidNotificationDetails(
      "channel_id", "channel_name", "channel_description",
      icon: '@mipmap/ic_launcher', importance: Importance.Max);
  var iosDetails = new IOSNotificationDetails();
  var generalNotificationDetails =
      new NotificationDetails(androidDetails, iosDetails);

  await flutterLocalNotif.schedule(id, "Reminder",
      "You have $bill due tomorrow", date, generalNotificationDetails,
      payload: "Reminder");
}

Future notificationSelected(String payload) async {
  // Navigator.push(
  //     context, MaterialPageRoute(builder: (context) => Reminders()));
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
