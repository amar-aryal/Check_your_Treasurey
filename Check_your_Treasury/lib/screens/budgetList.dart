import 'dart:convert';

import 'package:Check_your_Treasury/models/budget.dart';
import 'package:Check_your_Treasury/screens/addPlan.dart';
import 'package:Check_your_Treasury/screens/addTransaction.dart';
import 'package:Check_your_Treasury/services/api.dart';
import 'package:Check_your_Treasury/utilities/constants.dart';
import 'package:Check_your_Treasury/utilities/decorations.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class BudgetList extends StatefulWidget {
  @override
  _BudgetListState createState() => _BudgetListState();
}

class _BudgetListState extends State<BudgetList> {
  final String budgetUrl = 'http://192.168.1.108:8000/budget/';

  Future<dynamic> getBudgetList() async {
    http.Response response = await http.get(
      budgetUrl,
      headers: {
        'Content-Type': "application/json",
        "Authorization": "Token " + pref.getString('token'),
      },
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return data;
    }
  }

  updateBudget(Budget budget, int id) async {
    http.Response response = await http.put(budgetUrl + '$id',
        headers: {
          'Content-Type': "application/json",
          "Authorization": "Token " + pref.getString('token'),
        },
        body: budgetToJson(budget));
    print(response.statusCode);
    if (response.statusCode == 200) {
      showMyDialog(
          context, 'Successfully updated!', 'The plan has been updated');
    } else {
      showMyDialog(context, 'Update Error!',
          'The plan could not be updated. Please try again');
    }
  }

  deleteBudget(int id) async {
    http.Response response = await http.delete(
      budgetUrl + '$id',
      headers: {
        "Authorization": "Token " + pref.getString('token'),
      },
    );
    print(response.statusCode);
    if (response.statusCode == 204) {
      showMyDialog(
          context, 'Successfully deleted!', 'The plan has been deleted');
    } else {
      showMyDialog(context, 'Deletion Error!',
          'The plan could not be deleted. Please try again');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: Text('Budgeting'),
        centerTitle: true,
        backgroundColor: kPrimaryColor,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'My plans',
              style: GoogleFonts.montserrat(
                  textStyle:
                      TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: getBudgetList(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<dynamic> data = snapshot.data;
                  return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            updateDeleteBudgetForm(
                                data[index]["plan"], data[index]["id"]);
                          });
                        },
                        child: Container(
                          color: Colors.white,
                          margin:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                          padding: EdgeInsets.all(15),
                          child: IntrinsicHeight(
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius:
                                      MediaQuery.of(context).size.width * 0.06,
                                  backgroundColor: Colors.orange,
                                  child: Icon(Icons.pending_actions,
                                      color: Colors.white),
                                ),
                                SizedBox(width: 10),
                                VerticalDivider(
                                    color: Colors.orange, thickness: 2),
                                SizedBox(width: 20),
                                Flexible(
                                  child: Text(data[index]["plan"],
                                      style: GoogleFonts.montserrat(
                                        textStyle: TextStyle(
                                          fontSize: 18,
                                        ),
                                      )),
                                ),
                              ],
                            ),
                          ),
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
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddBudgetPlan()));
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Future updateDeleteBudgetForm(String plan, int id) async {
    TextEditingController _planController = TextEditingController(text: plan);
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Update/Delete budget'),
          content: Column(
            children: [
              Text(
                'Edit Your plan',
                style: TextStyle(
                  fontSize: 20,
                  color: kPrimaryColor,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: TextField(
                  maxLines: 8,
                  controller: _planController,
                  decoration: buildInputDecoration('Enter your plan'),
                ),
              ),
              SizedBox(height: 40),
              Row(
                children: [
                  FlatButton(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                    onPressed: () {
                      if (_planController.text == "") {
                        showMyDialog(context, "Empty field!",
                            "Do not leave the fields empty");
                      } else {
                        setState(() {
                          Budget budget = Budget(
                            plan: _planController.text,
                          );
                          updateBudget(budget, id);
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
                        deleteBudget(id);
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
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
