import 'package:Check_your_Treasury/screens/addReminder.dart';
import 'package:Check_your_Treasury/utilities/bottomNavBar.dart';
import 'package:flutter/material.dart';

import 'exchangeRates.dart';

class Reminders extends StatefulWidget {
  @override
  _RemindersState createState() => _RemindersState();
}

class _RemindersState extends State<Reminders> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reminders'),
        centerTitle: true,
        backgroundColor: Colors.cyan,
      ),
      bottomNavigationBar: BottomBar(selectedIndex: 1),
      body: Container(
        child: Column(
          children: [
            SizedBox(height: 10),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceAround,
            //   children: [
            //     Text('Bill',
            //         style:
            //             TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            //     Text('Amount',
            //         style:
            //             TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            //     Text('Date',
            //         style:
            //             TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            //   ],
            // ),
            Expanded(
              child: ListView.builder(
                  itemCount: reminders["reminderList"].length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                      child: Container(
                        // padding: EdgeInsets.symmetric(vertical: 15),
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
                          // mainAxisAlignment: MainAxisAlignment.spaceAround,
                          // children: [
                          title: Text(reminders["reminderList"][index]["Bill"],
                              style: TextStyle(fontSize: 16)),
                          subtitle: Text(
                            selectedCurrency +
                                '. ' +
                                reminders["reminderList"][index]["Amount"]
                                    .toString(),
                            style: TextStyle(
                                color: Colors.red, fontWeight: FontWeight.bold),
                          ),
                          trailing: Text(
                            reminders["reminderList"][index]["Date"]
                                .toString()
                                .substring(0, 11),
                            style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold),
                          ),
                          // ],
                        ),
                      ),
                    );
                  }),
            ),
          ],
        ),
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

Map reminders = {
  "reminderList": [
    {"Bill": "Salary received", "Amount": 10000, "Date": DateTime.now()},
    {"Bill": "Stock dividend", "Amount": 1000, "Date": DateTime.now()},
    {"Bill": "Rent received", "Amount": 2000, "Date": DateTime.now()},
    {"Bill": "Reward coupon", "Amount": 500, "Date": DateTime.now()},
  ]
};
