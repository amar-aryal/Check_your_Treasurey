import 'package:Check_your_Treasury/services/api.dart';
import 'package:Check_your_Treasury/utilities/bottomNavBar.dart';
import 'package:Check_your_Treasury/utilities/customDrawer.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    print(pref.getString("token"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        centerTitle: true,
        backgroundColor: Colors.cyan,
      ),
      bottomNavigationBar: BottomBar(
        selectedIndex: 2,
      ),
      drawer: CustomDrawer(),
      body: Column(
        children: [
          Center(
            child: Padding(
              padding: EdgeInsets.all(15.0),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.15,
                child: Image.asset('assets/budget.png'),
              ),
            ),
          ),
          Text(
            'Your budgeting tool',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
