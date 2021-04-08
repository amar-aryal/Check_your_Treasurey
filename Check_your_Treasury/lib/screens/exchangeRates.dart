import 'package:Check_your_Treasury/services/api.dart';
import 'package:Check_your_Treasury/utilities/bottomNavBar.dart';
import 'package:Check_your_Treasury/utilities/constants.dart';
import 'package:Check_your_Treasury/utilities/customDrawer.dart';
import 'package:flutter/material.dart';

String selectedCurrency;

class ExchangeRate extends StatefulWidget {
  @override
  _ExchangeRateState createState() => _ExchangeRateState();
}

class _ExchangeRateState extends State<ExchangeRate> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Exchange Rates ($selectedCurrency)'),
        centerTitle: true,
        backgroundColor: kPrimaryColor,
      ),
      bottomNavigationBar: BottomBar(selectedIndex: 3),
      drawer: CustomDrawer(),
      body: FutureBuilder(
          future: API().getdata(selectedCurrency),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var data = snapshot.data; // data returns an instance of 'Rate'

              return ListView.builder(
                itemCount: currencies.length,
                itemBuilder: (context, index) {
                  return ListTile(
                      leading: Text(
                        '1 ${data.base}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      trailing: Text(
                          '${data.rates[currencies[index]].toString()} ${currencies[index]}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          )));
                },
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}
