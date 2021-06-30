import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:amcham_admin_web/components/amcham_logo.dart';
import 'package:cupertino_icons/cupertino_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:amcham_admin_web/components/rounded_text_field.dart';
import 'package:amcham_admin_web/components/rounded_button.dart';
import 'package:amcham_admin_web/constants.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  bool? isResetPasswordLoading;
  String? _email;
  Future<void> _alertDialogBuilder(String title, String? info) async {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(title != null ? title : "Error"),
            content: Container(
              child: Text(info!),
            ),
            actions: [
              FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Close Dialog"))
            ],
          );
        });
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
              width: double.infinity,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconButton(
                        padding: EdgeInsets.all(5),
                        iconSize: 50,
                        alignment: Alignment.topLeft,
                        onPressed: () {
                          print("pressed");
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          CupertinoIcons.arrow_left,
                          color: Colors.white,
                        ),
                      ),
                      Center(child: Hero(tag: 'logo', child: AmchamLogo())),
                      SizedBox(
                        width: 60,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  RoundedTextField(
                    width: 420,
                    height: 60,
                    radius: 9,
                    hintText: 'Email',
                    onChanged: (value) {
                      _email = value;
                    },
                    textInputAction: TextInputAction.next,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  RoundedButton(
                    onPressed: () async {
                      //_alertDialogBuilder();
                      //_submitForm();
                      if (_email != null) {
                        setState(() {
                          isResetPasswordLoading = true;
                        });
                        try {
                          await _firebaseAuth.sendPasswordResetEmail(
                              email: _email!);
                        } on FirebaseAuthException catch (e) {
                          setState(() {
                            isResetPasswordLoading = false;
                          });
                          return _alertDialogBuilder('Error', e.message);
                        }
                        setState(() {
                          isResetPasswordLoading = false;
                        });
                        return _alertDialogBuilder(
                            'Sent', 'Check your email to reset your password');
                      }
                    },
                    //isLoading: isLoading,
                    title: 'Reset Password',
                    isLoading: isResetPasswordLoading,
                    textStyle: Constants.blueText,
                    width: 400,
                    height: 60,
                    radius: 15,
                  ),
                  SizedBox(
                    height: 30,
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
