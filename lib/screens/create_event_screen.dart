import 'package:amcham_admin_web/components/input_item.dart';
import 'package:amcham_admin_web/components/rounded_button.dart';
import 'package:amcham_admin_web/components/rounded_text_field.dart';

import 'package:amcham_admin_web/components/select_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:amcham_admin_web/constants.dart';
import 'package:firebase/firebase.dart' as fb;
import 'dart:html';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:cloud_firestore/cloud_firestore.dart';

class CreateEventScreen extends StatefulWidget {
  final Map<String, dynamic> data;
  CreateEventScreen({this.data});

  @override
  _CreateEventScreenState createState() =>
      _CreateEventScreenState(data: this.data);
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  final Map<String, dynamic> data;
  _CreateEventScreenState({this.data});
  ItemListMaker itemListMaker = new ItemListMaker();
  void initState() {
    if (data != null) {
      print('there is data');
      setState(() {
        title = data['title'];
        summary = data['summary'];
        info = data['info'];
        type = data['type'];
        price = data['price'];
        category = data['category'];
        link = data['link'];
        String dateString = data['date'].toString();
        int year = int.parse(dateString.substring(0, 4));
        int month = int.parse(dateString.substring(4, 6));
        int day = int.parse(dateString.substring(6, 8));
        date = DateTime(year, month, day);
        isDateSelected = true;
        String startTimeString = data['start_time'].toString();
        int startHour = int.parse(startTimeString.substring(0, 2));
        int startMin = int.parse(startTimeString.substring(2, 4));
        startTime = TimeOfDay(hour: startHour, minute: startMin);
        isStartTimeSelected = true;
        String endTimeString = data['start_time'].toString();
        int endHour = int.parse(endTimeString.substring(0, 2));
        int endMin = int.parse(endTimeString.substring(2, 4));
        endTime = TimeOfDay(hour: endHour, minute: endMin);
        isEndTimeSelected = true;
        isMembersOnly = data['isMembersOnly'];
        id = data['id'];
        imageNameOnFirebase = data['image_name'];
        isImageSelected = true;
        speakers = data['speakers'];
      });
      print(title);
    }
    itemListMaker = new ItemListMaker(
      passedItemsNames: speakers,
    );
    itemListMaker.generateItems();
    super.initState();
  }

  //
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  bool isMembersOnly = false;

  bool isLoading = false;
  String id;
  //input variables
  String title;
  String summary;
  String info;
  String type = 'Livestream';
  int price = 0;
  String category = 'General';
  String link;
  List speakers;

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

  String monthToString(int monthInt) {
    List<String> dates = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    String month = dates[monthInt - 1];
    return month;
  }

  List<String> seperateWords(String str) {
    if (str == '') {
      print('string cannot be null');
      return [''];
    }

    String strCopy = str.trim();
    int start = 0;
    int i = 0;
    int len = strCopy.length;
    List<String> words = [];
    while (i < len) {
      if (strCopy[i] == ' ') {
        words.add(strCopy.substring(start, i));
        strCopy = strCopy.substring(i + 1, strCopy.length);
        len = strCopy.length;
        i = 0;
      } else {
        i++;
      }
    }
    words.add(strCopy);
    return words;
  }

  List<List<BigInt>> GenerateHashes() {
    List<BigInt> tier1Hashes = [];
    List<BigInt> tier2Hashes = [];
    List<BigInt> tier3Hashes = [];
    List<BigInt> tier4Hashes = [];
//Tier 1
    List<String> tier1words = seperateWords(title);
    for (String s in tier1words) {
      tier1Hashes.add(DJBHash(s));
    }
//Tier 2
    List<String> tier2words = [];
    tier2words.add(category);
    tier2words.add(type);
    tier2words.add(monthToString(date.month));
    tier2words.add(date.day.toString());
    tier2words.add(date.year.toString());
    //TODO add speakers
    for (String s in tier2words) {
      tier2Hashes.add(DJBHash(s));
    }
    //Tier 3
    List<String> tier3words = seperateWords(summary);
    for (String s in tier3words) {
      tier3Hashes.add(DJBHash(s));
    }
    //Tier 4
    List<String> tier4words = seperateWords(info);
    for (String s in tier4words) {
      tier4Hashes.add(DJBHash(s));
    }
    return [tier1Hashes, tier2Hashes, tier3Hashes, tier4Hashes];
  }

