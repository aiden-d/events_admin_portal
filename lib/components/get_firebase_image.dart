import 'package:amcham_app_v2/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:amcham_app_v2/components/rounded_button.dart';
import 'package:amcham_app_v2/components/bottom_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class LoadFirebaseStorageImage extends StatelessWidget {
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  final String imageRef;
  LoadFirebaseStorageImage({@required this.imageRef});
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _getImage(context, imageRef),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                image: new DecorationImage(
                  image: snapshot.data,
                  //TODO  IMAGE STREAMING
                  // image: Image.network(getImage(refStr)),
                  fit: BoxFit.fitHeight,
                ),
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              width: 100,
              height: 100,
              child: CircularProgressIndicator(),
            );
          }
          return Container(
            width: 100,
            height: 100,
            child: CircularProgressIndicator(),
          );
        });
  }

  Future<NetworkImage> _getImage(BuildContext context, String _imageRef) async {
    NetworkImage m;

    String url = await firebase_storage.FirebaseStorage.instance
        .ref(_imageRef)
        .getDownloadURL();

    m = NetworkImage(
      url.toString(),
    );

    return m;
  }
}
