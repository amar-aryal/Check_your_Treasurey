import 'dart:convert';

import 'package:Check_your_Treasury/screens/addTransaction.dart';
import 'package:Check_your_Treasury/screens/exchangeRates.dart';
import 'package:Check_your_Treasury/services/api.dart';
import 'package:Check_your_Treasury/utilities/bottomNavBar.dart';
import 'package:Check_your_Treasury/utilities/customDrawer.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/files.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class TransactionsList extends StatefulWidget {
  @override
  _TransactionsListState createState() => _TransactionsListState();
}

class _TransactionsListState extends State<TransactionsList> {
  bool _incomeClicked = false;
  bool _expenseClicked = true;
  DateTime now = DateTime.now();

  Future getDailyTotal() async {
    http.Response response = await http.get(
      'http://10.0.2.2:8000/today_total?date=${DateFormat("yyyy-MM-dd").format(now)}',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan[100],
      appBar: AppBar(
        title: Text('Incomes and Expenses'),
        centerTitle: true,
        backgroundColor: Colors.cyan,
      ),
      bottomNavigationBar: BottomBar(selectedIndex: 0),
      drawer: CustomDrawer(),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                  icon: Icon(
                    Icons.calendar_today_outlined,
                    color: Colors.cyan,
                    size: 30,
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
              Text(
                DateFormat("yyyy-MM-dd").format(now),
                style: TextStyle(
                  color: Colors.blue[900],
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Container(
            width: double.infinity,
            margin: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
            padding: EdgeInsets.symmetric(
                vertical: MediaQuery.of(context).size.height * 0.04),
            decoration: BoxDecoration(
              color: Color(0xff400c99),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Expanded(
              child: FutureBuilder(
                future: getDailyTotal(),
                builder: (context, snapshot) {
                  var data = snapshot.data;
                  print(data);
                  if (snapshot.hasData) {
                    double today_total_income =
                        data["today_total_income"] == null
                            ? 0.0
                            : data["today_total_income"];
                    double today_total_expense =
                        data["today_total_expense"] == null
                            ? 0.0
                            : data["today_total_expense"];

                    return Column(
                      children: [
                        Text(
                          'Total Income: $selectedCurrency $today_total_income',
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                        Text(
                          'Total Expenses: $selectedCurrency $today_total_expense',
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ],
                    );
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              margin: EdgeInsets.only(top: 15),
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25))),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FlatButton(
                        onPressed: () {
                          setState(() {
                            _incomeClicked = true;
                            _expenseClicked = false;
                          });
                        },
                        color:
                            _incomeClicked ? Colors.cyan : Colors.transparent,
                        child: Text(
                          'Income',
                          style: TextStyle(
                              color:
                                  _incomeClicked ? Colors.white : Colors.black),
                        ),
                      ),
                      FlatButton(
                        onPressed: () {
                          setState(() {
                            _expenseClicked = true;
                            _incomeClicked = false;
                          });
                        },
                        color:
                            _expenseClicked ? Colors.cyan : Colors.transparent,
                        child: Text(
                          'Expense',
                          style: TextStyle(
                              color: _expenseClicked
                                  ? Colors.white
                                  : Colors.black),
                        ),
                      )
                    ],
                  ),
                  //passing the selected date as parameter
                  _incomeClicked ? Income(date: now) : Expense(date: now),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddTransaction()));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class Income extends StatefulWidget {
  final DateTime date;

  Income({this.date});
  @override
  _IncomeState createState() => _IncomeState();
}

class _IncomeState extends State<Income> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: API().getIncomeList(widget.date),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<dynamic> incomes = snapshot.data;
          print(incomes);

          return Expanded(
            child: ListView.builder(
              itemCount: incomes.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                  child: Container(
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
                      leading: categoryImage(incomes[index]["category"]),
                      title: Text(incomes[index]["incomename"],
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(incomes[index]["category"]),
                      trailing: Text(
                        selectedCurrency +
                            '. ' +
                            incomes[index]["amount"].toString(),
                        style: TextStyle(
                            color: Colors.green, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

class Expense extends StatefulWidget {
  final DateTime date;

  Expense({this.date});
  @override
  _ExpenseState createState() => _ExpenseState();
}

class _ExpenseState extends State<Expense> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: API().getExpenseList(widget.date),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<dynamic> expenses = snapshot.data;
          print(expenses);

          return Expanded(
            child: ListView.builder(
              itemCount: expenses.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                  child: Container(
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
                      leading: categoryImage(expenses[index]["category"]),
                      title: Text(expenses[index]["expensename"],
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(expenses[index]["category"]),
                      trailing: Text(
                        selectedCurrency +
                            '. ' +
                            expenses[index]["amount"].toString(),
                        style: TextStyle(
                            color: Colors.red, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

Image categoryImage(String category) {
  switch (category) {
    case 'Salary':
      return Image.asset('assets/salary.png');
      break;
    case 'Transportation':
      return Image.asset('assets/transportation.png');
      break;
    case 'Education':
      return Image.asset('assets/education.png');
      break;
    case 'Entertainment':
      return Image.asset('assets/entertainment.png');
      break;
    case 'Housing':
      return Image.asset('assets/housing.png');
      break;
    case 'Food':
      return Image.asset('assets/food.png');
      break;
    case 'Shopping':
      return Image.asset('assets/shopping.png');
      break;
    case 'Investment':
      return Image.asset('assets/investment.png');
      break;
    case 'Health':
      return Image.asset('assets/health.png');
      break;
    case 'Travel':
      return Image.asset('assets/travel.png');
      break;
    case 'Utility':
      return Image.asset('assets/utility.png');
      break;
    case 'Tax':
      return Image.asset('assets/tax.png');
      break;
    case 'Dividends':
      return Image.asset('assets/investment.png');
      break;
    case 'Insurance':
      return Image.asset('assets/insurance.png');
      break;
    case 'Miscellaneous':
      return Image.asset('assets/misc.png');
      break;
    default:
  }
}
