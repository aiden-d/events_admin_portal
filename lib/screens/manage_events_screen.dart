import 'package:flutter/material.dart';
import 'package:amcham_admin_web/components/rounded_button.dart';
import 'package:amcham_admin_web/components/rounded_text_field.dart';
import 'package:amcham_admin_web/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:amcham_admin_web/components/item_manager.dart';

final _managerStream = new ManageItemStream(
  collectionName: 'Events',
  documentName: null,
  variableName: 'title',
  isDocumentSnapshot: false,
  hintText: 'Enter title',
  deleteFunction: (item) {},
);

class ManageEventsScreen extends StatefulWidget {
  @override
  _ManageEventsScreenState createState() => _ManageEventsScreenState();
}

class _ManageEventsScreenState extends State<ManageEventsScreen> {
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _managerStream,
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: _managerStream.getNewValues(),
            ),
            RoundedButton(
                title: 'REFRESH',
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ManageEventsScreen()));
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
                            builder: (context) => ManageEventsScreen()));
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
