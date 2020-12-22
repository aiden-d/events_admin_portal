import 'package:amcham_admin_web/components/input_item.dart';
import 'package:amcham_admin_web/components/rounded_button.dart';

import 'package:amcham_admin_web/components/select_item.dart';
import 'package:flutter/material.dart';
import 'package:amcham_admin_web/constants.dart';
import 'package:firebase/firebase.dart' as fb;
import 'dart:html';

import 'package:flutter/services.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:cloud_firestore/cloud_firestore.dart';

class CreateEventScreen extends StatefulWidget {
  @override
  _CreateEventScreenState createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  bool isMembersOnly = false;

  bool isLoading = false;

  //input variables
  String title;
  String summary;
  String info;
  String type;
  int price;
  String category;
  String link;

  //validation
  bool isImageSelected = false;
  bool isDateSelected = false;
  bool isStartTimeSelected = false;
  bool isEndTimeSelected = false;
  //TODO

  //
  int maxTitleChar = 25;
  int maxComponentChar = 15;
  //validation end
  double imageSize = 200;
  DateTime date;
  TimeOfDay startTime;
  TimeOfDay endTime;
  File imageFile;
  String imageNameOnFirebase;

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  void pickImage() async {
    InputElement uploadInput = FileUploadInputElement()..accept = 'image/*';
    uploadInput.click();

    uploadInput.onChange.listen((event) async {
      final file = uploadInput.files.first;
      imageSize = double.parse(file.size.toString()) / 1000;
      print(imageSize);
      if (imageSize <= 150 && file != null) {
        setState(() {
          imageFile = file;
          isImageSelected = true;
        });
        await uploadImage();
      } else if (imageSize > 150) {
        return _alertDialogBuilder('Image too large',
            'Please reduce the size of the image to keep the app running smoothly and reduce data costs');
        print('file too large');
        //TODO show error popup box
      } else {
        print('error with picker');
        return;
      }

      return file;
    });

    return null;
  }

  Future<void> uploadImage() async {
    final dateTime = DateTime.now();
    imageNameOnFirebase =
        '${dateTime.toString()}.${imageFile.name == 'jpeg' ? 'jpg' : imageFile.name}';
    firebase_storage.Reference ref =
        firebase_storage.FirebaseStorage.instance.ref(imageNameOnFirebase);
    return ref.putBlob(imageFile.slice());
  }

  void uploadToStorage() {
    final dateTime = DateTime.now();
  }

