import 'package:amcham_admin_web/components/forgot_password.dart';
import 'package:amcham_admin_web/constants.dart';
import 'package:flutter/material.dart';
import 'package:amcham_admin_web/components/rounded_button.dart';
import '../constants.dart';
import 'login_screen.dart';

import 'package:amcham_admin_web/components/amcham_logo.dart';
import 'package:amcham_admin_web/size_config.dart';
import 'package:package_info/package_info.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PackageInfo packageInfo;
  @override
  void initState() {
    super.initState();
  }

  Future<String> getPackageString() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("lib/images/TreeBackground.png"),
              fit: BoxFit.cover)),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(50),
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: SizeConfig().getBlockSizeVertical() * 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Hero(tag: 'logo', child: AmchamLogo()),
                    ],
                  ),
                  SizedBox(
                    height: SizeConfig().getBlockSizeVertical() * 5,
                  ),
                  RoundedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()));
                    },
                    title: 'Login',
                    colour: Colors.white,
                    textStyle: Constants.blueText,
                    radius: 15,
                    height: 80,
                    width: 150,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  ForgotPassword(),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Version: 12',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
