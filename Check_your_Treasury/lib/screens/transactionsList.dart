import 'package:Check_your_Treasury/screens/addTransaction.dart';
import 'package:Check_your_Treasury/screens/exchangeRates.dart';
import 'package:Check_your_Treasury/services/api.dart';
import 'package:Check_your_Treasury/utilities/bottomNavBar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionsList extends StatefulWidget {
  @override
  _TransactionsListState createState() => _TransactionsListState();
}

class _TransactionsListState extends State<TransactionsList> {
  bool _incomeClicked = false;
  bool _expenseClicked = true;
  DateTime now = DateTime.now();
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
              color: Colors.white,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment(
                    0.8, 0.0), // 10% of the width, so there are ten blinds.
                colors: [
                  const Color(0xff0983e0),
                  const Color(0xff69c6d6)
                ], // red to yellow
                tileMode:
                    TileMode.clamp, // repeats the gradient over the canvas
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              children: [
                Text(
                  'Total Income: $selectedCurrency 1000',
                  style: TextStyle(fontSize: 20),
                ),
                Text(
                  'Total Expenses: $selectedCurrency 1000',
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              margin: EdgeInsets.only(top: 15),
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                  color: Colors.white,
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

// Map incomes = {
//   "incomeList": [
//     {"Income": "Salary received", "Category": "Salary", "Amount": 10000},
//     {"Income": "Stock dividend", "Category": "Dividend", "Amount": 1000},
//     {"Income": "Rent received", "Category": "Rent", "Amount": 2000},
//     {"Income": "Reward coupon", "Category": "Others", "Amount": 500},
//   ]
// };

// Map expenses = {
//   "expenseList": [
//     {"Expense": "Eat at restaurant", "Category": "Food", "Amount": 400},
//     {"Expense": "Bought shirt", "Category": "Shopping", "Amount": 700},
//     {"Expense": "Taken taxi", "Category": "Transportation", "Amount": 800},
//     {"Expense": "Electricity bill", "Category": "Bills", "Amount": 1500},
//   ]
// };
