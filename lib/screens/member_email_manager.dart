import 'package:amcham_admin_web/components/rounded_button.dart';
import 'package:amcham_admin_web/components/rounded_text_field.dart';
import 'package:amcham_admin_web/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _firestore = Firestore.instance;
final CollectionReference admin =
    FirebaseFirestore.instance.collection('Admin');

class MemberEmailManager extends StatefulWidget {
  @override
  _MemberEmailManagerState createState() => _MemberEmailManagerState();
}

class _MemberEmailManagerState extends State<MemberEmailManager> {
  static _MemberEmailManagerState currentState;
  Future<void> alertDialogBuilder(String title, String info) async {
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

  static List<EmailEndingItem> newEmailEndings = [];
  bool isLoading = false;
  @override
  void initState() {
    newEmailEndings = [];
    currentState = this;
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Constants.blueThemeColor,
        iconTheme: IconThemeData(color: Constants.blueThemeColor),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            EmailEndingStream(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: newEmailEndings,
            ),
            RoundedButton(
                title: 'ADD NEW',
                onPressed: () {
                  setState(() {
                    newEmailEndings.add(EmailEndingItem(
                      emailEnding: '',
                      isFromWeb: false,
                    ));
                  });
                }),
            RoundedButton(
                isLoading: isLoading,
                title: 'PUBLISH',
                onPressed: () async {
                  setState(() {
                    isLoading = true;
                  });
                  await publishChanges();
                  setState(() {
                    isLoading = false;
                  });
                }),
          ],
        ),
      ),
      backgroundColor: Constants.blueThemeColor,
    );
  }

  Future<void> publishChanges() async {
    List<String> endingsString = [];
    for (var e in EmailEndingStream.items) {
      if (e == null) {
        //TODO show error
        print('error');
        return null;
      }
      if (e.newEmailEnding == "") {
      } else {
        endingsString
            .add(e.newEmailEnding != null ? e.newEmailEnding : e.emailEnding);
      }
    }
    for (var e in newEmailEndings) {
      if (e == null) {
        //TODO show error
        print('error');
        return null;
      }
      if (e.newEmailEnding == "") {
      } else {
        endingsString.add(e.newEmailEnding);
      }
    }
    newEmailEndings = [];
    await admin
        .doc('member_emails')
        .update({'member_emails': endingsString})
        .then((value) => print("Updated"))
        .catchError((error) => print("Failed to update: $error"));
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => MemberEmailManager()));

    //TODO show error
  }
}

class EmailEndingStream extends StatelessWidget {
  static List<EmailEndingItem> items = [];

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: admin.doc('member_emails').get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          items = [];
          Map<String, dynamic> data = snapshot.data.data();
          List endings = data['member_emails'];

          for (String e in endings) {
            items.add(EmailEndingItem(
              emailEnding: e,
              isFromWeb: true,
            ));
          }
          return Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: items,
            ),
          );
        }

        return CircularProgressIndicator();
      },
    );
  }
}

class EmailEndingItem extends StatelessWidget {
  final String emailEnding;
  final bool isFromWeb;

  EmailEndingItem({
    @required this.emailEnding,
    @required this.isFromWeb,
  });
  String newEmailEnding;
  bool isLoading = false;
  bool isDeleted = false;
  @override
  Widget build(BuildContext context) {
    return isDeleted == false
        ? Row(
            children: [
              RoundedTextField(
                onChanged: (value) {
                  newEmailEnding = value;
                },
                hintText: 'Enter email ending',
                textValue: emailEnding,
              ),
              // IconButton(
              //   icon: Icon(
              //     CupertinoIcons.minus_circle,
              //     color: Colors.red,
              //   ),
              //   onPressed: () async {
              //     if (isFromWeb == false) {
              //       _MemberEmailManagerState.newEmailEndings.remove(this);
              //     } else {
              //       print(EmailEndingStream.items.remove(this));
              //       List<EmailEndingItem> items = EmailEndingStream.items;
              //       List<String> itemsString = [];
              //       for (var i in items) {
              //         itemsString.add(i.newEmailEnding != null
              //             ? i.newEmailEnding
              //             : i.emailEnding);
              //       }
              //       await admin
              //           .doc('member_emails')
              //           .update({'member_emails': itemsString})
              //           .then((value) => print("User Updated"))
              //           .catchError(
              //               (error) => print("Failed to update user: $error"));
              //       isDeleted = true;
              //     }
              //   },
              // ),
            ],
          )
        : SizedBox();
  }
}
