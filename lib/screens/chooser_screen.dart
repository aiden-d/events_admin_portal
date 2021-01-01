import 'package:amcham_admin_web/components/app_bar.dart';
import 'package:amcham_admin_web/components/rounded_button.dart';
import 'package:amcham_admin_web/constants.dart';
import 'package:amcham_admin_web/screens/events_home_screen.dart';
import 'package:amcham_admin_web/screens/landing_page.dart';
import 'package:amcham_admin_web/screens/manage_admin_emails.dart';
import 'package:amcham_admin_web/screens/member_email_manager.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
              'Welcome ${FirebaseAuth.instance.currentUser.email} to the Admin Portal',
              //TODO change to actual name
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
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MemberEmailManager()));
              },
              title: 'Manage Member Emails',
              textStyle: Constants.blueText,
              width: 150,
              height: 60,
              radius: 15,
            ),
          ),
          Center(
            child: RoundedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ManageAdminMembers()));
              },
              title: 'Manage Admin Members',
              textStyle: Constants.blueText,
              width: 150,
              height: 60,
              radius: 15,
            ),
          ),
          Center(
            child: RoundedButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
                return LandingPage();
              },
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
