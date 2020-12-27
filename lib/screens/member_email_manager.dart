import 'package:amcham_admin_web/components/rounded_button.dart';
import 'package:amcham_admin_web/components/rounded_text_field.dart';
import 'package:amcham_admin_web/constants.dart';
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
  List emailEndings;
  List<EmailEndingItem> newEmailEndings = [];
  bool isLoading = false;

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
          children: [
            EmailEndingStream(),
            Column(
              children: newEmailEndings,
            ),
            RoundedButton(
                title: 'ADD NEW',
                onPressed: () {
                  setState(() {
                    newEmailEndings.add(EmailEndingItem(emailEnding: ''));
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

  Future<void> publishChanges() {
    List<String> endingsString = [];
    for (var e in EmailEndingStream.items) {
      if (e == null) {
        //TODO show error
        print('error');
        return null;
      }
      endingsString
          .add(e.newEmailEnding != null ? e.newEmailEnding : e.emailEnding);
    }
    for (var e in newEmailEndings) {
      if (e == null) {
        //TODO show error
        print('error');
        return null;
      }
      endingsString.add(e.newEmailEnding);
    }
    newEmailEndings = [];
    return admin
        .doc('member_emails')
        .update({'member_emails': endingsString})
        .then((value) => print("Updated"))
        .catchError((error) => print("Failed to update: $error"));

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
            ));
          }
          return Column(
            children: items,
          );
        }

        return CircularProgressIndicator();
      },
    );
  }
}

class EmailEndingItem extends StatelessWidget {
  final String emailEnding;
  EmailEndingItem({@required this.emailEnding});
  String newEmailEnding;
  @override
  Widget build(BuildContext context) {
    return RoundedTextField(
      onChanged: (value) {
        newEmailEnding = value;
      },
      hintText: 'Enter email ending',
      textValue: emailEnding,
    );
  }
}
