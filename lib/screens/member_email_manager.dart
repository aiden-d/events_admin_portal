import 'package:amcham_admin_web/components/rounded_button.dart';
import 'package:amcham_admin_web/components/rounded_text_field.dart';
import 'package:amcham_admin_web/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:amcham_admin_web/components/item_manager.dart';

final _firestore = Firestore.instance;
final _managerStream = ManageItemStream(
  collectionName: 'Admin',
  documentName: 'member_emails',
  variableName: 'member_emails',
  hintText: 'Enter email ending',
  isDocumentSnapshot: true,
);

class MemberEmailManager extends StatefulWidget {
  @override
  _MemberEmailManagerState createState() => _MemberEmailManagerState();
}

class _MemberEmailManagerState extends State<MemberEmailManager> {
  bool isLoading = false;
  @override
  void initState() {
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
                      hintText: 'Enter email ending',
                      prevValue: '',
                      isFromWeb: false,
                      deleteFunction: (item) {
                        setState(() {
                          List<ManagerItem> v = _managerStream.getNewValues();
                          v.remove(item);
                          _managerStream.setNewValues(v);
                        });
                      },
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
                            builder: (context) => MemberEmailManager()));
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
