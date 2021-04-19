import 'package:flutter/material.dart';
import 'package:amcham_admin_web/components/rounded_button.dart';
import 'package:amcham_admin_web/components/rounded_text_field.dart';
import 'package:amcham_admin_web/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:amcham_admin_web/components/item_manager.dart';

final _managerStream = new ManageItemStream(
  collectionName: 'News',
  documentName: null,
  variableName: 'title',
  isDocumentSnapshot: false,
  hintText: 'Enter title',
  deleteFunction: (item) {},
  isNews: true,
  orderVar: "date_time",
);

class ManageNewsScreen extends StatefulWidget {
  @override
  _ManageNewsScreenState createState() => _ManageNewsScreenState();
}

class _ManageNewsScreenState extends State<ManageNewsScreen> {
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
                          builder: (context) => ManageNewsScreen()));
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
                            builder: (context) => ManageNewsScreen()));
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
