import 'dart:typed_data';
import 'package:path/path.dart' as Path;
import 'package:amcham_admin_web/components/input_item.dart';
import 'package:amcham_admin_web/components/rounded_button.dart';
import 'package:amcham_admin_web/components/rounded_text_field.dart';

import 'package:amcham_admin_web/components/select_item.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:amcham_admin_web/constants.dart';

import 'dart:html';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:image_picker/image_picker.dart';

import '../components/rounded_button.dart';

class CreateNewsScreen extends StatefulWidget {
  final Map<String, dynamic>? data;
  CreateNewsScreen({this.data});

  @override
  _CreateNewsScreenState createState() =>
      _CreateNewsScreenState(data: this.data);
}

class _CreateNewsScreenState extends State<CreateNewsScreen> {
  final Map<String, dynamic>? data;
  _CreateNewsScreenState({this.data});

  void initState() {
    if (data != null) {
      print('there is data');
      setState(() {
        title = data!['title'];
        link = data!['link'];
        summary_text = data!['summary_text'];
        info = data!['info'];
        String dateString = data!['date_time'].toString();
        id = data!['id'];
        imageNameOnFirebase = data!['image_name'];
        isImageSelected = true;
      });
    }

    super.initState();
  }

  //
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  bool isLoading = false;
  String? id;
  //input variables
  String? title;
  String? summary_text;
  String? link = '';
  String? info;
  int? dateTimeInt;
  //validation
  bool isImageSelected = false;

  //TODO

  //
  int maxTitleChar = 32;
  int maxComponentChar = 15;
  //validation end
  double imageSize = 200;
  late DateTime date;
  File? imageFile;
  String? imageNameOnFirebase;

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

