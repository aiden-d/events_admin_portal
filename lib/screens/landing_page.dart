import 'package:amcham_admin_web/constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'chooser_screen.dart';

import 'package:amcham_admin_web/size_config.dart';

class LandingPage extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Scaffold(
              body: Center(
                child: Text("Error: ${snapshot.error}"),
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return StreamBuilder<User?>(
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    User? _user = snapshot.data;
                    SizeConfig().init(context);
                    if (_user == null) {
                      print('need to log in');
                      //user is not logged in
                      return HomePage();
                    } else {
                      print('logged in');
                      return ChooserScreen();
                      //user is logged in
                      //EventsScreen();
                    }
                  }
                  return Scaffold(
                      body: Center(
                          child: Text(
                    "Connecting to the app...",
                    style: Constants.regularHeading,
                  )));
                });
          }
          return Scaffold(
            body: Center(
              child: Text(
                "Connecting to the app...",
                style: Constants.regularHeading,
              ),
            ),
          );
        });
  }
}
