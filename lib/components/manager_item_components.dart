import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'rounded_text_field.dart';

class ManageItemStream extends StatelessWidget {
  static List<ManagerItem> items = [];
  final String collectionName;
  final String documentName;
  final String variableName;

  List<ManagerItem> newValues = [];

  ManageItemStream({
    @required this.collectionName,
    @required this.documentName,
    @required this.variableName,
  });
  final _firestore = FirebaseFirestore.instance;
  List<ManagerItem> getNewValues() {
    return newValues;
  }

  void setNewValues(List<ManagerItem> val) {
    newValues = val;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: _firestore.collection(collectionName).doc(documentName).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          items = [];
          Map<String, dynamic> data = snapshot.data.data();
          List endings = data[variableName];

          for (String e in endings) {
            items.add(ManagerItem(
              hintText: 'Enter email',
              prevValue: e,
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

  Future<void> publishChanges({Function pushClass}) async {
    List<String> endingsString = [];
    for (var e in ManageItemStream.items) {
      if (e == null) {
        //TODO show error
        print('error');
        return null;
      }
      if (e.newValue == "") {
      } else {
        endingsString.add(e.newValue != null ? e.newValue : e.prevValue);
      }
    }
    for (var e in newValues) {
      if (e == null) {
        //TODO show error
        print('error');
        return null;
      }
      if (e.newValue != "") {
        endingsString.add(e.newValue);
      }
    }
    newValues = [];
    await _firestore
        .collection(collectionName)
        .doc(documentName)
        .update({'admin_emails': endingsString})
        .then((value) => print("Updated"))
        .catchError((error) => print("Failed to update: $error"));
    pushClass();
    // Navigator.pushReplacement(
    //     context, MaterialPageRoute(builder: (context) => classToPush));

    //TODO show error
  }
}

class ManagerItem extends StatelessWidget {
  final String prevValue;
  final bool isFromWeb;
  final String hintText;

  ManagerItem({
    @required this.prevValue,
    @required this.isFromWeb,
    @required this.hintText,
  });
  String newValue;
  bool isLoading = false;
  bool isDeleted = false;
  @override
  Widget build(BuildContext context) {
    return isDeleted == false
        ? Row(
            children: [
              RoundedTextField(
                width: 400,
                onChanged: (value) {
                  newValue = value;
                },
                hintText: hintText,
                textValue: prevValue,
              ),
            ],
          )
        : SizedBox();
  }
}
