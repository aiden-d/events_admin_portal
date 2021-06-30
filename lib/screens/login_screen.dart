import 'package:amcham_admin_web/screens/chooser_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:amcham_admin_web/constants.dart';
import 'package:amcham_admin_web/components/rounded_button.dart';
import 'package:amcham_admin_web/components/rounded_text_field.dart';
import 'package:cupertino_icons/cupertino_icons.dart';
import 'package:amcham_admin_web/components/amcham_logo.dart';
import 'package:amcham_admin_web/components/forgot_password.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'forgot_password_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Future<void> _alertDialogBuilder(String title, String info) async {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(title != null ? title : "Error"),
            content: Container(
              child: Text(info),
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

  Future<String?> _createAccount() async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: _email, password: _password);
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }

  //submit form
  void _submitForm() async {
    setState(() {
      isLoading = true;
    });
    String? _createAccountFeedback = await _createAccount();
    if (_createAccountFeedback != null) {
      _alertDialogBuilder('Error', _createAccountFeedback);
    } else {
      List? emails;
      await FirebaseFirestore.instance
          .collection('Admin')
          .doc('admin_permissions')
          .get()
          .then((value) => emails = value.data()!['admin_emails']);
      if (emails != null) {
        for (var email in emails!) {
          if (email.toString() == FirebaseAuth.instance.currentUser!.email) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ChooserScreen()));
            return;
          }
        }
        _alertDialogBuilder('Error', 'You are not an admin');
        FirebaseAuth.instance.signOut();
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  bool isLoading = false;

  String _email = "";
  String _password = "";

  late FocusNode _lastNameFocusNode;
  late FocusNode _companyFocusNode;
  FocusNode? _emailFocusNode;
  FocusNode? _passwordFocusNode;
  late FocusNode _passwordConfFocusNode;
  @override
  void initState() {
    _lastNameFocusNode = FocusNode();
    _companyFocusNode = FocusNode();
    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
    _passwordConfFocusNode = FocusNode();

    super.initState();
  }

  @override
  void dispose() {
    _lastNameFocusNode.dispose();
    _companyFocusNode.dispose();
    _emailFocusNode!.dispose();
    _passwordFocusNode!.dispose();
    _passwordConfFocusNode.dispose();

    super.dispose();
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
                  Stack(
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
                        width: 10,
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
                    focusNode: _emailFocusNode,
                    onSubmitted: (value) {
                      _passwordFocusNode!.requestFocus();
                    },
                    textInputAction: TextInputAction.next,
                  ),
                  RoundedTextField(
                    width: 420,
                    height: 60,
                    radius: 9,
                    hintText: 'Password',
                    onChanged: (value) {
                      _password = value;
                    },
                    focusNode: _passwordFocusNode,
                    onSubmitted: (value) {
                      _submitForm();
                    },
                    isPasswordField: true,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  RoundedButton(
                    onPressed: () {
                      //_alertDialogBuilder();
                      _submitForm();
                    },
                    isLoading: isLoading,
                    title: 'Login',
                    textStyle: Constants.blueText,
                    width: 150,
                    height: 60,
                    radius: 15,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  ForgotPassword(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
