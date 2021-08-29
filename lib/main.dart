import 'package:amcham_admin_web/screens/manage_events_screen.dart';
import 'package:flutter/material.dart';
import 'screens/test.dart';
import 'screens/landing_page.dart';

void main() {
  runApp(AmchamAdminWeb());
}

//test
class AmchamAdminWeb extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        unselectedWidgetColor: Colors.white,
      ),
      routes: {'/manageevents': (context) => ManageEventsScreen()},
      debugShowCheckedModeBanner: false,
      title: 'Amcham Admin Page',
      home: LandingPage(),
    );
  }
}
