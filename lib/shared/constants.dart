import 'package:flutter/material.dart';
// Put all design constants here for unified UI feel across the app

const textInputDecoration = InputDecoration(
    labelStyle: TextStyle(
        fontFamily: 'Montserrat',
        fontWeight: FontWeight.bold,
        color: Colors.blueGrey),
    focusedBorder:
        UnderlineInputBorder(borderSide: BorderSide(color: Colors.pink)));
const linkedPageTextStyle = TextStyle(
    color: Colors.pink,
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.bold,
    decoration: TextDecoration.underline);

class MyColors {
  static const myGreen = Color(0xFFadf0b5);

  static const myPurple = Color(0xFFe4b4ec);

  static const myPink = Colors.pink;
}
