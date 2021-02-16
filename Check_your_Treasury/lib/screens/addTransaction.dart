import 'package:Check_your_Treasury/screens/exchangeRates.dart';
import 'package:Check_your_Treasury/services/api.dart';
import 'package:Check_your_Treasury/utilities/decorations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddTransaction extends StatefulWidget {
  @override
  _AddTransactionState createState() => _AddTransactionState();
}

class _AddTransactionState extends State<AddTransaction> {
  bool _checkboxIncome = false;
  bool _checkboxExpense = false;
  String category = 'None';
  DateTime now = new DateTime.now();

  TextEditingController _transactionController = TextEditingController();
  TextEditingController _amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan[50],
      appBar: AppBar(
        title: Text('Add Transaction'),
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
                'Select Transaction Type',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.cyan,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Checkbox(
                    value: _checkboxIncome,
                    onChanged: (value) {
                      setState(() {
                        _checkboxIncome = !_checkboxIncome;
                      });
                    },
                  ),
                  Text('Income', style: TextStyle(fontSize: 16)),
                  Checkbox(
                    value: _checkboxExpense,
                    onChanged: (value) {
                      setState(() {
                        _checkboxExpense = !_checkboxExpense;
                      });
                    },
                  ),
                  Text('Expense', style: TextStyle(fontSize: 16)),
                ],
              ),
              SizedBox(height: 40),
              Text(
                'Name',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.cyan,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 70),
                child: TextField(
                  controller: _transactionController,
                  decoration: buildInputDecoration('Enter transaction name'),
                ),
              ),
              SizedBox(height: 40),
              Text('Select Category',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.cyan,
                  )),
              DropdownButton<String>(
                value: category,
                onChanged: (newValue) {
                  setState(() {
                    category = newValue;
                  });
                },
                items: ditem(),
              ),
              SizedBox(height: 40),
              Text(
                'Amount ($selectedCurrency)',
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
                'Date:',
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
                  if (_transactionController.text == "" ||
                      _amountController.text == "") {
                    _showMyDialog(context);
                  }
                  if (_checkboxIncome) {
                    API().addIncome(_transactionController.text, category,
                        double.parse(_amountController.text), DateTime.now());
                  }

                  if (_checkboxExpense) {
                    API().addExpense(_transactionController.text, category,
                        double.parse(_amountController.text), DateTime.now());
                  }
                },
                color: Colors.cyan[600],
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

List<DropdownMenuItem<String>> ditem() {
  List<DropdownMenuItem<String>> catList = [];
  for (String cat in categories) {
    DropdownMenuItem<String> item = DropdownMenuItem<String>(
      child: Text(cat),
      value: cat,
    );
    catList.add(item);
  }
  return catList;
}

List<String> categories = [
  'None',
  'Salary',
  'Transportation',
  'Entertainment',
  'Health',
  'Travel',
  'Dividends'
];

Future<void> _showMyDialog(BuildContext context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Empty fields!'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('Do not leavve the fields empty!'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Ok'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}