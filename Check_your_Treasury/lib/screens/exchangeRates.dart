import 'package:Check_your_Treasury/services/api.dart';
import 'package:Check_your_Treasury/utilities/bottomNavBar.dart';
import 'package:flutter/material.dart';

String selectedCurrency = "NPR";

class ExchangeRate extends StatefulWidget {
  @override
  _ExchangeRateState createState() => _ExchangeRateState();
}

class _ExchangeRateState extends State<ExchangeRate> {
  @override
  void initState() {
    super.initState();
    API().getdata();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Exchange Rates ($selectedCurrency)'),
        centerTitle: true,
        backgroundColor: Colors.cyan,
      ),
      bottomNavigationBar: BottomBar(selectedIndex: 3),
      body: FutureBuilder(
          future: API().getdata(),
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
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      trailing: Text(
                          '${data.rates[currencies[index]].toString()} ${currencies[index]}',
                          style: TextStyle(
                            fontSize: 16,
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
