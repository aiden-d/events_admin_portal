import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';

class Constants {
  static const num = 800;
  static const regularHeading = TextStyle(
      fontSize: 18.0, fontWeight: FontWeight.w600, color: Colors.black);
  static const logoTitleStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white);
  static const logoTitleStyleError =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.red);
  static const logoTitleStyleRed = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.bold,
    color: Color(0xffbfbfbf),
    shadows: <Shadow>[
      Shadow(
        offset: Offset(5.0, 5.0),
        blurRadius: 12.0,
        color: Colors.black38,
      ),
    ],
  );
  static const blueThemeColor = Color.fromARGB(1000, 26, 66, 117);
  static const blueText =
      TextStyle(fontSize: 25, color: Constants.blueThemeColor);
}
