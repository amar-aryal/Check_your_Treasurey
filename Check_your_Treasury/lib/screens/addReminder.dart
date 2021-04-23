import 'package:Check_your_Treasury/models/reminder.dart';
import 'package:Check_your_Treasury/screens/addTransaction.dart';
import 'package:Check_your_Treasury/screens/exchangeRates.dart';
import 'package:Check_your_Treasury/services/api.dart';
import 'package:Check_your_Treasury/utilities/constants.dart';
import 'package:Check_your_Treasury/utilities/decorations.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotif =
    FlutterLocalNotificationsPlugin();

class AddReminder extends StatefulWidget {
  @override
  _AddReminderState createState() => _AddReminderState();
}

class _AddReminderState extends State<AddReminder> {
  DateTime now = new DateTime.now();
  TextEditingController _billController = TextEditingController();
  TextEditingController _amountController = TextEditingController();

  TextStyle _style = GoogleFonts.montserrat(
    textStyle: TextStyle(
      fontSize: 20,
      color: kPrimaryColor,
    ),
  );

  @override
  void initState() {
    super.initState();
    /* for local notif */

    var androidInitilize =
        new AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOSinitilize = new IOSInitializationSettings();
    var initilizationsSettings =
        new InitializationSettings(androidInitilize, iOSinitilize);
    flutterLocalNotif.initialize(
      initilizationsSettings,
    );

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

    /*local notif  */
  }

  @override
  void dispose() {
    _billController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future _scheduledNotifications(DateTime date, String bill, int id) async {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kScaffoldBgColor,
      appBar: AppBar(
        title: Text('Add Reminder', style: GoogleFonts.montserrat()),
        centerTitle: true,
        backgroundColor: kPrimaryColor,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).size.height * 0.1,
              horizontal: 18),
          padding: EdgeInsets.symmetric(vertical: 15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            children: [
              SizedBox(height: 15),
              Text('Bill Name', style: _style),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 70),
                child: TextField(
                  controller: _billController,
                  decoration: buildInputDecoration('Enter your bill'),
                ),
              ),
              SizedBox(height: 40),
              Text('Bill Amount ($selectedCurrency)', style: _style),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 70),
                child: TextField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  decoration: buildInputDecoration('Enter your amount'),
                ),
              ),
              SizedBox(height: 40),
              Text('Date', style: _style),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                      icon: Icon(
                        Icons.calendar_today_outlined,
                        color: kPrimaryColor,
                      ),
                      onPressed: () async {
                        DateTime selectedDate = await showDatePicker(
                            context: context,
                            initialDate: now,
                            firstDate: DateTime(2015, 8),
                            lastDate: DateTime(2100, 8));
                        setState(() {
                          if (selectedDate != null) {
                            now = selectedDate;
                            print(selectedDate);
                          }
                        });
                      }),
                  Text(DateFormat("yyyy-MM-dd").format(now)),
                ],
              ),
              SizedBox(height: 15),
              FlatButton(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                onPressed: () {
                  if (_billController.text == "" ||
                      _amountController.text == "") {
                    showMyDialog(context, "Empty fields!",
                        "Do not leave the fields empty");
                  } else {
                    Reminder reminder = Reminder(
                        billName: _billController.text,
                        billAmount: double.parse(_amountController.text),
                        paymentDate: now);
                    API().addReminder(context, reminder);

                    if (pref.getString("token") != null) {
                      int notID = 0;
                      API().getReminders().then((data) {
                        var reminders = data;
                        print(reminders);
                        for (var rem in reminders) {
                          DateTime reminderDate =
                              DateTime.parse(rem["paymentDate"]);

                          DateTime notifyDate = DateTime(reminderDate.year,
                              reminderDate.month, reminderDate.day - 1);

                          _scheduledNotifications(
                              notifyDate, rem["billName"], notID);

                          notID++;
                        }
                      });
                    }
                  }
                },
                color: kPrimaryColor,
                child: Text(
                  'ADD',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
