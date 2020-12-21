import 'package:amcham_admin_web/components/app_bar.dart';
import 'package:amcham_admin_web/components/rounded_button.dart';
import 'package:amcham_admin_web/constants.dart';
import 'package:amcham_admin_web/screens/events_home_screen.dart';
import 'package:flutter/material.dart';

class ChooserScreen extends StatefulWidget {
  @override
  _ChooserScreenState createState() => _ChooserScreenState();
}

class _ChooserScreenState extends State<ChooserScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Constants.blueThemeColor,
      ),
      backgroundColor: Constants.blueThemeColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Text(
              'Welcome _Name to the Admin Portal',
              style: Constants.logoTitleStyle,
            ),
          ),
          SizedBox(
            height: 50,
          ),
          Center(
            child: RoundedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EventsHomeScreen()));
              },
              title: 'Events',
              textStyle: Constants.blueText,
              width: 150,
              height: 60,
              radius: 15,
            ),
          ),
          Center(
            child: RoundedButton(
              onPressed: () {},
              title: 'News',
              textStyle: Constants.blueText,
              width: 150,
              height: 60,
              radius: 15,
            ),
          ),
          Center(
            child: RoundedButton(
              onPressed: () {},
              title: 'Logout',
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
