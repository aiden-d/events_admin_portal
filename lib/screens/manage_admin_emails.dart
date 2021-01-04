import 'dart:js';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:amcham_admin_web/constants.dart';
import 'package:amcham_admin_web/components/rounded_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:amcham_admin_web/components/rounded_text_field.dart';
import 'package:amcham_admin_web/components/item_manager.dart';

final _firestore = Firestore.instance;

class ManageAdminMembers extends StatefulWidget {
  @override
  _ManageAdminMembersState createState() => _ManageAdminMembersState();
}

class _ManageAdminMembersState extends State<ManageAdminMembers> {
  ManageItemStream _managerStream = new ManageItemStream(
    collectionName: 'Admin',
    documentName: 'admin_permissions',
    variableName: 'admin_emails',
    isDocumentSnapshot: true,
    hintText: 'Enter email',

    //deleteFunction: (item){_managerStream.de},
  );
  void test(item) {
    setState(() {});
  }

  bool isLoading = false;

  @override
  void initState() {
    _managerStream.setNewValues([]);

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
            _managerStream,
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: _managerStream.getNewValues(),
            ),
            RoundedButton(
                title: 'ADD NEW',
                onPressed: () {
                  setState(() {
                    List<ManagerItem> val = _managerStream.getNewValues();
                    val.add(ManagerItem(
                      deleteFunction: (item) {
                        setState(() {
                          List<ManagerItem> v = _managerStream.getNewValues();
                          v.remove(item);
                          _managerStream.setNewValues(v);
                        });
                      },
                      hintText: 'Enter email',
                      prevValue: '',
                      isFromWeb: false,
                    ));
                    _managerStream.setNewValues(val);
                  });
                }),
            RoundedButton(
                isLoading: isLoading,
                title: 'PUBLISH',
                onPressed: () async {
                  setState(() {
                    isLoading = true;
                  });
                  await _managerStream.publishChanges(pushClass: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ManageAdminMembers()));
                  });
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
}
