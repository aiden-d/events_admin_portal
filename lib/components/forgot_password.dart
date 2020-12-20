import 'package:flutter/material.dart';
import 'package:amcham_app_v2/screens/forgot_password_screen.dart';

class ForgotPassword extends StatelessWidget {
  ForgotPassword();
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => ForgotPasswordScreen()));
      },
      child: Text(
        'Forgot password?',
        style: TextStyle(color: Colors.white, fontSize: 25),
      ),
    );
  }
}
