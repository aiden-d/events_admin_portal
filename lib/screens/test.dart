import 'package:flutter/material.dart';

class test extends StatefulWidget {
  @override
  _testState createState() => _testState();
}

class _testState extends State<test> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow,
      body: FlatButton(
        child: Text('hello world'),
        onPressed: () {},
      ),
    );
  }
}