  List<String> seperateWords(String? str) {
    if (str == '') {
      print('string cannot be null');
      return [''];
    }

    String strCopy = str!.trim();
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

  List<List<int>> GenerateHashes() {
    List<int> tier1Hashes = [];
    List<int> tier2Hashes = [];
    List<int> tier3Hashes = [];
    List<int> tier4Hashes = [];
//Tier 1
    List<String> tier1words = seperateWords(title);
    for (String s in tier1words) {
      tier1Hashes.add(generateSimpleHash(s.toLowerCase()));
    }
//Tier 2
    List<String> tier2words = [];
    tier2words.add(monthToString(date.month));
    tier2words.add(date.day.toString());
    tier2words.add(date.year.toString());
    //TODO add speakers
    for (String s in tier2words) {
      if (s == 'Livestream') {
        print('livestream ==== ${generateSimpleHash(s.toLowerCase())}');
      }
      tier2Hashes.add(generateSimpleHash(s.toLowerCase()));
      //TODO delete below

    }
    //Tier 3
    List<String> tier3words = seperateWords(summary_text);
    for (String s in tier3words) {
      tier3Hashes.add(generateSimpleHash(s.toLowerCase()));
    }
    //Tier 4
    List<String> tier4words = seperateWords(info);
    for (String s in tier4words) {
      tier4Hashes.add(generateSimpleHash(s.toLowerCase()));
    }
    return [tier1Hashes, tier2Hashes, tier3Hashes, tier4Hashes];
  }

  int generateSimpleHash(String str) {
    int length = str.length;
    int i = 0;
    String s = '';
    while (i < length) {
      s = s + getPlaceInAlphabet(str[i]).toString() + '0';
      i++;
    }
    if (s.length < 18) {
      s = s.substring(0, s.length);
    } else {
      s = s.substring(0, 18);
    }

    return int.parse(s);
  }

  int getPlaceInAlphabet(String str) {
    if (str == 'a') {
      return 1;
    }
    if (str == 'b') {
      return 2;
    }
    if (str == 'c') {
      return 3;
    }
    if (str == 'd') {
      return 4;
    }
    if (str == 'e') {
      return 5;
    }
    if (str == 'f') {
      return 6;
    }
    if (str == 'g') {
      return 7;
    }
    if (str == 'h') {
      return 8;
    }
    if (str == 'i') {
      return 9;
    }
    if (str == 'j') {
      return 10;
    }
    if (str == 'k') {
      return 11;
    }
    if (str == 'l') {
      return 12;
    }
    if (str == 'm') {
      return 13;
    }
    if (str == 'n') {
      return 14;
    }
    if (str == 'o') {
      return 15;
    }
    if (str == 'p') {
      return 16;
    }
    if (str == 'q') {
      return 17;
    }
    if (str == 'r') {
      return 18;
    }
    if (str == 's') {
      return 19;
    }
    if (str == 't') {
      return 20;
    }
    if (str == 'u') {
      return 21;
    }
    if (str == 'v') {
      return 22;
    }
    if (str == 'w') {
      return 23;
    }
    if (str == 'x') {
      return 24;
    }
    if (str == 'y') {
      return 25;
    }
    if (str == 'z') {
      return 26;
    }
    if (str == '1') {
      return 27;
    }
    if (str == '2') {
      return 28;
    }
    if (str == '3') {
      return 29;
    }
    if (str == '4') {
      return 30;
    }
    if (str == '5') {
      return 31;
    }
    if (str == '6') {
      return 32;
    }
    if (str == '7') {
      return 33;
    }
    if (str == '8') {
      return 34;
    }
    if (str == '9') {
      return 35;
    }
    return 36;
  }

  void pickImage() async {
    final _picker = ImagePicker();
    PickedFile? pickedFile =
        await _picker.getImage(source: ImageSource.gallery) as PickedFile;

    Uint8List imageData = await pickedFile.readAsBytes();
    imageSize = imageData.lengthInBytes / 1000;

    if (imageSize <= 150 && pickedFile != null) {
      setState(() {
        print("path=" + pickedFile.path);
        isImageSelected = true;
      });
      await uploadImage(pickedFile);
      return;
    } else if (imageSize > 150) {
      return _alertDialogBuilder('Image too large',
          'Please reduce the size of the image to keep the app running smoothly and reduce data costs');
    } else {
      print('error with picker');
      return;
    }

    // uploadInput.onChange.listen((event) async {
    //   final file = uploadInput.files!.first;
    //   print("dir = " + uploadInput.dirName!);
    //   imageSize = double.parse(file.size.toString()) / 1000;
    //   print(imageSize);
    //   if (imageSize <= 150 && file != null) {
    //     setState(() {
    //       imageFile = file;
    //       isImageSelected = true;
    //     });
    //     await uploadImage();
    //   } else if (imageSize > 150) {
    //     return _alertDialogBuilder('Image too large',
    //         'Please reduce the size of the image to keep the app running smoothly and reduce data costs');
    //     print('file too large');
    //     //TODO show error popup box
    //   } else {
    //     print('error with picker');
    //     return;
    //   }
    //   setState(() {
    //     //blobImage = new BlobImage(file, name: file.name);
    //   });

    //   return;
    // });

    // return null;
  }

  Future<void> uploadImage(PickedFile? pickedFile) async {
    print("Basename = " + Path.basename(pickedFile!.path));
    final dateTime = DateTime.now();
    imageNameOnFirebase = "${dateTime.toString()}.jpeg";

    //imageNameOnFirebase = '${Path.basename(pickedFile.path)}';
    firebase_storage.Reference ref =
        firebase_storage.FirebaseStorage.instance.ref(imageNameOnFirebase);
    print("made it to put");

    Uint8List data = await pickedFile.readAsBytes();

    try {
      await ref
          .putData(
        data,
        firebase_storage.SettableMetadata(contentType: 'image/jpeg'),
      )
          .whenComplete(() async {
        await ref.getDownloadURL().then((value) {
          print(value);
        });
      });
    } catch (e) {
      print(e);
    }

    // try {
    //   await ref.put(_data);
    // } catch (e) {
    //   print(e);
    // }

    return;
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
        '${_date.year}${_date.month < 10 ? '0' + _date.month.toString() : _date.month}${_date.day < 10 ? '0' + _date.day.toString() : _date.day}${_date.minute < 10 ? '0' + _date.minute.toString() : _date.minute}';
    dateInt = int.parse(dateString);
    return dateInt;
    //TODO
  }

  Future<bool> validateAndUpload() async {
    date = DateTime.now();
    dateTimeInt = getDateInt(date);
    print('time = ' + dateTimeInt.toString());
    if (isImageSelected == true) {
    } else {
      _alertDialogBuilder('Error', 'Make sure to select items with red text');
      return false;
    }
    if (title == null) {
      _alertDialogBuilder('Error', 'Title cannot be blank');
      return false;
    } else if (title!.characters.length > maxTitleChar) {
      _alertDialogBuilder(
          'Error', 'Title is too long (max $maxTitleChar characters)');
      return false;
    }

    if (summary_text == null) {
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
      //await uploadImage();
    }
    CollectionReference newsFB = FirebaseFirestore.instance.collection('News');

    List<List<int>> hashes = GenerateHashes();
    //upload to firebase
    if (data != null) {
      print('data != null');
      var doc = await newsFB.doc(id).get();
      List? rUsers = [];
      try {
        if (doc['registered_users'] != null) {
          rUsers = doc['registered_users'];
        }
      } catch (e) {
        print('user error');
        print(e);
      }

      await newsFB.doc(id).set({
        'date_time': dateTimeInt,
        'image_name': imageNameOnFirebase,
        'info': info,
        'link': link,

        'summary_text': summary_text,
        'title': title,

        'id': id,
        'registered_users': rUsers,
        //todo FIX
        'tier_1_hashes': hashes[0],
        'tier_2_hashes': hashes[1],
        'tier_3_hashes': hashes[2],
      });
    } else {
      DocumentReference ref = await newsFB.add({'test': 'test'});
      await newsFB.doc(ref.id).set({
        'date_time': dateTimeInt,
        'image_name': imageNameOnFirebase,
        'info': info,
        'summary_text': summary_text,
        'title': title,
        'id': ref.id,
        'tier_1_hashes': hashes[0],
        'tier_2_hashes': hashes[1],
        'tier_3_hashes': hashes[2],
        'link': link,
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
                            hint: 'Input news title',
                            onChanged: (value) {
                              title = value;
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
                                  ? 'Image Selected (${imageFile!.name})'
                                  : 'Image Selected (${imageNameOnFirebase})')
                              : 'Image Not Selected',
                          onPressed: () async {
                            pickImage();
                          },
                        ),
                      ],
                    ),
                  ),
                  RoundedButton(
                      title: "Copy Bullet Point •",
                      onPressed: () {
                        FlutterClipboard.copy('• ');
                      }),
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
                              controller:
                                  TextEditingController(text: summary_text),
                              onChanged: (value) {
                                summary_text = value;
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
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 20),
                    child: Column(
                      children: [
                        Text(
                          'Link/URL (Optional)',
                          style: Constants.logoTitleStyle,
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
                              controller: TextEditingController(text: link),
                              onChanged: (value) {
                                link = value;
                              },
                              keyboardType: TextInputType.multiline,
                              maxLines: null, //grow automatically

                              decoration: new InputDecoration.collapsed(
                                hintText: 'Please enter the link',
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
                  RoundedButton(
                    isLoading: isLoading,
                    width: 50,
                    title: data != null ? 'Update News' : 'Create News',
                    onPressed: () async {
                      //TODO impiment is loading
                      setState(() {
                        isLoading = true;
                      });

                      bool isGood = await validateAndUpload();
                      setState(() {
                        isLoading = false;
                      });

                      if (isGood != false) {
                        await _alertDialogBuilder('Finished',
                            'The News has been uploaded and should now appear on the app.');
                        Navigator.pop(context);
                      }
                    },
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
