import 'package:Check_your_Treasury/models/budget.dart';
import 'package:Check_your_Treasury/screens/addTransaction.dart';
import 'package:Check_your_Treasury/services/api.dart';
import 'package:Check_your_Treasury/utilities/constants.dart';
import 'package:Check_your_Treasury/utilities/decorations.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddBudgetPlan extends StatefulWidget {
  @override
  _AddBudgetPlanState createState() => _AddBudgetPlanState();
}

class _AddBudgetPlanState extends State<AddBudgetPlan> {
  String budgetUrl = 'http://192.168.1.108:8000/budget/';

  TextEditingController _planController = TextEditingController();

  addBudget(Budget budget) async {
    http.Response response = await http.post(budgetUrl,
        headers: {
          'Content-Type': "application/json",
          "Authorization": "Token " + pref.getString('token'),
        },
        body: budgetToJson(budget));
    print(response.statusCode);
    if (response.statusCode == 201) {
      showMyDialog(context, 'Successfully added!', 'New plan has been added');
      _planController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Budget'),
        centerTitle: true,
        backgroundColor: kPrimaryColor,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).size.height * 0.07,
              horizontal: 5),
          padding: EdgeInsets.symmetric(vertical: 15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            children: [
              Text(
                'Your plan',
                style: TextStyle(
                  fontSize: 20,
                  color: kPrimaryColor,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: TextField(
                  maxLines: 15,
                  controller: _planController,
                  decoration: buildInputDecoration('Enter your plan'),
                ),
              ),
              SizedBox(height: 40),
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
                      addBudget(budget);
                    });
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
