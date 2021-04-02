import 'package:Check_your_Treasury/models/expense.dart';
import 'package:Check_your_Treasury/models/income.dart';
import 'package:Check_your_Treasury/screens/addTransaction.dart';
import 'package:Check_your_Treasury/services/api.dart';
import 'package:Check_your_Treasury/utilities/constants.dart';
import 'package:Check_your_Treasury/utilities/decorations.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class UpdateDeleteExpense extends StatefulWidget {
  final String expensename;
  final String category;
  final double amount;
  final DateTime date;
  final int id;

  const UpdateDeleteExpense(
      {this.expensename, this.category, this.amount, this.date, this.id});
  @override
  _UpdateDeleteExpenseState createState() => _UpdateDeleteExpenseState();
}

class _UpdateDeleteExpenseState extends State<UpdateDeleteExpense> {
  TextEditingController _expenseController;

  TextEditingController _amountController;

  String cat;

  DateTime now;

  updateExpense(Expense expense, int id) async {
    http.Response response = await http.put(url + 'expenses/$id/',
        headers: {
          'Content-Type': "application/json",
          "Authorization": "Token " + pref.getString('token'),
        },
        body: expenseToJson(expense));
    print(response.statusCode);
    if (response.statusCode == 200) {
      showMyDialog(
          context, 'Successfully updated!', 'The expense has been updated');
    } else {
      showMyDialog(context, 'Update Error!',
          'The expense could not be updated. Please try again');
    }
  }

  deleteExpense(int id) async {
    http.Response response = await http.delete(
      url + 'expenses/$id/',
      headers: {
        "Authorization": "Token " + pref.getString('token'),
      },
    );
    print(response.statusCode);
    if (response.statusCode == 204) {
      showMyDialog(
          context, 'Successfully deleted!', 'The expense has been deleted');
    } else {
      showMyDialog(context, 'Deletion Error!',
          'The expense could not be deleted. Please try again');
    }
  }

  @override
  void initState() {
    super.initState();
    _expenseController = TextEditingController(text: widget.expensename);
    _amountController = TextEditingController(text: widget.amount.toString());
    cat = widget.category;
    now = widget.date;

    print(widget.category);
  }

  @override
  void dispose() {
    _expenseController.dispose();
    _amountController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Update transaction'),
        backgroundColor: kPrimaryColor,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Name',
            style: TextStyle(
              fontSize: 20,
              color: kPrimaryColor,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: TextField(
              controller: _expenseController,
              decoration: buildInputDecoration('Enter your reminder'),
            ),
          ),
          SizedBox(height: 15),
          Text('Select Category',
              style: TextStyle(
                fontSize: 20,
                color: kPrimaryColor,
              )),
          DropdownButton<String>(
            value: cat,
            onChanged: (newValue) {
              setState(() {
                cat = newValue;
              });
            },
            items: ditem(),
          ),
          Text(
            'Amount',
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
          SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FlatButton(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                onPressed: () {
                  if (_expenseController.text == "" ||
                      _amountController.text == "") {
                    showMyDialog(context, "Empty field!",
                        "Do not leave the fields empty");
                  } else {
                    setState(() {
                      Expense expense = Expense(
                        expensename: _expenseController.text,
                        category: cat,
                        amount: double.parse(
                          _amountController.text,
                        ),
                        date: now,
                      );
                      updateExpense(expense, widget.id);
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
                    deleteExpense(widget.id);
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

class UpdateDeleteIncome extends StatefulWidget {
  final String incomename;
  final String category;
  final double amount;
  final DateTime date;
  final int id;

  const UpdateDeleteIncome(
      {this.incomename, this.category, this.amount, this.date, this.id});
  @override
  _UpdateDeleteIncomeState createState() => _UpdateDeleteIncomeState();
}

class _UpdateDeleteIncomeState extends State<UpdateDeleteIncome> {
  TextEditingController _incomeController;

  TextEditingController _amountController;

  String cat;

  DateTime now;

  updateIncome(Income income, int id) async {
    http.Response response = await http.put(url + 'incomes/$id/',
        headers: {
          'Content-Type': "application/json",
          "Authorization": "Token " + pref.getString('token'),
        },
        body: incomeToJson(income));
    print(response.statusCode);
    if (response.statusCode == 200) {
      showMyDialog(
          context, 'Successfully updated!', 'The income has been updated');
    } else {
      showMyDialog(context, 'Update Error!',
          'The income could not be updated. Please try again');
    }
  }

  deleteIncome(int id) async {
    http.Response response = await http.delete(
      url + 'incomes/$id/',
      headers: {
        "Authorization": "Token " + pref.getString('token'),
      },
    );
    print(response.statusCode);
    if (response.statusCode == 204) {
      showMyDialog(
          context, 'Successfully deleted!', 'The income has been deleted');
    } else {
      showMyDialog(context, 'Deletion Error!',
          'The income could not be deleted. Please try again');
    }
  }

  @override
  void initState() {
    super.initState();
    _incomeController = TextEditingController(text: widget.incomename);
    _amountController = TextEditingController(text: widget.amount.toString());
    cat = widget.category;
    now = widget.date;

    print(widget.category);
  }

  @override
  void dispose() {
    _incomeController.dispose();
    _amountController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Update transaction'),
        backgroundColor: kPrimaryColor,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Name',
            style: TextStyle(
              fontSize: 20,
              color: kPrimaryColor,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: TextField(
              controller: _incomeController,
              decoration: buildInputDecoration('Enter your reminder'),
            ),
          ),
          SizedBox(height: 15),
          Text('Select Category',
              style: TextStyle(
                fontSize: 20,
                color: kPrimaryColor,
              )),
          DropdownButton<String>(
            value: cat,
            onChanged: (newValue) {
              setState(() {
                cat = newValue;
              });
            },
            items: ditem(),
          ),
          Text(
            'Amount',
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
          SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FlatButton(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                onPressed: () {
                  if (_incomeController.text == "" ||
                      _amountController.text == "") {
                    showMyDialog(context, "Empty field!",
                        "Do not leave the fields empty");
                  } else {
                    setState(() {
                      Income income = Income(
                        incomename: _incomeController.text,
                        category: cat,
                        amount: double.parse(
                          _amountController.text,
                        ),
                        date: now,
                      );
                      updateIncome(income, widget.id);
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
                    deleteIncome(widget.id);
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
