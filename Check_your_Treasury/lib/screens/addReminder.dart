import 'package:Check_your_Treasury/models/reminder.dart';
import 'package:Check_your_Treasury/screens/addTransaction.dart';
import 'package:Check_your_Treasury/screens/exchangeRates.dart';
import 'package:Check_your_Treasury/services/api.dart';
import 'package:Check_your_Treasury/utilities/decorations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddReminder extends StatefulWidget {
  @override
  _AddReminderState createState() => _AddReminderState();
}

class _AddReminderState extends State<AddReminder> {
  DateTime now = new DateTime.now();
  TextEditingController _billController = TextEditingController();
  TextEditingController _amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan[50],
      appBar: AppBar(
        title: Text('Add Reminder'),
        centerTitle: true,
        backgroundColor: Colors.cyan,
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
              Text(
                'Bill Name',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.cyan,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 70),
                child: TextField(
                  controller: _billController,
                  decoration: buildInputDecoration('Enter your bill'),
                ),
              ),
              SizedBox(height: 40),
              Text(
                'Bill Amount ($selectedCurrency)',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.cyan,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 70),
                child: TextField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  decoration: buildInputDecoration('Enter your amount'),
                ),
              ),
              SizedBox(height: 40),
              Text(
                'Date',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.cyan,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                      icon: Icon(
                        Icons.calendar_today_outlined,
                        color: Colors.cyan,
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
                    API().addReminder(reminder);
                  }
                },
                color: Colors.cyan,
                child: Text(
                  'ADD',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
