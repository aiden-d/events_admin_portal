import 'package:amcham_admin_web/components/input_item.dart';
import 'package:amcham_admin_web/components/rounded_button.dart';
import 'package:amcham_admin_web/components/rounded_text_field.dart';
import 'package:flutter/material.dart';
import 'package:amcham_admin_web/constants.dart';
import 'package:flutter_web_image_picker/flutter_web_image_picker.dart';

class CreateEventScreen extends StatefulWidget {
  @override
  _CreateEventScreenState createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  bool isMembersOnly = false;
  //TODO validate input fields
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
        body: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Wrap(
                      spacing: 25.0, // gap between adjacent chips
                      runSpacing: 8.0,

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
                        InputItem(
                            isNumber: true,
                            title: 'Price in R',
                            hint: 'Price in R',
                            onChanged: null),
                        RoundedButton(
                            title: 'Upload Image',
                            onPressed: () async {
                              final _image =
                                  await FlutterWebImagePicker.getImage;
                            })
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Wrap(
                      spacing: 30.0, // gap between adjacent chips
                      runSpacing: 8.0,
                      children: [
                        InputItem(
                            maxLength: 2,
                            isNumber: true,
                            width: 100,
                            title: 'Day',
                            hint: 'Day',
                            onChanged: null),
                        InputItem(
                            maxLength: 2,
                            isNumber: true,
                            width: 150,
                            title: 'Month Number',
                            hint: 'Month',
                            onChanged: null),
                        InputItem(
                            maxLength: 4,
                            isNumber: true,
                            width: 200,
                            title: 'Year',
                            hint: 'Year',
                            onChanged: null),
                        InputItem(
                            maxLength: 2,
                            isNumber: true,
                            width: 100,
                            title: 'Start Hour',
                            hint: 'Hour',
                            onChanged: null),
                        InputItem(
                            maxLength: 2,
                            isNumber: true,
                            width: 100,
                            title: 'Start Minute',
                            hint: 'Minute',
                            onChanged: null),
                        InputItem(
                            maxLength: 2,
                            isNumber: true,
                            width: 100,
                            title: 'End Hour',
                            hint: 'Hour',
                            onChanged: null),
                        InputItem(
                            maxLength: 2,
                            isNumber: true,
                            width: 100,
                            title: 'End Minute',
                            hint: 'Minute',
                            onChanged: null),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(
                          'Link to event',
                          style: Constants.logoTitleStyle,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: Colors.white,
                          ),
                          child: new TextField(
                            //grow automatically

                            decoration: new InputDecoration.collapsed(
                              hintText: 'Link to event',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(
                          'Summary',
                          style: Constants.logoTitleStyle,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: Colors.white,
                          ),
                          child: new SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            reverse: true,

                            // here's the actual text box
                            child: new TextField(
                              keyboardType: TextInputType.multiline,
                              maxLines: null, //grow automatically

                              decoration: new InputDecoration.collapsed(
                                hintText: 'Please enter a lot of text',
                              ),
                            ),
                            // ends the actual text box
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(
                          'Full Briefing',
                          style: Constants.logoTitleStyle,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: Colors.white,
                          ),
                          child: new SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            reverse: true,

                            // here's the actual text box
                            child: new TextField(
                              keyboardType: TextInputType.multiline,
                              maxLines: null, //grow automatically

                              decoration: new InputDecoration.collapsed(
                                hintText: 'Please enter a lot of text',
                              ),
                            ),
                            // ends the actual text box
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        'Members Only? ',
                        style: Constants.logoTitleStyle,
                      ),
                      Checkbox(
                          value: isMembersOnly,
                          onChanged: (value) {
                            setState(() {
                              isMembersOnly = value;
                            });
                          }),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
