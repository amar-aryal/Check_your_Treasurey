import 'package:Check_your_Treasury/screens/addReminder.dart';
import 'package:Check_your_Treasury/services/api.dart';
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
      body: FutureBuilder(
        future: API().getReminders(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<dynamic> reminders = snapshot.data;

            return ListView.builder(
              itemCount: reminders.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                  child: Container(
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
                      onTap: () {
                        setState(() {
                          API().deleteReminder(reminders[index]["id"]);
                        });
                      },
                      title: Text(reminders[index]["billName"],
                          style: TextStyle(fontSize: 16)),
                      subtitle: Text(
                        selectedCurrency +
                            '. ' +
                            reminders[index]["billAmount"].toString(),
                        style: TextStyle(
                            color: Colors.red, fontWeight: FontWeight.bold),
                      ),
                      trailing: Text(
                        reminders[index]["paymentDate"],
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return CircularProgressIndicator();
          }
        },
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
