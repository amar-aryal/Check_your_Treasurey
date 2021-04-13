import 'package:flutter/material.dart';

InputDecoration buildInputDecorationWithIcon(String hintText, IconData icon) {
  return InputDecoration(
    enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(35.0),
        borderSide: BorderSide(color: Colors.grey, width: 2.0)),
    focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(35.0),
        borderSide: BorderSide(color: Colors.grey, width: 2.0)),
    icon: Icon(
      icon,
      color: Color(0xff4242b3),
    ),
    hintText: hintText,
  );
}

InputDecoration buildInputDecoration(String hintText) {
  return InputDecoration(
    enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5.0),
        borderSide: BorderSide(color: Colors.grey, width: 1.0)),
    focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5.0),
        borderSide: BorderSide(color: Colors.grey, width: 1.0)),
    hintText: hintText,
  );
}
