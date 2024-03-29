import 'package:Check_your_Treasury/models/expense.dart';
import 'package:Check_your_Treasury/models/income.dart';
import 'package:Check_your_Treasury/screens/exchangeRates.dart';
import 'package:Check_your_Treasury/services/api.dart';
import 'package:Check_your_Treasury/utilities/constants.dart';
import 'package:Check_your_Treasury/utilities/decorations.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class AddTransaction extends StatefulWidget {
  @override
  _AddTransactionState createState() => _AddTransactionState();
}

class _AddTransactionState extends State<AddTransaction> {
  bool _checkboxIncome = false;
  bool _checkboxExpense = false;
  String category = 'Salary';
  DateTime now = new DateTime.now();
  TextStyle _style = GoogleFonts.montserrat(
    textStyle: TextStyle(
      fontSize: 20,
      color: kPrimaryColor,
    ),
  );

  TextEditingController _transactionController = TextEditingController();
  TextEditingController _amountController = TextEditingController();

  @override
  void dispose() {
    _transactionController.dispose();
    _amountController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kScaffoldBgColor,
      appBar: AppBar(
        title: Text('Add Transaction', style: GoogleFonts.montserrat()),
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
              Text('Select Transaction Type', style: _style),
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
              SizedBox(height: 20),
              Text('Name', style: _style),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 70),
                child: TextField(
                  controller: _transactionController,
                  decoration: buildInputDecoration('Enter transaction name'),
                ),
              ),
              SizedBox(height: 20),
              Text('Select Category',
                  style: TextStyle(
                    fontSize: 20,
                    color: kPrimaryColor,
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
              SizedBox(height: 20),
              Text('Amount ($selectedCurrency)', style: _style),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 70),
                child: TextField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  decoration: buildInputDecoration('Enter your amount'),
                ),
              ),
              SizedBox(height: 20),
              Text('Date:', style: _style),
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
                  if (_transactionController.text == "" ||
                      _amountController.text == "") {
                    showMyDialog(context, "Empty fields!",
                        "Do not leave the fields empty");
                  }
                  if (_checkboxIncome) {
                    Income income = Income(
                        incomename: _transactionController.text,
                        category: category,
                        amount: double.parse(_amountController.text),
                        date: DateTime.now());
                    API().addIncome(context, income);
                  }

                  if (_checkboxExpense) {
                    Expense expense = Expense(
                        expensename: _transactionController.text,
                        category: category,
                        amount: double.parse(_amountController.text),
                        date: DateTime.now());
                    API().addExpense(context, expense);
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
  'Salary',
  'Transportation',
  'Education',
  'Entertainment',
  'Housing',
  'Food',
  'Shopping',
  'Investment',
  'Health',
  'Travel',
  'Utility',
  'Tax',
  'Dividends',
  'Insurance',
  'Miscellaneous',
];

Future<void> showMyDialog(
    BuildContext context, String title, String message) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(message),
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
