import 'package:Check_your_Treasury/models/reminder.dart';
import 'package:Check_your_Treasury/screens/addReminder.dart';
import 'package:Check_your_Treasury/services/api.dart';
import 'package:Check_your_Treasury/utilities/bottomNavBar.dart';
import 'package:Check_your_Treasury/utilities/constants.dart';
import 'package:Check_your_Treasury/utilities/customDrawer.dart';
import 'package:Check_your_Treasury/utilities/decorations.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'addTransaction.dart';
import 'exchangeRates.dart';

class Reminders extends StatefulWidget {
  @override
  _RemindersState createState() => _RemindersState();
}

class _RemindersState extends State<Reminders> {
  bool isDone = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reminders'),
        centerTitle: true,
        backgroundColor: kPrimaryColor,
      ),
      bottomNavigationBar: BottomBar(selectedIndex: 1),
      drawer: CustomDrawer(),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future: API().getReminders(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<dynamic> reminders = snapshot.data;

                  return ListView.builder(
                    itemCount: reminders.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                        child: Column(
                          children: [
                            Container(
                              height: MediaQuery.of(context).size.height * 0.1,
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 1.0,
                                      spreadRadius: 1.0,
                                      offset: Offset(
                                        1.0,
                                        2.0,
                                      ),
                                    ),
                                  ],
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15)),
                              child: ListTile(
                                leading: Icon(
                                  Icons.circle_notifications,
                                  color: Colors.orange,
                                  size: MediaQuery.of(context).size.width * 0.1,
                                ),
                                onTap: () {
                                  setState(() {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            UpdateDeleteReminder(
                                          reminder: reminders[index]
                                              ["billName"],
                                          amount: reminders[index]
                                              ["billAmount"],
                                          date: DateTime.parse(
                                              reminders[index]["paymentDate"]),
                                          id: reminders[index]["id"],
                                        ),
                                      ),
                                    );
                                  });
                                },
                                title: Text(reminders[index]["billName"],
                                    style: GoogleFonts.montserrat(
                                        textStyle: TextStyle(fontSize: 16))),
                                subtitle: Text(
                                  '$selectedCurrency. ${reminders[index]["billAmount"]}',
                                  style: GoogleFonts.montserrat(
                                    textStyle: TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                trailing: Text(
                                  reminders[index]["paymentDate"],
                                  style: GoogleFonts.montserrat(
                                    textStyle: TextStyle(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.01),
                          ],
                        ),
                      );
                    },
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddReminder()));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class UpdateDeleteReminder extends StatefulWidget {
  final String reminder;
  final double amount;
  final DateTime date;
  final int id;

  const UpdateDeleteReminder({this.reminder, this.amount, this.date, this.id});
  @override
  _UpdateDeleteReminderState createState() => _UpdateDeleteReminderState();
}

class _UpdateDeleteReminderState extends State<UpdateDeleteReminder> {
  TextEditingController _reminderController;

  TextEditingController _amountController;

  DateTime now;

  updateReminder(Reminder reminder, int id) async {
    http.Response response = await http.put(url + 'reminders/$id/',
        headers: {
          'Content-Type': "application/json",
          "Authorization": "Token " + pref.getString('token'),
        },
        body: reminderToJson(reminder));
    print(response.statusCode);
    if (response.statusCode == 200) {
      showMyDialog(
          context, 'Successfully updated!', 'The reminder has been updated');
    } else {
      showMyDialog(context, 'Update Error!',
          'The reminder could not be updated. Please try again');
    }
  }

  deleteReminder(int id) async {
    http.Response response = await http.delete(
      url + 'reminders/$id/',
      headers: {
        "Authorization": "Token " + pref.getString('token'),
      },
    );
    print(response.statusCode);
    if (response.statusCode == 204) {
      showMyDialog(
          context, 'Successfully deleted!', 'The reminder has been deleted');
    } else {
      showMyDialog(context, 'Deletion Error!',
          'The reminder could not be deleted. Please try again');
    }
  }

  @override
  void initState() {
    super.initState();
    _reminderController = TextEditingController(text: widget.reminder);
    _amountController = TextEditingController(text: widget.amount.toString());
    now = widget.date;
  }

  @override
  void dispose() {
    _reminderController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update reminder'),
        backgroundColor: kPrimaryColor,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Bill Name',
            style: TextStyle(
              fontSize: 20,
              color: kPrimaryColor,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: TextField(
              controller: _reminderController,
              decoration: buildInputDecoration('Enter your reminder'),
            ),
          ),
          SizedBox(height: 15),
          Text(
            'Bill Amount',
            style: TextStyle(
              fontSize: 20,
              color: kPrimaryColor,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: TextField(
              controller: _amountController,
              decoration: buildInputDecoration('Enter your amount'),
            ),
          ),
          SizedBox(height: 15),
          Text(
            'Date',
            style: TextStyle(
              fontSize: 20,
              color: kPrimaryColor,
            ),
          ),
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
                        initialDate: widget.date,
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
          SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FlatButton(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                onPressed: () {
                  if (_reminderController.text == "" ||
                      _amountController.text == "") {
                    showMyDialog(context, "Empty field!",
                        "Do not leave the fields empty");
                  } else {
                    setState(() {
                      Reminder reminder = Reminder(
                        billName: _reminderController.text,
                        billAmount: double.parse(
                          _amountController.text,
                        ),
                        paymentDate: now,
                      );
                      updateReminder(reminder, widget.id);
                    });
                  }
                },
                color: kPrimaryColor,
                child: Text(
                  'Update',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(width: 15),
              FlatButton(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                onPressed: () {
                  setState(() {
                    deleteReminder(widget.id);
                  });
                },
                color: Colors.red,
                child: Text(
                  'Delete',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
