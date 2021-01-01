import 'package:amcham_admin_web/screens/create_event_screen.dart';
import 'package:amcham_admin_web/screens/manage_events_screen.dart';
import 'package:flutter/material.dart';
import 'package:amcham_admin_web/constants.dart';
import 'package:amcham_admin_web/components/rounded_button.dart';

class EventsHomeScreen extends StatefulWidget {
  @override
  _EventsHomeScreenState createState() => _EventsHomeScreenState();
}

class _EventsHomeScreenState extends State<EventsHomeScreen> {
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
                        builder: (context) => CreateEventScreen()));
              },
              title: 'Create Event',
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
                        builder: (context) => ManageEventsScreen()));
                //_alertDialogBuilder();
              },
              title: 'Manage Events',
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