  BigInt DJBHash(String str) {
    int len = str.length;
    BigInt _hash = BigInt.from(5381);
    int i = 0;

    List<int> list = utf8.encode(str.toLowerCase());

    for (int i in list) {
      print(i);
      _hash = ((_hash << 5) + _hash) + BigInt.from(i);
    }

    //delete
    if (str == 'Livestream') {
      print('livestream =  $_hash');
    }
    return _hash;
  }

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

  List<double> getDoublesFromBigInt(List<BigInt> bigInts) {
    List<double> returnList = [];

    for (BigInt bigInt in bigInts) {
      double value = double.parse(bigInt.toString());
      returnList.add(value);
    }
    return returnList;
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
    if (imageNameOnFirebase != null && data != null) {
      print('image already on firebase ');
    } else {
      await uploadImage();
    }
    CollectionReference eventsFB =
        FirebaseFirestore.instance.collection('Events');

    int dateInt = getDateInt(date);
    int endTimeInt = getTimeInt(endTime);
    int startTimeInt = getTimeInt(startTime);

    List<List<BigInt>> hashes = GenerateHashes();
    //upload to firebase
    if (data != null) {
      var doc = await eventsFB.doc(id).get();
      List<String> rUsers = [];
      try {
        if (doc['registered_users'] != null) {
          rUsers = doc['registered_users'];
        }
      } catch (e) {
        print(e);
      }

      await eventsFB.doc(id).set({
        'category': category,
        'date': dateInt,
        'end_time': endTimeInt,
        'image_name': imageNameOnFirebase,
        'info': info,
        'isMembersOnly': isMembersOnly,
        'link': link,
        'price': price,
        'start_time': startTimeInt,
        'summary': summary,
        'title': title,
        'type': type,
        'id': id,
        'registered_users': rUsers,
        //todo FIX
        'tier_1_hashes': getDoublesFromBigInt(hashes[0]),
        'tier_2_hashes': getDoublesFromBigInt(hashes[1]),
        'tier_3_hashes': getDoublesFromBigInt(hashes[2]),
        'tier_4_hashes': getDoublesFromBigInt(hashes[3]),
        'speakers': itemListMaker.getAsListString(),
      });
    } else {
      DocumentReference ref = await eventsFB.add({});
      await eventsFB.doc(ref.id).set({
        'category': category,
        'date': dateInt,
        'end_time': endTimeInt,
        'image_name': imageNameOnFirebase,
        'info': info,
        'isMembersOnly': isMembersOnly,
        'link': link,
        'price': price,
        'start_time': startTimeInt,
        'summary': summary,
        'title': title,
        'type': type,
        'id': ref.id,
        'tier_1_hashes': getDoublesFromBigInt(hashes[0]),
        'tier_2_hashes': getDoublesFromBigInt(hashes[1]),
        'tier_3_hashes': getDoublesFromBigInt(hashes[2]),
        'tier_4_hashes': getDoublesFromBigInt(hashes[3]),
        'speakers': itemListMaker.getAsListString(),
      });
    }

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
                            textValue: title,
                            hint: 'Input event title',
                            onChanged: (value) {
                              title = value;
                            }),
                        Column(
                          children: [
                            Text(
                              'Event Type',
                              style: Constants.logoTitleStyle,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 15),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.white,
                              ),
                              child: DropdownButton<String>(
                                value: type,
                                icon: Icon(Icons.arrow_downward),
                                iconSize: 24,
                                elevation: 16,
                                style: TextStyle(color: Colors.black),
                                underline: Container(
                                  height: 2,
                                  color: Colors.black,
                                ),
                                onChanged: (String newValue) {
                                  setState(() {
                                    type = newValue;
                                  });
                                },
                                items: <String>[
                                  'Livestream',
                                  'Virtual Conference',
                                  'Physical Event',
                                  'MS Teams',
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              'Category',
                              style: Constants.logoTitleStyle,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 15),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.white,
                              ),
                              child: DropdownButton<String>(
                                value: category,
                                icon: Icon(Icons.arrow_downward),
                                iconSize: 24,
                                elevation: 16,
                                style: TextStyle(color: Colors.black),
                                underline: Container(
                                  height: 2,
                                  color: Colors.black,
                                ),
                                onChanged: (String newValue) {
                                  setState(() {
                                    category = newValue;
                                  });
                                },
                                items: <String>[
                                  'General',
                                  'BAC Forum',
                                  'Digital Forum',
                                  'Energy Forum',
                                  'Health Forum',
                                  'People Mgt Forum',
                                  'Policy & Gvt Forum',
                                  'Regional Trade Forum',
                                  'Tax Forum',
                                  'Transformation Forum',
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                        InputItem(
                            textValue: price.toString(),
                            isNumber: true,
                            title: 'Price in ZAR',
                            hint: 'Price in ZAR',
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
                              ? (imageFile != null
                                  ? 'Image Selected (${imageFile.name})'
                                  : 'Image Selected (${imageNameOnFirebase})')
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
                  itemListMaker,
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
                            controller: TextEditingController(text: link),
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
                              controller: TextEditingController(text: summary),
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
                              controller: TextEditingController(text: info),
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
                        title: data != null ? 'Update Event' : 'Create Event',
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
                            Navigator.pop(context);
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

class ItemListMaker extends StatelessWidget {
  ItemListMaker({this.passedItemsNames});
  final List passedItemsNames;
  List<Item> items = [];
  bool removeItem(Item item) {
    bool b = items.remove(item);
    return b;
  }

  void generateItems() {
    print('passed item ${passedItemsNames.toString()}');
    if (passedItemsNames == null || passedItemsNames == []) {
      items.add(Item(
        listMaker: this,
        title: '',
      ));
    } else {
      for (String str in passedItemsNames) {
        items.add(Item(
          title: str,
          listMaker: this,
        ));
      }
    }
  }

  void checkIfNone() {
    if (items == null) {
      items.add(Item(
        listMaker: this,
        title: '',
      ));
    }
  }

  List<String> getAsListString() {
    List<String> list = [];
    for (Item i in items) {
      if (i.title != null && i.title != '') {
        list.add(i.title);
      }
    }
    print('list = ${list.toString()}');
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Speakers',
          style: Constants.logoTitleStyle,
        ),
        Column(
          children: items,
        ),
        RoundedButton(
            title: 'Add New',
            onPressed: () {
              items.add(Item(
                title: '',
                listMaker: this,
              ));
              (context as Element).markNeedsBuild();
            }),
      ],
    );
  }
}

class Item extends StatelessWidget {
  String title;
  bool isDeleted = false;
  final ItemListMaker listMaker;
  Item({this.title, this.listMaker});

  @override
  Widget build(BuildContext context) {
    return isDeleted == false
        ? Center(
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RoundedTextField(
                    hintText: 'Enter a name...',
                    textValue: title,
                    onChanged: (val) {
                      title = val;
                    },
                  ),
                  IconButton(
                      icon: Icon(
                        CupertinoIcons.xmark_octagon,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        print('pressed');
                        print(this.toString());
                        if (listMaker.items.length <= 1) {
                          title = '';
                        } else {
                          listMaker.items.remove(this);
                          isDeleted = true;
                        }

                        (context as Element).markNeedsBuild();
                      }),
                ],
              ),
            ),
          )
        : SizedBox();
  }
}
