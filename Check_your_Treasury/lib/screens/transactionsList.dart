import 'dart:convert';

import 'package:Check_your_Treasury/screens/addTransaction.dart';
import 'package:Check_your_Treasury/screens/exchangeRates.dart';
import 'package:Check_your_Treasury/screens/updateTransactions.dart';
import 'package:Check_your_Treasury/services/api.dart';
import 'package:Check_your_Treasury/utilities/bottomNavBar.dart';
import 'package:Check_your_Treasury/utilities/constants.dart';
import 'package:Check_your_Treasury/utilities/customDrawer.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/files.dart';
import 'package:google_fonts/google_fonts.dart';
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
      'http://192.168.1.108:8000/today_total?date=${DateFormat("yyyy-MM-dd").format(now)}',
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
      backgroundColor: Color(0xffede2c2),
      appBar: AppBar(
        title: Text('Incomes and Expenses'),
        centerTitle: true,
        backgroundColor: kPrimaryColor,
      ),
      bottomNavigationBar: BottomBar(selectedIndex: 0),
      drawer: CustomDrawer(),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            margin: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
            padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width * 0.05,
                right: MediaQuery.of(context).size.width * 0.05,
                bottom: MediaQuery.of(context).size.height * 0.05),
            decoration: BoxDecoration(
              color: Colors.white,
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                                icon: Icon(
                                  Icons.calendar_today_outlined,
                                  color: kPrimaryColor,
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
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.03),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                SizedBox(width: 5),
                                Text(
                                  'Total Income',
                                  style: GoogleFonts.montserrat(
                                      textStyle: TextStyle(
                                    fontSize: 18,
                                  )),
                                ),
                              ],
                            ),
                            Text(
                              '$selectedCurrency $today_total_income',
                              style: GoogleFonts.montserrat(
                                  textStyle: TextStyle(
                                fontSize: 18,
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              )),
                            ),
                          ],
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.03),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                SizedBox(width: 5),
                                Text(
                                  'Total Expenses',
                                  style: GoogleFonts.montserrat(
                                    textStyle: TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              '$selectedCurrency $today_total_expense',
                              style: GoogleFonts.montserrat(
                                textStyle: TextStyle(
                                  fontSize: 18,
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
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
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(35),
                      topRight: Radius.circular(35))),
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
                            _incomeClicked ? kPrimaryColor : Colors.transparent,
                        child: Text(
                          'Income',
                          style: TextStyle(
                              fontSize: 20,
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
                        color: _expenseClicked
                            ? kPrimaryColor
                            : Colors.transparent,
                        child: Text(
                          'Expense',
                          style: TextStyle(
                              fontSize: 20,
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
                      onTap: () {
                        setState(() {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UpdateDeleteIncome(
                                incomename: incomes[index]["incomename"],
                                category: incomes[index]["category"],
                                amount: incomes[index]["amount"],
                                date: widget.date,
                                id: incomes[index]["id"],
                              ),
                            ),
                          );
                        });
                      },
                      leading: categoryImage(incomes[index]["category"]),
                      title: Text(incomes[index]["incomename"],
                          style: GoogleFonts.montserrat(
                              textStyle:
                                  TextStyle(fontWeight: FontWeight.bold))),
                      subtitle: Text(incomes[index]["category"]),
                      trailing: Text(
                        selectedCurrency +
                            '. ' +
                            incomes[index]["amount"].toString(),
                        style: GoogleFonts.montserrat(
                            textStyle: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold)),
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
                      onTap: () {
                        setState(() {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UpdateDeleteExpense(
                                expensename: expenses[index]["expensename"],
                                category: expenses[index]["category"],
                                amount: expenses[index]["amount"],
                                date: widget.date,
                                id: expenses[index]["id"],
                              ),
                            ),
                          );
                        });
                      },
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
      return Image.asset('assets/house.png');
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
      return Image.asset('assets/misc.png');
  }
}
