import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:amcham_admin_web/components/app_bar.dart';
import 'package:amcham_admin_web/components/rounded_button.dart';
import 'package:amcham_admin_web/components/rounded_text_field.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class TestingScreen extends StatefulWidget {
  @override
  _TestingScreenState createState() => _TestingScreenState();
}

class _TestingScreenState extends State<TestingScreen> {
  String path = '';
  bool loadingB = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        backgroundColor: Colors.white,
        body: Column(
          children: [
            RoundedTextField(
              onChanged: (s) {
                path = s;
              },
            ),
            RoundedButton(
                isLoading: loadingB,
                title: 'Pick',
                onPressed: () async {
                  setState(() {
                    loadingB = true;
                  });
                  path = path.replaceAll('/', '%2F');
                  print(path);

                  var res = await http.get(
                      "https://us-central1-amcham-app.cloudfunctions.net/uploadVid?path=$path");
                  print(res.body);

                  setState(() {
                    loadingB = false;
                  });
                }),
          ],
        ));
  }
}
