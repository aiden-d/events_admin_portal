import 'package:amcham_admin_web/components/alert_dialog_builder.dart';
import 'package:amcham_admin_web/components/rounded_button.dart';
import 'package:amcham_admin_web/screens/create_event_screen.dart';
import 'package:amcham_admin_web/screens/create_news_screen.dart';
import 'package:amcham_admin_web/screens/view_members_screen.dart';
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
  final bool shouldBeTextField;
  final Widget onDataNull;
  final bool isNews;
  final Function(ManagerItem item) deleteFunction;
  final String orderVar;
  bool isDataNull = false;
  bool getIfDataNull() {
    return isDataNull;
  }

  List<ManagerItem> newValues = [];

  ManageItemStream({
    @required this.collectionName,
    @required this.documentName,
    @required this.variableName,
    @required this.isDocumentSnapshot,
    @required this.hintText,
    this.orderVar,
    this.isEditable,
    this.deleteFunction,
    this.shouldBeTextField,
    this.onDataNull,
    this.isNews,
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
                List variableData;
                try {
                  variableData = data[variableName];
                } catch (e) {
                  print(e);
                  isDataNull = true;
                  return onDataNull != null ? onDataNull : Text('No data');
                }
                print('varData = $variableData');
                if (variableData == null) {
                  print('null');
                  isDataNull = true;
                  return onDataNull != null ? onDataNull : Text('No data');
                }
                isDataNull = false;

                for (String e in variableData) {
                  items.add(ManagerItem(
                    shouldBeTextField: shouldBeTextField,
                    deleteFunction: deleteFunction,
                    hintText: hintText,
                    prevValue: e,
                    isFromWeb: true,
                    isNews: isNews,
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
            future: orderVar != null
                ? _firestore
                    .collection(collectionName)
                    .orderBy(orderVar, descending: true)
                    .get()
                : _firestore.collection(collectionName).get(),
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
                    shouldBeTextField: shouldBeTextField,
                    deleteFunction: deleteFunction,
                    hintText: hintText,
                    prevValue: title,
                    isFromWeb: true,
                    docID: doc.id,
                    data: data,
                    isEditable: true,
                    isNews: isNews,
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
      print(items.length);
      List<String> endingsString = [];
      for (var e in items) {
        print('loop');
        if (e == null) {
          //TODO show error
          print('error');
          return null;
        }
        if (e.newValue == "") {
          await _firestore.collection(collectionName).doc(e.docID).delete();
        } else if (await e
            .checkToDeleteSelf(_firestore.collection(collectionName))) {
          print('ii');
        } else {
          print('i');
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
  final Function(ManagerItem item) deleteFunction;
  final Function(ManagerItem item) reAddFunction;
  final bool shouldBeTextField;
  final bool isNews;

  ManagerItem({
    @required this.prevValue,
    @required this.isFromWeb,
    @required this.hintText,
    @required this.isNews,
    this.docID,
    this.data,
    this.isEditable,
    this.deleteFunction,
    this.reAddFunction,
    this.shouldBeTextField,
  });
  String newValue;
  bool isLoading = false;

  bool toBeDeleted = false;
  Future<bool> checkToDeleteSelf(CollectionReference ref) async {
    if (toBeDeleted == true) {
      print('need to delete');
      await ref.doc(docID).delete();
      return true;
    }
    print('no need to delete');
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        shouldBeTextField == false
            ? RoundedButton(title: prevValue, onPressed: null)
            : RoundedTextField(
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
                  if (isNews == true) {
                    print('news is true!');
                  } else {
                    print('news isnt true');
                  }
                  isNews == true
                      ? Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CreateNewsScreen(
                                    data: data,
                                  )))
                      : Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CreateEventScreen(
                                    data: data,
                                  )));
                })
            : SizedBox(),
        isEditable == true
            ? IconButton(
                icon: Icon(CupertinoIcons.person_2),
                color: Colors.white,
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ViewMembersScreen(id: docID)));
                })
            : SizedBox(),
        shouldBeTextField == false
            ? SizedBox()
            : IconButton(
                icon: Icon(CupertinoIcons.xmark_circle),
                color: toBeDeleted == true ? Colors.green : Colors.red,
                onPressed: () {
                  print('to delete');
                  // color = Colors.blue;
                  // (context as Element).markNeedsBuild();
                  if (toBeDeleted != true) {
                    (context as Element).markNeedsBuild();
                    deleteFunction != null
                        ? deleteFunction(this)
                        : ManageItemStream.items.remove(this);
                    toBeDeleted = true;

                    (context as Element).markNeedsBuild();
                  } else {
                    (context as Element).markNeedsBuild();
                    deleteFunction != null
                        ? reAddFunction(this)
                        : ManageItemStream.items.add(this);
                    toBeDeleted = false;

                    (context as Element).markNeedsBuild();
                  }
                })
      ],
    );
  }
}
