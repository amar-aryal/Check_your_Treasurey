import 'dart:convert';

import 'package:Check_your_Treasury/models/expense.dart';
import 'package:Check_your_Treasury/models/income.dart';
import 'package:Check_your_Treasury/models/rate.dart';
import 'package:Check_your_Treasury/models/reminder.dart';
import 'package:Check_your_Treasury/screens/addTransaction.dart';
import 'package:Check_your_Treasury/screens/exchangeRates.dart';
import 'package:Check_your_Treasury/screens/homeScreen.dart';
import 'package:Check_your_Treasury/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences pref;
final String rateUrl =
    'https://api.exchangerate.host/latest?base=$selectedCurrency';

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

String url = 'http://10.0.2.2:8000/';

final String registerUrl = url + 'api/auth/register';

final String loginUrl = url + 'api/auth/login';

final String logoutUrl = url + 'api/auth/logout';

final String userProfileUrl = url + 'api/auth/user';

class API {
  Future<Rate> getdata() async {
    http.Response response = await http.get(rateUrl);
    final fetcheddata = rateFromJson(response.body);
    return fetcheddata; //returns Rate object
  }

  register(String username, String email, String password) async {
    Map<String, String> user = {
      'username': username,
      'email': email,
      'password': password,
    };
    http.Response response = await http.post(
      registerUrl,
      headers: {
        'Content-Type': "application/json",
      },
      body: json.encode(user),
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      print(response.body);
    }
  }

  login(BuildContext context, String username, String password) async {
    pref = await SharedPreferences.getInstance();
    String token;
    Map<String, String> user = {
      'username': username,
      'password': password,
    };
    http.Response response = await http.post(
      loginUrl,
      headers: {
        'Content-Type': "application/json",
      },
      body: json.encode(user),
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      print(response.body);
      token = data["token"];
      print(token);
      pref.setString("token", token);
      Navigator.pushAndRemoveUntil(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => HomeScreen(),
            transitionDuration: Duration(seconds: 0),
          ),
          (Route<dynamic> route) => false);
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

      Navigator.pushAndRemoveUntil(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => Login(),
            transitionDuration: Duration(seconds: 0),
          ),
          (Route<dynamic> route) => false);
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

  void addIncome(Income income) async {
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
      // show success message
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

  void addExpense(Expense expense) async {
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
      // show success message
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

  void addReminder(Reminder reminder) async {
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
      // show success message
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

  deleteReminder(int id) async {
    http.Response response = await http.delete(
      url + 'reminders/$id/',
      headers: {
        "Authorization": "Token " + pref.getString('token'),
      },
    );
    print(response.statusCode);
    if (response.statusCode == 204) {
      print('deleted');
    }
  }
}
