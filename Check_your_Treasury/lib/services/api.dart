import 'dart:convert';

import 'package:Check_your_Treasury/models/expense.dart';
import 'package:Check_your_Treasury/models/income.dart';
import 'package:Check_your_Treasury/models/rate.dart';
import 'package:Check_your_Treasury/models/reminder.dart';
import 'package:Check_your_Treasury/models/user.dart';
import 'package:Check_your_Treasury/screens/addTransaction.dart';
import 'package:Check_your_Treasury/screens/login.dart';
import 'package:Check_your_Treasury/screens/reminders.dart';
import 'package:Check_your_Treasury/screens/selectCurrency.dart';
import 'package:Check_your_Treasury/screens/transactionsList.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences pref;
final String rateUrl = 'https://api.exchangerate.host/latest?';

List currencies = [
  'AED',
  'AFN',
  'ALL',
  'AMD',
  'ANG',
  'AOA',
  'ARS',
  'AUD',
  'AWG',
  'AZN',
  'BAM',
  'BBD',
  'BDT',
  'BGN',
  'BHD',
  'BIF',
  'BMD',
  'BND',
  'BOB',
  'BRL',
  'BSD',
  'BTC',
  'BTN',
  'BWP',
  'BYN',
  'BZD',
  'CAD',
  'CDF',
  'CHF',
  'CLF',
  'CLP',
  'CNH',
  'CNY',
  'COP',
  'CRC',
  'CUC',
  'CUP',
  'CVE',
  'CZK',
  'DJF',
  'DKK',
  'DOP',
  'DZD',
  'EGP',
  'ERN',
  'ETB',
  'EUR',
  'FJD',
  'FKP',
  'GBP',
  'GEL',
  'GGP',
  'GHS',
  'GIP',
  'GMD',
  'GNF',
  'GTQ',
  'GYD',
  'HKD',
  'HNL',
  'HRK',
  'HTG',
  'HUF',
  'IDR',
  'ILS',
  'IMP',
  'INR',
  'IQD',
  'IRR',
  'ISK',
  'JEP',
  'JMD',
  'JOD',
  'JPY',
  'KES',
  'KGS',
  'KHR',
  'KMF',
  'KPW',
  'KRW',
  'KWD',
  'KYD',
  'KZT',
  'LAK',
  'LBP',
  'LKR',
  'LRD',
  'LSL',
  'LYD',
  'MAD',
  'MDL',
  'MGA',
  'MKD',
  'MMK',
  'MNT',
  'MOP',
  'MRO',
  'MRU',
  'MUR',
  'MVR',
  'MWK',
  'MXN',
  'MYR',
  'MZN',
  'NAD',
  'NGN',
  'NIO',
  'NOK',
  'NPR',
  'NZD',
  'OMR',
  'PAB',
  'PEN',
  'PGK',
  'PHP',
  'PKR',
  'PLN',
  'PYG',
  'QAR',
  'RON',
  'RSD',
  'RUB',
  'RWF',
  'SAR',
  'SBD',
  'SCR',
  'SDG',
  'SEK',
  'SGD',
  'SHP',
  'SLL',
  'SOS',
  'SRD',
  'SSP',
  'STD',
  'STN',
  'SVC',
  'SYP',
  'SZL',
  'THB',
  'TJS',
  'TMT',
  'TND',
  'TOP',
  'TRY',
  'TTD',
  'TWD',
  'TZS',
  'UAH',
  'UGX',
  'USD',
  'UYU',
  'UZS',
  'VEF',
  'VES',
  'VND',
  'VUV',
  'WST',
  'XAF',
  'XAG',
  'XAU',
  'XCD',
  'XDR',
  'XOF',
  'XPD',
  'XPF',
  'XPT',
  'YER',
  'ZAR',
  'ZMW',
  'ZWL'
];

String url = 'http://192.168.1.108:8000/';

final String registerUrl = url + 'api/auth/register';

final String loginUrl = url + 'api/auth/login';

final String logoutUrl = url + 'api/auth/logout';

final String userProfileUrl = url + 'api/auth/user';

class API {
  Future<Rate> getdata(String cur) async {
    http.Response response = await http.get(rateUrl + 'base=$cur');
    final fetcheddata = rateFromJson(response.body);
    return fetcheddata; //returns Rate object
  }

  register(BuildContext context, User user) async {
    http.Response response = await http.post(
      registerUrl,
      headers: {
        'Content-Type': "application/json",
      },
      body: userToJson(user),
    );
    print(response.statusCode);
    var responseData = json.decode(response.body);
    if (response.statusCode == 200) {
      print(response.body);
      showMyDialog(
          context, 'Successfully registered!', 'You have been registered');
    } else if (response.statusCode == 400 &&
        responseData["username"][0] ==
            "A user with that username already exists.") {
      showMyDialog(context, 'Username error!',
          'A user with that username already exists');
    } else {
      showMyDialog(
          context, 'Error!', 'There was some problem.Please try again');
    }
  }

