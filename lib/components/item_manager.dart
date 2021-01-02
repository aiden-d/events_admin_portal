import 'package:amcham_admin_web/screens/create_event_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'rounded_text_field.dart';

class ManageItemStream extends StatelessWidget {
  static List<ManagerItem> items = [];
  final String collectionName;
  final String documentName;
  final String variableName;
  final bool isDocumentSnapshot;
  final bool isEditable;
  final String hintText;

  List<ManagerItem> newValues = [];

  ManageItemStream({
    @required this.collectionName,
    @required this.documentName,
    @required this.variableName,
    @required this.isDocumentSnapshot,
    @required this.hintText,
    this.isEditable,
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
    return isDocumentSnapshot
        ? FutureBuilder<DocumentSnapshot>(
            future:
                _firestore.collection(collectionName).doc(documentName).get(),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text("Something went wrong");
              }

              if (snapshot.connectionState == ConnectionState.done) {
                items = [];
                Map<String, dynamic> data = snapshot.data.data();
                List endings = data[variableName];

                for (String e in endings) {
                  items.add(ManagerItem(
                    hintText: hintText,
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
          )
        : FutureBuilder<QuerySnapshot>(
            future: _firestore.collection(collectionName).get(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                print(snapshot.error.toString() + collectionName);
                return Text("Something went wrong");
              }
              items = [];

              if (snapshot.connectionState == ConnectionState.done) {
                for (var doc in snapshot.data.docs) {
                  Map<String, dynamic> data = doc.data();
                  String title = data[variableName];
                  String id = data['id'];

                  items.add(ManagerItem(
                    hintText: hintText,
                    prevValue: title,
                    isFromWeb: true,
                    docID: doc.id,
                    data: data,
                    isEditable: true,
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
    if (isDocumentSnapshot) {
      List<String> endingsString = [];
      for (var e in items) {
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
          .update({variableName: endingsString})
          .then((value) => print("Updated"))
          .catchError((error) => print("Failed to update: $error"));
      pushClass();
      // Navigator.pushReplacement(
      //     context, MaterialPageRoute(builder: (context) => classToPush));

      //TODO show error
    } else {
      List<String> endingsString = [];
      for (var e in items) {
        if (e == null) {
          //TODO show error
          print('error');
          return null;
        }
        if (e.newValue == "") {
          await _firestore.collection(collectionName).doc(e.docID).delete();
        } else {
          if (e.newValue != null) {
            await _firestore
                .collection(collectionName)
                .doc(e.docID)
                .update({variableName: e.newValue})
                .then((value) => print("Updated"))
                .catchError((error) => print("Failed to update: $error"));
          }
        }
      }

      pushClass();
      // Navigator.pushReplacement(
      //     context, MaterialPageRoute(builder: (context) => classToPush));

      //TODO show error
    }
  }
}

class ManagerItem extends StatelessWidget {
  final String prevValue;
  final bool isFromWeb;
  final String hintText;
  final String docID;
  final Map<String, dynamic> data;
  final bool isEditable;

  ManagerItem({
    @required this.prevValue,
    @required this.isFromWeb,
    @required this.hintText,
    this.docID,
    this.data,
    this.isEditable,
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
              isEditable == true
                  ? IconButton(
                      icon: Icon(CupertinoIcons.pencil_circle),
                      color: Colors.white,
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CreateEventScreen(
                                      data: data,
                                    )));
                      })
                  : SizedBox(),
              IconButton(
                  icon: Icon(CupertinoIcons.xmark_circle),
                  color: Colors.red,
                  onPressed: () {}),
            ],
          )
        : SizedBox();
  }
}
