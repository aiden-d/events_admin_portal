import 'dart:typed_data';

import 'package:amcham_admin_web/components/input_item.dart';
import 'package:amcham_admin_web/components/rounded_button.dart';
import 'package:amcham_admin_web/components/rounded_text_field.dart';
import 'package:amcham_admin_web/components/select_item.dart';
import 'package:amcham_admin_web/screens/preview_event_screen.dart';
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
import 'package:amcham_admin_web/components/event_item.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;
import 'package:image_compression/image_compression.dart' as _compress;
import 'dart:math';
import 'package:image/image.dart' as img;
import 'dart:convert';
import 'dart:io' as IO;
import 'dart:ui' as ui;

class CreateEventScreen extends StatefulWidget {
  final Map<String, dynamic>? data;
  CreateEventScreen({this.data});

  @override
  _CreateEventScreenState createState() =>
      _CreateEventScreenState(data: this.data);
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  final Map<String, dynamic>? data;
  _CreateEventScreenState({this.data});
  ItemListMaker itemListMaker = new ItemListMaker();
  void initState() {
    if (data != null) {
      print('there is data');
      setState(() {
        title = data!['title'];
        summary = data!['summary'];
        info = data!['info'];
        type = data!['type'];
        price = data!['price'];
        category = data!['category'];
        link = data!['link'];
        youtube_link = data!['youtube_link'];
        if (data!['archetype'] != null) {
          archetype = data!['archetype'];
        }
        String dateString = data!['date'].toString();
        int year = int.parse(dateString.substring(0, 4));
        int month = int.parse(dateString.substring(4, 6));
        int day = int.parse(dateString.substring(6, 8));
        date = DateTime(year, month, day);
        isDateSelected = true;
        String startTimeString = data!['start_time'].toString().length >= 4
            ? data!['start_time'].toString()
            : '0' + data!['start_time'].toString();
        int startHour = int.parse(startTimeString.substring(0, 2));
        int startMin = int.parse(startTimeString.substring(2, 4));
        startTime = TimeOfDay(hour: startHour, minute: startMin);
        isStartTimeSelected = true;
        String endTimeString = data!['end_time'].toString().length >= 4
            ? data!['end_time'].toString()
            : '0' + data!['end_time'].toString();
        int endHour = int.parse(endTimeString.substring(0, 2));
        int endMin = int.parse(endTimeString.substring(2, 4));
        endTime = TimeOfDay(hour: endHour, minute: endMin);
        isEndTimeSelected = true;
        isMembersOnly = data!['isMembersOnly'];
        id = data!['id'];
        imageNameOnFirebase = data!['image_name'];
        isImageSelected = true;
        speakers = List<String>.from(data!['speakers']);
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
  bool? isMembersOnly = false;

  bool isLoading = false;
  String? id;
  bool isImageChanged = false;

  //input variables
  String? title;
  String? summary;
  String? info;
  String? type = 'Livestream';
  String? archetype = "MS Teams";
  int? price = 0;
  int? maxParticipants = 20;
  String? category = 'General';
  String? link = '';
  String? youtube_link = '';
  List<String> speakers = [];

  //validation
  bool isImageSelected = false;
  bool isDateSelected = false;
  bool isStartTimeSelected = false;
  bool isEndTimeSelected = false;
  //TODO
  Uint8List? imageData;
  //
  int maxTitleChar = 80;
  int maxComponentChar = 15;
  //validation end
  double imageSize = 200;
  DateTime? date;
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  File? imageFile;
  String? imageNameOnFirebase;
  Image? image;
  PickedFile? pickedImageFile;
  //BlobImage blobImage;

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
    List<String?> tier2words = [];
    tier2words.add(category);
    tier2words.add(type);
    tier2words.add(monthToString(date!.month));
    tier2words.add(date!.day.toString());
    tier2words.add(date!.year.toString());
    //TODO add speakers
    for (String? s in tier2words) {
      if (s == 'Livestream') {
        print('livestream ==== ${generateSimpleHash(s!.toLowerCase())}');
      }
      tier2Hashes.add(generateSimpleHash(s!.toLowerCase()));
      //TODO delete below

    }
    //Tier 3
    List<String> tier3words = seperateWords(summary);
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

    PickedFile? pickedFile = await _picker.getImage(
        source: ImageSource.gallery,
        maxWidth: 640,
        maxHeight: 480,
        imageQuality: 65) as PickedFile;

    if (pickedFile != null) {
      imageData = await pickedFile.readAsBytes();
      imageSize = imageData!.lengthInBytes / 1000;
      pickedImageFile = pickedFile;
      setState(() {
        image = Image.network(pickedFile.path, width: 640, height: 480);

        //image = Image.network(pickedFile.path);
        print("path=" + pickedFile.path);
        isImageSelected = true;
        isImageChanged = true;
      });
      //await uploadImage(pickedFile);
      return;
    }
    // else if (imageSize > 150) {
    //   return _alertDialogBuilder('Image too large',
    //       'Please reduce the size of the image to keep the app running smoothly and reduce data costs');
    // }
    else {
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
    //final file = pickedImageFile;

    //var imageData = await file!.readAsBytes();
    //var imageSize = imageData.lengthInBytes;
    print("imageSize = " + imageSize.toString());

    //ImageFile imageFile =
    //    new ImageFile(filePath: file.path, rawBytes: imageData);
    // print("Basename = " + Path.basename(pickedFile!.path));
    // if (imageSize > 150 * 1000) {
    //   var input = imageFile;
    //   var quality = 10;

    //   final output = await compressInQueue(ImageFileConfiguration(
    //       input: input,
    //       config: Configuration(
    //           pngCompression: PngCompression.bestSpeed,
    //           jpgQuality: quality,
    //           animationGifSamplingFactor: 30)));
    //   imageFile = output;
    //   imageSize = imageFile.sizeInBytes;

    //   print("Size = " + imageSize.toString());
    // }
    // imageData = imageFile.rawBytes;

    // double width = image!.width!;
    // double height = image!.height!;
    // double ratio = height / width;
    // var newSize = 150000;
    // var newPixels = (width * height * (newSize / imageSize)).toInt();
    // var pixels = width * height;
    // print("current pixels = {$pixels}");
    // print("Target pixels = {$newPixels}");
    // var newWidth = sqrt((newPixels) / (ratio)).toInt();
    // print("width = ${width}");
    // print("new width = " + newWidth.toString());
    // var im = img.decodeImage(imageData!);
    // var newImg = img.copyResize(im!,
    //     width: 500,
    //     //height: (newWidth * ratio).toInt(),
    //     interpolation: img.Interpolation.average);
    // var imgBytes = newImg.getBytes();
    // //ImageFile()
    // print("new bytes = " + imgBytes.length.toString());
    // // //return;

    // var resizeImage = ResizeImage(MemoryImage(imageData),
    //     width: newWidth.toInt(), height: (newWidth * ratio).toInt());

    // ui.Image image = new ui.Image(
    //   image: resizeImage,
    // );

    final dateTime = DateTime.now();
    //final imgBytes = await file!.readAsBytes();
    final name = dateTime.toString();
    imageNameOnFirebase = "${name}.jpeg";

    //print(' size = ${imgBytes.length}');

    //imageNameOnFirebase = '${Path.basename(pickedFile.path)}';
    firebase_storage.Reference ref =
        firebase_storage.FirebaseStorage.instance.ref(imageNameOnFirebase);
    print("made it to put");
    Uint8List data = imageData!;

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
    imageNameOnFirebase = name + "_640x480.jpeg";

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

  int getDateTimeInt() {
    int val = int.parse(date!.year.toString() +
        (date!.month > 9
            ? date!.month.toString()
            : '0' + date!.month.toString()) +
        (date!.day > 9 ? date!.day.toString() : '0' + date!.day.toString()) +
        (endTime!.hour > 9
            ? endTime!.hour.toString()
            : '0' + endTime!.hour.toString()) +
        (endTime!.minute > 9
            ? endTime!.minute.toString()
            : '0' + endTime!.minute.toString()));
    return val;
  }

  int getTimeInt(TimeOfDay _time) {
    int timeInt;
    String timeString;
    timeString =
        '${_time.hour < 10 ? '0' + _time.hour.toString() : _time.hour}${_time.minute < 10 ? '0' + _time.minute.toString() : _time.minute}';
    timeInt = int.parse(timeString);
    return timeInt;
  }

  bool validate() {
    try {
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
      } else if (title!.characters.length > maxTitleChar) {
        _alertDialogBuilder(
            'Error', 'Title is too long (max $maxTitleChar characters)');
        return false;
      }

      if (category == null) {
        _alertDialogBuilder('Error', 'Category cannot be blank');
        return false;
      }
      if (price == null) {
        _alertDialogBuilder('Error', 'Price cannot be blank');
        return false;
      }
      if (link == null && archetype != "Youtube") {
        _alertDialogBuilder('Error', 'Link cannot be blank');
        return false;
      }
      if (youtube_link == null && archetype == "Youtube") {
        _alertDialogBuilder('Error', 'Link cannot be blank');
        return false;
      }

      try {
        if (archetype == "Youtube") {
          print(youtube_link!.substring(0, 8));
          if (youtube_link!.substring(0, 8) != 'https://' &&
              youtube_link!.substring(0, 7) != 'http://') {
            _alertDialogBuilder(
                'Error', 'Link must contain https:// or http://');
            print("ii");
            return false;
          }
        } else {
          if (link!.substring(0, 8) != 'https://' &&
              link!.substring(0, 7) != 'http://') {
            _alertDialogBuilder(
                'Error', 'Link must contain https:// or http://');
            return false;
          }
        }
      } catch (e) {
        print("i");
        _alertDialogBuilder('Error', 'Link must contain https:// or http://');
        return false;
      }

      if (summary == null) {
        _alertDialogBuilder('Error', 'Summary cannot be blank');
        return false;
      }
      if (youtube_link == null && archetype == "Youtube") {
        _alertDialogBuilder('Error', 'Link cannot be blank');
        return false;
      }

      if (info == null) {
        _alertDialogBuilder('Error', 'Briefing cannot be blank');
        return false;
      }
      // if (blobImage == null && imageNameOnFirebase == null) {
      //   _alertDialogBuilder('Error', 'Image cannot be blank');
      //   return false;
      // }
      return true;
    } catch (e, stacktrace) {
      print(e);
      print(stacktrace);
      return false;
    }
  }

  Future<bool> validateAndUpload() async {
    if (validate() == false) {
      return false;
    }
    try {
      if (isImageChanged) {
        await uploadImage(pickedImageFile!);
      }

      CollectionReference eventsFB =
          FirebaseFirestore.instance.collection('Events');

      int dateInt = getDateTimeInt();
      int endTimeInt = getTimeInt(endTime!);
      int startTimeInt = getTimeInt(startTime!);

      List<List<int>> hashes = GenerateHashes();
      //upload to firebase
      if (data != null) {
        print('data != null');
        var doc = await eventsFB.doc(id).get();
        List? rUsers = [];
        try {
          if (doc['registered_users'] != null) {
            rUsers = doc['registered_users'];
          }
        } catch (e) {
          print('user error');
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
          'youtube_link': youtube_link,
          'price': price,
          'start_time': startTimeInt,
          'summary': summary,
          'title': title,
          'type': type,
          'id': id,
          'registered_users': rUsers,
          //todo FIX
          'tier_1_hashes': hashes[0],
          'tier_2_hashes': hashes[1],
          'tier_3_hashes': hashes[2],
          'tier_4_hashes': hashes[3],
          'speakers': itemListMaker.getAsListString(),
          'archetype': archetype
        });
      } else {
        DocumentReference ref = await eventsFB.add({'test': 'test'});
        await eventsFB.doc(ref.id).set({
          'category': category,
          'date': dateInt,
          'end_time': endTimeInt,
          'image_name': imageNameOnFirebase,
          'info': info,
          'isMembersOnly': isMembersOnly,
          'link': link,
          'youtube_link': youtube_link,
          'price': price,
          'start_time': startTimeInt,
          'summary': summary,
          'title': title,
          'type': type,
          'id': ref.id,
          'tier_1_hashes': hashes[0],
          'tier_2_hashes': hashes[1],
          'tier_3_hashes': hashes[2],
          'tier_4_hashes': hashes[3],
          'speakers': itemListMaker.getAsListString(),
          'archetype': archetype
        });
      }
      print("all good");

      return true;
    } catch (e, stacktrace) {
      print(e);
      print(stacktrace);
      return false;
    }
  }

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
                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white),
                        width: MediaQuery.of(context).size.width,
                        height: 50,
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Event Archetype: ",
                                style: Constants.regularHeading,
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              DropdownButton<String>(
                                value: archetype,
                                icon: Icon(Icons.arrow_downward),
                                iconSize: 24,
                                elevation: 16,
                                style: TextStyle(color: Colors.black),
                                underline: Container(
                                  height: 2,
                                  color: Colors.black,
                                ),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    archetype = newValue;
                                    if (archetype != "External Event") {
                                      price = 0;
                                    }
                                    if (archetype == "MS Teams" ||
                                        archetype == "Physical Event")
                                      isMembersOnly = true;
                                    else
                                      isMembersOnly = false;
                                  });
                                },
                                items: <String>[
                                  'MS Teams',
                                  'Youtube',
                                  'External Event',
                                  // 'Physical Event',
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        )),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Wrap(
                      runAlignment: WrapAlignment.spaceEvenly,
                      children: [
                        InputItem(
                            title: 'Title',
                            textValue: title,
                            hint: 'Input event title',
                            onChanged: (value) {
                              title = value;
                            }),
                        SizedBox(
                          width: 30,
                        ),
                        archetype == "External Event"
                            ? Column(
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
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          type = newValue;
                                        });
                                      },
                                      items: <String>[
                                        'Livestream',
                                        'Virtual Conference',
                                        'Physical Event',
                                      ].map<DropdownMenuItem<String>>(
                                          (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                    ),
                                  )
                                ],
                              )
                            : SizedBox(),
                        Column(
                          children: [],
                        ),
                        SizedBox(
                          width: 30,
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
                                onChanged: (String? newValue) {
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
                        SizedBox(
                          width: 30,
                        ),
                        archetype == "Paid Event"
                            ? InputItem(
                                textValue: price.toString(),
                                isNumber: true,
                                title: 'Price in ZAR',
                                hint: 'Price in ZAR',
                                onChanged: (value) {
                                  price = int.parse(value);
                                })
                            : SizedBox(),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Wrap(
                      runAlignment: WrapAlignment.spaceEvenly,
                      alignment: WrapAlignment.spaceEvenly,

                      // spacing: 30.0, // gap between adjacent chips
                      // runSpacing: 8.0,
                      children: [
                        SelectItem(
                          width: 100,
                          isNoError: isImageSelected,
                          buttonText: 'Select New Image',
                          title: isImageSelected == true
                              ? (imageFile != null
                                  ? 'Image Selected'
                                  : 'Image Selected')
                              : 'Image Not Selected',
                          onPressed: () async {
                            pickImage();
                          },
                        ),
                        isImageSelected == true && image != null
                            ? Container(
                                width: 40,
                                height: 22,
                                child: image,
                              )
                            : SizedBox(),
                        SelectItem(
                          isNoError: isDateSelected,
                          title: isDateSelected == true
                              ? 'Date Selected (${date!.day < 10 ? '0' + date!.day.toString() : date!.day}-${date!.month < 10 ? "0" + date!.month.toString() : date!.month}-${date!.year})'
                              : 'Date Not Selected',
                          buttonText: 'Select New Date',
                          onPressed: () async {
                            DateTime? tempDate = await showDatePicker(
                                context: context,
                                initialDate:
                                    date != null ? date! : DateTime.now(),
                                firstDate: DateTime(1999),
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
                              ? 'Start Time Selected (${startTime!.hour < 10 ? '0' + startTime!.hour.toString() : startTime!.hour}:${startTime!.minute < 10 ? '0' + startTime!.minute.toString() : startTime!.minute.toString()})'
                              : 'Start Time Not Selected',
                          buttonText: 'Select New Time',
                          onPressed: () async {
                            TimeOfDay? tempTime = await showTimePicker(
                              context: context,
                              initialTime: startTime != null
                                  ? startTime!
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
                              ? 'End Time Selected (${endTime!.hour < 10 ? '0' + endTime!.hour.toString() : endTime!.hour}:${endTime!.minute < 10 ? '0' + endTime!.minute.toString() : endTime!.minute.toString()})'
                              : 'End Time Not Selected',
                          buttonText: 'Select New Time',
                          onPressed: () async {
                            TimeOfDay? tempTime = await showTimePicker(
                              context: context,
                              initialTime:
                                  endTime != null ? endTime! : TimeOfDay.now(),
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
                  archetype != "Youtube"
                      ? Padding(
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
                        )
                      : SizedBox(),
                  archetype == "Youtube"
                      ? Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 50, vertical: 20),
                          child: Column(
                            children: [
                              Text(
                                'Youtube Link:',
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
                                  controller:
                                      TextEditingController(text: youtube_link),
                                  onChanged: (value) {
                                    youtube_link = value;
                                  },
                                  //grow automatically

                                  decoration: new InputDecoration.collapsed(
                                    hintText: 'Link to Youtube Video',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : SizedBox(),
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
                      archetype == "Youtube"
                          ? SizedBox()
                          : Text(
                              'Members Only? ',
                              style: Constants.logoTitleStyle,
                            ),
                      archetype == "Youtube"
                          ? SizedBox()
                          : Checkbox(
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

                          if (isGood != false) {
                            print("all good statement");
                            await _alertDialogBuilder('Finished',
                                'Your event has been uploaded and should now appear on the app.');
                            Navigator.popAndPushNamed(context, '/manageevents');
                          }
                        },
                      ),
                      RoundedButton(
                        title: "Preview",
                        width: 50,
                        onPressed: () async {
                          // var data = await firestore
                          //     .collection('Events')
                          //     .doc(id)
                          //     .get();
                          if (validate() == false) {
                            return;
                          }
                          print("validate completed");
                          try {
                            EventItem item = new EventItem(
                              startTime: getTimeInt(startTime!),
                              youtube_link: youtube_link,
                              price: price,
                              date: getDateTimeInt(),
                              title: title,
                              type: type,
                              category: category,
                              isMembersOnly: isMembersOnly,
                              summary: summary,
                              imageRef: imageNameOnFirebase,
                              info: info,
                              speakers: itemListMaker.getAsListString(),
                              id: id!,
                              link: link,
                              endTime: getTimeInt(endTime!),
                              //blobImage: blobImage,
                              archetype: archetype,
                              image: image,
                            );
                            // if (archetype == "Youtube") {
                            //   return _alertDialogBuilder("Error",
                            //       "Preview function not available for Youtube events yet!");
                            // }
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        SingleEventScreen(item: item)));
                          } catch (e) {
                            print(e);
                          }
                        },
                      )
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
  final List? passedItemsNames;
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
      for (String str in passedItemsNames as List<String>) {
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

  List<String?> getAsListString() {
    List<String?> list = [];
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
  String? title;
  bool isDeleted = false;
  final ItemListMaker? listMaker;
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
                        if (listMaker!.items.length <= 1) {
                          title = '';
                        } else {
                          listMaker!.items.remove(this);
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
