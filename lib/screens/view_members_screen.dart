import 'package:amcham_admin_web/components/item_manager.dart';
import 'package:amcham_admin_web/components/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:amcham_admin_web/constants.dart';
import 'package:clipboard/clipboard.dart';

class ViewMembersScreen extends StatefulWidget {
  final String id;
  final String title;
  ViewMembersScreen({@required this.id, @required this.title});
  @override
  _ViewMembersScreenState createState() => _ViewMembersScreenState(id: id);
}

class _ViewMembersScreenState extends State<ViewMembersScreen> {
  final String id;
  final String title;
  _ViewMembersScreenState({@required this.id, @required this.title});
  ManageItemStream _manageItemStream;
  @override
  void initState() {
    try {
      _manageItemStream = new ManageItemStream(
          collectionName: 'Events',
          documentName: id,
          variableName: 'registered_users',
          isDocumentSnapshot: true,
          shouldBeTextField: false,
          hintText: '');
    } catch (error) {
      print(error);
    }

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
      backgroundColor: Constants.blueThemeColor,
      body: Column(
        children: [
          _manageItemStream,
          RoundedButton(
              title: 'Copy As CSV',
              onPressed: () {
                String items = '';
                print(ManageItemStream.items[0].prevValue);
                for (ManagerItem i in ManageItemStream.items) {
                  items = items + i.prevValue + ',';
                }
                items = items.substring(0, items.length - 1);
                print(items);
                FlutterClipboard.copy(items).then((value) => print('copied'));
              })
        ],
      ),
    );
  }
}
