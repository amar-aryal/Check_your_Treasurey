import 'dart:io';

import 'package:flutter/material.dart';

const kPrimaryColor = Color(0xff4242b3);

final kScaffoldBgColor = Colors.blueGrey[50];
// Color(0xffede2c2);

Future<bool> onWillPop(BuildContext context) {
  return showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Are you sure?'),
          content: Text('Do you want to exit an App'),
          actions: <Widget>[
            FlatButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('No'),
            ),
            FlatButton(
              onPressed: () => exit(0),
              /*Navigator.of(context).pop(true)*/
              child: Text('Yes'),
            ),
          ],
        ),
      ) ??
      false;
}