  Future logout(BuildContext context) async {
    pref = await SharedPreferences.getInstance();

    http.Response response = await http.post(logoutUrl, headers: {
      "Authorization": "Token " + pref.getString("token"),
    });
    print(response.statusCode);

    if (response.statusCode == 204) {
      pref.remove("token");
      pref.remove("currency");

      Navigator.pushAndRemoveUntil(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => Login(),
            transitionDuration: Duration(seconds: 0),
          ),
          (Route<dynamic> route) => false);
    } else {
      showMyDialog(context, 'Error!',
          'There was some problem logging out.Please try again');
    }
  }

  getUserProfile() async {
    http.Response response = await http.get(
      userProfileUrl,
      headers: {
        'Content-Type': "application/json",
        "Authorization": "Token " + pref.getString('token'),
      },
    );

    print(response.statusCode);

    var data = json.decode(response.body);
    if (response.statusCode == 200) {
      return data;
    }
  }

  void addIncome(BuildContext context, Income income) async {
    http.Response response = await http.post(
      url + 'incomes/',
      headers: {
        'Content-Type': "application/json",
        "Authorization": "Token " + pref.getString('token'),
      },
      body: incomeToJson(income),
    );
    var data = json.decode(response.body);
    print(response.statusCode);
    print(data);

    if (response.statusCode == 201) {
      showMyDialog(
              context, "Transaction added!", "Transaction added successfully")
          .then((data) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => TransactionsList()));
      });
    }
  }

  void deleteIncome(Income income, int id) async {
    http.Response response = await http.delete(
      url + 'incomes/$id',
      headers: {
        "Authorization": "Token " + pref.getString('token'),
      },
    );
    if (response.statusCode == 204) {}
  }

  void addExpense(BuildContext context, Expense expense) async {
    http.Response response = await http.post(
      url + 'expenses/',
      headers: {
        'Content-Type': "application/json",
        "Authorization": "Token " + pref.getString('token'),
      },
      body: expenseToJson(expense),
    );
    var data = json.decode(response.body);
    print(response.statusCode);
    print(data);

    if (response.statusCode == 201) {
      showMyDialog(
              context, "Transaction added!", "Transaction added successfully")
          .then((data) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => TransactionsList()));
      });
    }
  }

  Future<dynamic> getIncomeList(DateTime date) async {
    pref = await SharedPreferences.getInstance();

    http.Response response = await http.get(
      url + 'incomes?date=${DateFormat("yyyy-MM-dd").format(date)}',
      headers: {
        'Content-Type': "application/json",
        "Authorization": "Token " + pref.getString('token'),
      },
    );

    print(response.statusCode);

    var data = json.decode(response.body);

    if (response.statusCode == 200) {
      print(data);
      return data;
    }
  }

  Future<dynamic> getExpenseList(DateTime date) async {
    pref = await SharedPreferences.getInstance();

    http.Response response = await http.get(
      url + 'expenses?date=${DateFormat("yyyy-MM-dd").format(date)}',
      headers: {
        'Content-Type': "application/json",
        "Authorization": "Token " + pref.getString('token'),
      },
    );

    print(response.statusCode);

    var data = json.decode(response.body);

    if (response.statusCode == 200) {
      print(data);
      return data;
    }
  }

  void addReminder(BuildContext context, Reminder reminder) async {
    http.Response response = await http.post(
      url + 'reminders/',
      headers: {
        'Content-Type': "application/json",
        "Authorization": "Token " + pref.getString('token'),
      },
      body: reminderToJson(reminder),
    );
    var data = json.decode(response.body);
    print(response.statusCode);
    print(data);

    if (response.statusCode == 201) {
      showMyDialog(context, "Reminder added!", "Reminder added successfully")
          .then((data) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Reminders()));
      });
    }
  }

  Future<dynamic> getReminders() async {
    pref = await SharedPreferences.getInstance();

    http.Response response = await http.get(
      url + 'reminders',
      headers: {
        'Content-Type': "application/json",
        "Authorization": "Token " + pref.getString('token'),
      },
    );

    print(response.statusCode);

    var data = json.decode(response.body);

    if (response.statusCode == 200) {
      print(data);
      return data;
    }
  }

  Future<dynamic> getRecentExpenses() async {
    pref = await SharedPreferences.getInstance();

    http.Response response = await http.get(
      url + 'recentExpenses/',
      headers: {
        'Content-Type': "application/json",
        "Authorization": "Token " + pref.getString('token'),
      },
    );

    print(response.statusCode);

    var data = json.decode(response.body);

    if (response.statusCode == 200) {
      print(data);
      return data;
    }
  }

  Future<dynamic> getRecentIncomes() async {
    pref = await SharedPreferences.getInstance();

    http.Response response = await http.get(
      url + 'recentIncomes/',
      headers: {
        'Content-Type': "application/json",
        "Authorization": "Token " + pref.getString('token'),
      },
    );

    print(response.statusCode);

    var data = json.decode(response.body);

    if (response.statusCode == 200) {
      print(data);
      return data;
    }
  }
}
