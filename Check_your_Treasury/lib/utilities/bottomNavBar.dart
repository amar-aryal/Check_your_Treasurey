import 'package:Check_your_Treasury/screens/exchangeRates.dart';
import 'package:Check_your_Treasury/screens/homeScreen.dart';
import 'package:Check_your_Treasury/screens/reminders.dart';
import 'package:Check_your_Treasury/screens/transactionsList.dart';
import 'package:Check_your_Treasury/utilities/constants.dart';
import 'package:flutter/material.dart';

class BottomBar extends StatefulWidget {
  int selectedIndex;

  BottomBar({this.selectedIndex});
  @override
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  List<Widget> _navWidgets = <Widget>[
    TransactionsList(),
    Reminders(),
    HomeScreen(),
    ExchangeRate(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      widget.selectedIndex = index;
    });
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => _navWidgets[widget.selectedIndex],
        transitionDuration: Duration(seconds: 0),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.post_add_sharp),
          label: 'Transactions',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications_none_rounded),
          label: 'Reminders',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.monetization_on),
          label: 'Currency rates',
        ),
      ],
      currentIndex: widget.selectedIndex,
      selectedItemColor: kPrimaryColor,
      unselectedItemColor: Colors.grey,
      onTap: _onItemTapped,
    );
  }
}
