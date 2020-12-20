import 'package:amcham_admin_web/components/input_item.dart';
import 'package:amcham_admin_web/components/rounded_text_field.dart';
import 'package:flutter/material.dart';
import 'package:amcham_admin_web/constants.dart';

class CreateEventScreen extends StatefulWidget {
  @override
  _CreateEventScreenState createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Constants.blueThemeColor,
        appBar: AppBar(
          backgroundColor: Colors.white,
          foregroundColor: Constants.blueThemeColor,
          iconTheme: IconThemeData(color: Constants.blueThemeColor),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  InputItem(
                      title: 'Title',
                      hint: 'Input event title',
                      onChanged: null),
                  InputItem(
                      title: 'Event Type',
                      hint: 'Input event type (eg: livestream)',
                      onChanged: null),
                  InputItem(
                      title: 'Category',
                      hint: 'Input event category (eg: Technology)',
                      onChanged: null),
                ],
              ),
              Row(
                children: [
                  InputItem(
                      title: 'Title',
                      hint: 'Input event title',
                      onChanged: null),
                  InputItem(
                      title: 'Event Type',
                      hint: 'Input event type (eg: livestream)',
                      onChanged: null),
                  InputItem(
                      title: 'Info',
                      isMultiLine: true,
                      hint: 'Input event category (eg: Technology)',
                      onChanged: (value) {
                        print(value.toString());
                      }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
