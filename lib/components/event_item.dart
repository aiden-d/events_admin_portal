import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:amcham_admin_web/constants.dart';
import 'package:image_whisperer/image_whisperer.dart';
import 'get_firebase_image.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class EventItem extends StatelessWidget {
  final int price;
  //date must be formated as year/month/day
  final int date;
  //time formatted as hhmm or hour hour minute minute
  final int startTime;
  final int endTime;
  final String title;
  final String type;
  final String category;
  final bool isMembersOnly;
  final String summary;
  final String imageRef;
  final String info;
  final String id;
  final String link;
  final String youtube_link;
  final List speakers;
  final BlobImage blobImage;
  final String archetype;
  bool isButton;
  bool showInfo;
  bool hideSummary;
  bool isInfoSelected = true;
  Function infoButtonFunction;
  Function speakersButtonFunction;

  EventItem({
    @required this.archetype,
    @required this.price,
    @required this.date,
    @required this.title,
    @required this.type,
    @required this.category,
    @required this.isMembersOnly,
    @required this.summary,
    @required this.imageRef,
    @required this.info,
    @required this.id,
    @required this.link,
    @required this.startTime,
    @required this.endTime,
    @required this.speakers,
    @required this.youtube_link,
    @required this.blobImage,
  });
  int rankedPoints;
  YoutubePlayerController _controller;

  //date must be formated as year/month/day
  String DateToString(int numberDate) {
    String strNumberDate = numberDate.toString();
    String year = strNumberDate.substring(0, 4);
    String month = strNumberDate.substring(4, 6);
    int monthInt = int.parse(month);
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
    month = dates[monthInt - 1];

    String day = strNumberDate.substring(6, 8);
    return '$day $month $year';
  }

  String TimeToString(int numberTime) {
    String numberStr = numberTime.toString();
    if (numberStr.length < 4) {
      numberStr = '0' + numberStr;
    }
    String hour = numberStr.substring(0, 2);
    String minute = numberStr.substring(2, 4);
    return '$hour:$minute';
  }

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: isButton == false ? null : () {},
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        color: Colors.white,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(CupertinoIcons.calendar),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      '${DateToString(this.date)} ${TimeToString(this.startTime)}',
                      style: TextStyle(fontSize: 16),
                    )
                  ],
                ),
                Text(
                  (price == 0 || price == null ? 'FREE' : 'R$price'),
                  style: TextStyle(color: Colors.red[900], fontSize: 14),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      title,
                      style: Constants.regularHeading
                          .copyWith(fontSize: title.length > 25 ? 16 : 19),
                    ),
                  ),
                  Text(
                    type,
                    style: TextStyle(
                        color: Constants.blueThemeColor, fontSize: 16),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    category,
                    style: TextStyle(
                        color: Constants.blueThemeColor, fontSize: 16),
                  ),
                  Text(
                    isMembersOnly == true ? 'Members Only' : 'Public',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
            archetype == "Youtube"
                ? YoutubePlayerIFrame(
                    controller: YoutubePlayerController(
                      initialVideoId:
                          youtube_link.substring(32, youtube_link.length),
                      params: YoutubePlayerParams(
                        showControls: true,
                        showFullscreenButton: true,
                      ),
                    ),
                    aspectRatio: 16 / 9,
                  )
                : Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: blobImage != null
                        ? Image(image: NetworkImage(blobImage.url))
                        : LoadFirebaseStorageImage(imageRef: imageRef)),
            hideSummary == true ? SizedBox() : Text(summary),

            //showInfo == true ? Text(info) : SizedBox(),
          ],
        ),
      ),
    );
  }
}
