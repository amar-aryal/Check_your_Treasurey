import 'dart:convert';

import 'package:Check_your_Treasury/screens/exchangeRates.dart';
import 'package:Check_your_Treasury/services/api.dart' as api;
import 'package:Check_your_Treasury/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

import 'package:pie_chart/pie_chart.dart';
import 'package:Check_your_Treasury/screens/createPdf.dart';
import 'package:Check_your_Treasury/screens/transactionsList.dart';

void main() {
  runApp(MaterialApp(home: ReportScreen()));
}

class ReportScreen extends StatefulWidget {
  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  Future getReportData() async {
    http.Response response = await http.get(
      api.url + 'monthly_total/?year=${now.year}&month=${now.month}',
      headers: {
        'Content-Type': "application/json",
        "Authorization": "Token " + api.pref.getString('token'),
      },
    );
    print("Code" + response.statusCode.toString());

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return data;
    } else {
      print('Error');
    }
  }

  List<Color> colorList = [
    Colors.red,
    Colors.lightGreen,
    Colors.blue,
    Colors.yellow,
    Colors.orange,
    Colors.pink,
    Colors.purple,
    Colors.green,
  ];

  DateTime now = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      appBar: AppBar(
        title: Text('Report', style: GoogleFonts.montserrat()),
        centerTitle: true,
        backgroundColor: kPrimaryColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Month/Year: ',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
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
                Text(DateFormat("yyyy-MMMM").format(now)),
              ],
            ),
            Container(
              child: FutureBuilder(
                future: getReportData(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    Map<String, dynamic> incomeData;
                    Map<String, dynamic> expenseData;
                    double totalIncome;
                    double totalExpense;
                    double savings;

                    Map<String, dynamic> data = snapshot.data;
                    print(data);
                    totalIncome = data["total_income"] == null
                        ? 0.0
                        : data["total_income"];
                    totalExpense = data["total_expenses"] == null
                        ? 0.0
                        : data["total_expenses"];
                    savings = data["savings"] == 0 ? 0.0 : data["savings"];
                    incomeData = data["income_details"].cast<String, double>();
                    expenseData =
                        data["expense_details"].cast<String, double>();

                    return Column(
                      children: [
                        MonthlyTotal(
                          incomeTotal: totalIncome,
                          expenseTotal: totalExpense,
                          savings: savings,
                        ),
                        SizedBox(height: 20),
                        Card(
                          child: Column(
                            children: [
                              header('Expense categories'),
                              expData(expenseData, context),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                        Card(
                          child: Column(
                            children: [
                              header('Income categories'),
                              incData(incomeData, context),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                        Card(
                          child: Column(
                            children: [
                              header('Expense statistics'),
                              expenseData.isNotEmpty
                                  ? _showExpenseChart(expenseData, context)
                                  : Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.09,
                                      child: Text('No data'),
                                    ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                        Card(
                          child: Column(
                            children: [
                              header('Income statistics'),
                              incomeData.isNotEmpty
                                  ? _showIncomeChart(incomeData, context)
                                  : Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.09,
                                      child: Text('No data'),
                                    ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                        ButtonTheme(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                          minWidth: MediaQuery.of(context).size.width * 0.8,
                          child: FlatButton(
                            padding: EdgeInsets.symmetric(vertical: 15),
                            child: Text(
                              "Export to files",
                              style: TextStyle(fontSize: 18),
                            ),
                            color: Colors.blue[900],
                            textColor: Colors.white,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PDF(
                                    year: now.year.toString(),
                                    month: now.month.toString(),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(height: 20),
                      ],
                    );
                  }
                  if (snapshot.hasError) {
                    return Text('error');
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  PieChart _showIncomeChart(Map incomeData, BuildContext context) {
    return PieChart(
      dataMap: incomeData,
      animationDuration: Duration(milliseconds: 1500),
      chartLegendSpacing: 32,
      chartRadius: MediaQuery.of(context).size.width / 2,
      colorList: colorList,
      initialAngleInDegree: 0,
      chartType: ChartType.disc,
      ringStrokeWidth: 32,
      legendOptions: LegendOptions(
        showLegendsInRow: false,
        legendPosition: LegendPosition.right,
        showLegends: true,
        legendShape: BoxShape.circle,
        legendTextStyle: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      chartValuesOptions: ChartValuesOptions(
          showChartValueBackground: false,
          showChartValues: true,
          showChartValuesInPercentage: false,
          showChartValuesOutside: false,
          chartValueStyle:
              TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
    );
  }

  PieChart _showExpenseChart(Map expenseData, BuildContext context) {
    return PieChart(
      dataMap: expenseData,
      animationDuration: Duration(milliseconds: 1500),
      chartLegendSpacing: 32,
      chartRadius: MediaQuery.of(context).size.width / 2,
      colorList: colorList,
      initialAngleInDegree: 0,
      chartType: ChartType.disc,
      ringStrokeWidth: 32,
      legendOptions: LegendOptions(
        showLegendsInRow: false,
        legendPosition: LegendPosition.right,
        showLegends: true,
        legendShape: BoxShape.circle,
        legendTextStyle: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      chartValuesOptions: ChartValuesOptions(
          showChartValueBackground: false,
          showChartValues: true,
          showChartValuesInPercentage: false,
          showChartValuesOutside: false,
          chartValueStyle:
              TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
    );
  }

  Widget expData(Map expenseData, BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.24,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: expenseData.keys.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: Column(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.blue[100],
                  radius: MediaQuery.of(context).size.height * 0.06,
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.07,
                    child: categoryImage(expenseData.keys.toList()[index]),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                Text(expenseData.keys.toList()[index],
                    style: GoogleFonts.montserrat()),
                Text(
                    '$selectedCurrency ' +
                        expenseData.values.toList()[index].toString(),
                    style: GoogleFonts.montserrat()),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget incData(Map incomeData, BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.24,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: incomeData.keys.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: Column(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.blue[100],
                  radius: MediaQuery.of(context).size.height * 0.06,
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.07,
                    child: categoryImage(incomeData.keys.toList()[index]),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                Text(incomeData.keys.toList()[index],
                    style: GoogleFonts.montserrat()),
                Text(
                    '$selectedCurrency ' +
                        incomeData.values.toList()[index].toString(),
                    style: GoogleFonts.montserrat()),
              ],
            ),
          );
        },
      ),
    );
  }
}

class MonthlyTotal extends StatelessWidget {
  final double incomeTotal;
  final double expenseTotal;
  final double savings;

  final TextStyle _style1 =
      GoogleFonts.montserrat(textStyle: TextStyle(fontSize: 18));

  final TextStyle _style2 = GoogleFonts.montserrat(
      textStyle: TextStyle(
          fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green));

  final TextStyle _style3 = GoogleFonts.montserrat(
      textStyle: TextStyle(
          fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red));

  final TextStyle _style4 = GoogleFonts.montserrat(
      textStyle: TextStyle(
          fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue[900]));

  MonthlyTotal({this.incomeTotal = 0, this.expenseTotal = 0, this.savings = 0});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Card(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text('Total Income', style: _style1),
                  Text('Total Expenses', style: _style1),
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text('$selectedCurrency. $incomeTotal', style: _style2),
                  Text('$selectedCurrency. $expenseTotal', style: _style3),
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('Savings', style: _style1),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  Text('$selectedCurrency. $savings', style: _style4)
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget header(String title) {
  return Padding(
    padding: EdgeInsets.fromLTRB(15, 10, 0, 0),
    child: Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: GoogleFonts.montserrat(
            textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      ),
    ),
  );
}
