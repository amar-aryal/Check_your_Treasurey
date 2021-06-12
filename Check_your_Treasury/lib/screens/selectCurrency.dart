import 'package:Check_your_Treasury/screens/homeScreen.dart';
import 'package:Check_your_Treasury/services/api.dart';
import 'package:Check_your_Treasury/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SelectCurrency extends StatefulWidget {
  final String username;
  SelectCurrency({this.username});
  @override
  _SelectCurrencyState createState() => _SelectCurrencyState();
}

class _SelectCurrencyState extends State<SelectCurrency> {
  String name = '';

  @override
  void initState() {
    super.initState();
    // API().getUserProfile().then((data) {
    //   setState(() {
    //     name = data["username"];
    //   });
    //   print('$name');
    // });
    print(widget.username);
    // if (pref.getBool(name) != null) {
    //   if (pref.getBool(name)) {
    //     WidgetsBinding.instance.addPostFrameCallback((_) {
    //       Navigator.pushAndRemoveUntil(
    //           context,
    //           PageRouteBuilder(
    //             pageBuilder: (_, __, ___) => HomeScreen(),
    //             transitionDuration: Duration(seconds: 0),
    //           ),
    //           (Route<dynamic> route) => false);
    //     });
    //   }
    // }
  }

  String currency = 'NPR';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text(
                'Select Currency',
                style: GoogleFonts.montserrat(
                    textStyle:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.08),
            Container(
              width: 100,
              child: DropdownButton<String>(
                focusColor: Colors.blue,
                itemHeight: 60,
                isExpanded: true,
                style: GoogleFonts.montserrat(
                    textStyle: TextStyle(fontSize: 18, color: Colors.black)),
                value: currency,
                onChanged: (newValue) {
                  setState(() {
                    currency = newValue;
                  });
                },
                items: currenciesList(),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.04),
            ButtonTheme(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              minWidth: MediaQuery.of(context).size.width * 0.8,
              child: FlatButton(
                padding: EdgeInsets.symmetric(vertical: 15),
                onPressed: () {
                  pref.setStringList(widget.username, [currency]);
                  Navigator.pushAndRemoveUntil(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (_, __, ___) =>
                            HomeScreen(username: widget.username.trim()),
                        transitionDuration: Duration(seconds: 0),
                      ),
                      (Route<dynamic> route) => false);
                },
                color: kPrimaryColor,
                child: Text(
                  'PROCEED',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

List<DropdownMenuItem<String>> currenciesList() {
  List<DropdownMenuItem<String>> currList = [];
  for (String curr in currencies) {
    DropdownMenuItem<String> item = DropdownMenuItem<String>(
      child: Text(curr),
      value: curr,
    );
    currList.add(item);
  }
  return currList;
}
