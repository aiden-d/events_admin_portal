import 'package:amcham_admin_web/screens/create_event_screen.dart';
import 'package:amcham_admin_web/screens/create_news_screen.dart';
import 'package:amcham_admin_web/screens/manage_events_screen.dart';
import 'package:amcham_admin_web/screens/manage_news_screen.dart';
import 'package:flutter/material.dart';
import 'package:amcham_admin_web/constants.dart';
import 'package:amcham_admin_web/components/rounded_button.dart';

class NewsHomeScreen extends StatefulWidget {
  @override
  _NewsHomeScreenState createState() => _NewsHomeScreenState();
}

class _NewsHomeScreenState extends State<NewsHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Constants.blueThemeColor,
        iconTheme: IconThemeData(color: Constants.blueThemeColor),
      ),
      backgroundColor: Constants.blueThemeColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: RoundedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CreateNewsScreen()));
              },
              title: 'Create News',
              textStyle: Constants.blueText,
              width: 150,
              height: 60,
              radius: 15,
            ),
          ),
          Center(
            child: RoundedButton(
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ManageNewsScreen()));
                //_alertDialogBuilder();
              },
              title: 'Manage News',
              textStyle: Constants.blueText,
              width: 150,
              height: 60,
              radius: 15,
            ),
          ),
        ],
      ),
    );
  }
}
