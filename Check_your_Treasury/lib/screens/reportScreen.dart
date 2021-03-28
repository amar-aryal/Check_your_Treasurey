import 'dart:convert';

import 'package:Check_your_Treasury/screens/exchangeRates.dart';
import 'package:Check_your_Treasury/services/api.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import 'package:pie_chart/pie_chart.dart';
import 'package:Check_your_Treasury/screens/createPdf.dart';

void main() {
  runApp(MaterialApp(home: ReportScreen()));
}

class ReportScreen extends StatefulWidget {
  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final String reportUrl = 'http://10.0.2.2:8000/monthly_total/';

  Future getReportData() async {
    http.Response response = await http.get(
      reportUrl + '?year=${now.year}&month=${now.month}',
      headers: {
        'Content-Type': "application/json",
        "Authorization": "Token " + pref.getString('token'),
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
    Colors.cyan,
    Colors.lightGreen,
    Colors.purple,
    Colors.yellow[700],
    Colors.blue[800],
    Colors.deepOrange,
  ];

  DateTime now = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Report'),
        centerTitle: true,
        backgroundColor: Colors.cyan,
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
                    double total_income;
                    double total_expense;
                    double savings;

                    Map<String, dynamic> data = snapshot.data;
                    print(data);
                    total_income = data["total_income"] == null
                        ? 0.0
                        : data["total_income"];
                    total_expense = data["total_expenses"] == null
                        ? 0.0
                        : data["total_expenses"];
                    savings = data["savings"] == 0
                        ? 0.0
                        : data["savings"]; //!was giving error
                    incomeData = data["income_details"].cast<String, double>();
                    expenseData =
                        data["expense_details"].cast<String, double>();

                    return Column(
                      children: [
                        MonthlyTotal(
                          incomeTotal: total_income,
                          expenseTotal: total_expense,
                          savings: savings,
                        ),
                        Text('Income Stats',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.05)),
                        incomeData.isNotEmpty
                            ? _showIncomeChart(incomeData)
                            : Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.09,
                                child: Text('No data'),
                              ),
                        Text(
                          'Expense Stats',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                            fontSize: MediaQuery.of(context).size.height * 0.05,
                          ),
                        ),
                        expData(expenseData),
                        incData(incomeData),
                        expenseData.isNotEmpty
                            ? _showExpenseChart(expenseData)
                            : Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.09,
                                child: Text('No data'),
                              ),
                        FlatButton(
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

  PieChart _showIncomeChart(Map incomeData) {
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

  PieChart _showExpenseChart(Map expenseData) {
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

  Widget expData(Map expenseData) {
    return Container(
      height: 200,
      child: ListView.builder(
        itemCount: expenseData.keys.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            child: Row(
              children: [
                Text(expenseData.keys.toList()[index]),
                Text(expenseData.values.toList()[index].toString()),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget incData(Map incomeData) {
    return Container(
      height: 200,
      child: ListView.builder(
        itemCount: incomeData.keys.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            child: Row(
              children: [
                Text(incomeData.keys.toList()[index]),
                Text(incomeData.values.toList()[index].toString()),
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

  final TextStyle _style1 = GoogleFonts.workSans(
      textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold));

  MonthlyTotal({this.incomeTotal = 0, this.expenseTotal = 0, this.savings = 0});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 15),
          Text('Total Income: $selectedCurrency. $incomeTotal', style: _style1),
          SizedBox(height: 15),
          Text('Total Expenses: $selectedCurrency. $expenseTotal',
              style: _style1),
          SizedBox(height: 15),
          Text('Savings: $selectedCurrency. $savings', style: _style1),
          SizedBox(height: 15),
        ],
      ),
    );
  }
}