  Future<void> _alertDialogBuilder(String title, String message) async {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
            content: Container(
              child: Text(message),
            ),
            actions: [
              FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Close Dialog"))
            ],
          );
        });
  }

  int getDateInt(DateTime _date) {
    int dateInt;
    String dateString;
    dateString =
        '${_date.year}${_date.month < 10 ? '0' + _date.month.toString() : _date.month}${_date.day < 10 ? '0' + _date.day.toString() : _date.day}';
    dateInt = int.parse(dateString);
    return dateInt;
    //TODO
  }

  int getTimeInt(TimeOfDay _time) {
    int timeInt;
    String timeString;
    timeString =
        '${_time.hour < 10 ? '0' + _time.hour.toString() : _time.hour}${_time.minute < 10 ? '0' + _time.minute.toString() : _time.minute}';
    timeInt = int.parse(timeString);
    return timeInt;
  }

  Future<bool> validateAndUpload() async {
    if (isImageSelected == true &&
        isDateSelected == true &&
        isStartTimeSelected == true &&
        isEndTimeSelected == true) {
    } else {
      _alertDialogBuilder('Error', 'Make sure to select items with red text');
      return false;
    }
    if (title == null) {
      _alertDialogBuilder('Error', 'Title cannot be blank');
      return false;
    } else if (title.characters.length > maxTitleChar) {
      _alertDialogBuilder(
          'Error', 'Title is too long (max $maxTitleChar characters)');
      return false;
    }

    if (type == null) {
      _alertDialogBuilder('Error', 'Event Type cannot be blank');
      return false;
    } else if (type.characters.length > maxComponentChar) {
      _alertDialogBuilder(
          'Error', 'Event Type is too long (max $maxComponentChar characters)');
      return false;
    }

    if (category == null) {
      _alertDialogBuilder('Error', 'Category cannot be blank');
      return false;
    } else if (category.characters.length > maxComponentChar) {
      _alertDialogBuilder(
          'Error', 'Category is too long (max $maxComponentChar characters)');
      return false;
    }

    if (price == null) {
      _alertDialogBuilder('Error', 'Price cannot be blank');
      return false;
    }
    if (link == null) {
      _alertDialogBuilder('Error', 'Link cannot be blank');
      return false;
    }
    if (summary == null) {
      _alertDialogBuilder('Error', 'Summary cannot be blank');
      return false;
    }
    if (info == null) {
      _alertDialogBuilder('Error', 'Briefing cannot be blank');
      return false;
    }

    await uploadImage();
    //upload to firebase
    CollectionReference eventsFB =
        FirebaseFirestore.instance.collection('Events');
    await eventsFB
        .add({
          'category': category,
          'date': getDateInt(date),
          'end_time': getTimeInt(endTime),
          'image_name': imageNameOnFirebase,
          'info': info,
          'isMembersOnly': isMembersOnly,
          'link': link,
          'price': price,
          'start_time': getTimeInt(startTime),
          'summary': summary,
          'title': title,
          'type': type,
        })
        .then((value) => print("User Added"))
        .catchError((error) => _alertDialogBuilder('Error', error));
    return true;
  }

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
                            onChanged: (value) {
                              title = value;
                            }),
                        InputItem(
                            title: 'Event Type',
                            hint: 'Input event type (eg: livestream)',
                            onChanged: (value) {
                              type = value;
                            }),
                        InputItem(
                            title: 'Category',
                            hint: 'Input event category (eg: Technology)',
                            onChanged: (value) {
                              category = value;
                            }),
                        InputItem(
                            isNumber: true,
                            title: 'Price in R',
                            hint: 'Price in R',
                            onChanged: (value) {
                              price = int.parse(value);
                            }),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Wrap(
                      spacing: 30.0, // gap between adjacent chips
                      runSpacing: 8.0,
                      children: [
                        SelectItem(
                          width: 100,
                          isNoError: isImageSelected,
                          buttonText: 'Select New Image (max 150KB)',
                          title: isImageSelected == true
                              ? 'Image Selected (${imageFile.name})'
                              : 'Image Not Selected',
                          onPressed: () async {
                            pickImage();
                          },
                        ),
                        SelectItem(
                          isNoError: isDateSelected,
                          title: isDateSelected == true
                              ? 'Date Selected (${date.day < 10 ? '0' + date.day.toString() : date.day}-${date.month < 10 ? "0" + date.month.toString() : date.month}-${date.year})'
                              : 'Date Not Selected',
                          buttonText: 'Select New Date',
                          onPressed: () async {
                            DateTime tempDate = await showDatePicker(
                                context: context,
                                initialDate:
                                    date != null ? date : DateTime.now(),
                                firstDate: DateTime.now(),
                                lastDate: DateTime(2999));
                            setState(() {
                              date = tempDate;
                              if (date != null) {
                                isDateSelected = true;
                              }
                            });
                          },
                        ),
                        SelectItem(
                          isNoError: isStartTimeSelected,
                          title: isStartTimeSelected == true
                              ? 'Start Time Selected (${startTime.hour < 10 ? '0' + startTime.hour.toString() : startTime.hour}:${startTime.minute < 10 ? '0' + startTime.minute.toString() : startTime.minute.toString()})'
                              : 'Start Time Not Selected',
                          buttonText: 'Select New Time',
                          onPressed: () async {
                            TimeOfDay tempTime = await showTimePicker(
                              context: context,
                              initialTime: startTime != null
                                  ? startTime
                                  : TimeOfDay.now(),
                            );
                            setState(() {
                              startTime = tempTime;
                              if (startTime != null) {
                                isStartTimeSelected = true;
                              }
                            });
                          },
                        ),
                        SelectItem(
                          isNoError: isEndTimeSelected,
                          title: isEndTimeSelected == true
                              ? 'End Time Selected (${endTime.hour < 10 ? '0' + endTime.hour.toString() : endTime.hour}:${endTime.minute < 10 ? '0' + endTime.minute.toString() : endTime.minute.toString()})'
                              : 'End Time Not Selected',
                          buttonText: 'Select New Time',
                          onPressed: () async {
                            TimeOfDay tempTime = await showTimePicker(
                              context: context,
                              initialTime:
                                  endTime != null ? endTime : TimeOfDay.now(),
                            );
                            setState(() {
                              endTime = tempTime;
                              if (endTime != null) {
                                isEndTimeSelected = true;
                              }
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 20),
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
                            onChanged: (value) {
                              link = value;
                            },
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 20),
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
                              onChanged: (value) {
                                summary = value;
                              },
                              keyboardType: TextInputType.multiline,
                              maxLines: null, //grow automatically

                              decoration: new InputDecoration.collapsed(
                                hintText: 'Please enter the summary',
                              ),
                            ),
                            // ends the actual text box
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 20),
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
                              onChanged: (value) {
                                info = value;
                              },
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
                  SizedBox(
                    height: 50,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
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
                        },
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      RoundedButton(
                        isLoading: isLoading,
                        width: 50,
                        title: 'Create Event',
                        onPressed: () async {
                          //TODO impiment is loading
                          setState(() {
                            isLoading = true;
                          });

                          bool isGood = await validateAndUpload();
                          setState(() {
                            isLoading = false;
                          });

                          if (isGood == true) {
                            _alertDialogBuilder('Finished',
                                'Your event has been uploaded and should now appear on the app.');
                          }
                        },
                      ),
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
