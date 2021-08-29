import 'package:amcham_admin_web/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:amcham_admin_web/constants.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:webviewx/webviewx.dart';
import 'get_firebase_image.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:web_browser/web_browser.dart';

class EventItem extends StatefulWidget {
  final int? price;
  //date must be formated as year/month/day
  final int? date;
  //time formatted as hhmm or hour hour minute minute
  final int? startTime;
  final int? endTime;
  final String? title;
  final String? type;
  final String? category;
  final bool? isMembersOnly;
  final String? summary;
  final String? imageRef;
  final String? info;
  final String id;
  final String? link;
  final String? youtube_link;
  final List? speakers;
  final String? archetype;
  final Image? image;

  EventItem({
    required this.price,
    required this.date,
    required this.title,
    required this.type,
    required this.category,
    required this.isMembersOnly,
    required this.summary,
    required this.imageRef,
    required this.info,
    required this.id,
    required this.link,
    required this.startTime,
    required this.endTime,
    required this.speakers,
    required this.youtube_link,
    required this.archetype,
    required this.image,
  });
  int? rankedPoints;
  bool showVid = true;
  bool? isButton;

  bool? showInfo;

  bool? hideSummary;

  bool isInfoSelected = true;
  int getDateTimeInt() {
    int val = int.parse(date.toString());
    print('int date time = ' + val.toString());
    return val;
  }

  int getCurrentDateTimeInt() {
    DateTime now = DateTime.now();
    int val = int.parse(now.year.toString() +
        (now.month > 9 ? now.month.toString() : '0' + now.month.toString()) +
        (now.day > 9 ? now.day.toString() : '0' + now.day.toString()) +
        (now.hour > 9 ? now.hour.toString() : '0' + now.hour.toString()) +
        (now.minute > 9 ? now.minute.toString() : '0' + now.minute.toString()));
    print('current int date time = $val');
    return val;
  }

  Function? infoButtonFunction;

  Function? speakersButtonFunction;

  String DateToString(int? numberDate) {
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

  String TimeToString(int? numberTime) {
    String numberStr = numberTime.toString();
    if (numberStr.length < 4) {
      numberStr = '0' + numberStr;
    }
    String hour = numberStr.substring(0, 2);
    String minute = numberStr.substring(2, 4);
    return '$hour:$minute';
  }

  @override
  _EventItemState createState() => _EventItemState();
}

class _EventItemState extends State<EventItem> {
  late WebViewXController webviewController;
  String yID = "QRWijH8KNFU";

  @override
  void initState() {
    print(widget.archetype);
    if (widget.archetype == "Youtube" && widget.showVid == true) {
      yID = YoutubePlayer.convertUrlToId(widget.youtube_link!)!;
    } else
      print("no vid");

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: () {},
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
                      width: 7,
                    ),
                    Text(
                      '${widget.DateToString(this.widget.date)} ${widget.TimeToString(this.widget.startTime)}',
                      style: TextStyle(fontSize: 14),
                    )
                  ],
                ),
                Text(
                  (widget.price == 0 || widget.price == null
                      ? 'FREE'
                      : 'R${widget.price}'),
                  style: TextStyle(color: Colors.red[900], fontSize: 12),
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
                      widget.title!,
                      style: Constants.regularHeading.copyWith(
                          fontSize: widget.title!.length > 25 ? 16 : 19),
                    ),
                  ),
                  Text(
                    widget.archetype != "External Event"
                        ? widget.archetype == "Youtube"
                            ? widget.getDateTimeInt() <
                                    widget.getCurrentDateTimeInt()
                                ? "Recording"
                                : "Livestream"
                            : widget.archetype!
                        : widget.type!,
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
                    widget.category!,
                    style: TextStyle(
                        color: Constants.blueThemeColor, fontSize: 16),
                  ),
                  Text(
                    widget.isMembersOnly == true ? 'Members Only' : 'Public',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),

            //TODO put container here
            widget.archetype == "Youtube" && widget.showVid == true
                ? Container(
                    width: 450,
                    height: 450 * 9 / 16,
                    child: WebBrowser(
                      initialUrl: "https://www.youtube.com/embed/" + yID,
                      javascriptEnabled: true,
                      interactionSettings: WebBrowserInteractionSettings(
                          bottomBar: SizedBox(), topBar: SizedBox()),
                    ))
                // WebViewX(
                //     initialContent: '<h2> Loading... </h2>',
                //     initialSourceType: SourceType.url,
                //     width: 450,
                //     height: 450 * 9 / 16,
                //     onWebViewCreated: (controller) {
                //       webviewController = controller;
                //       webviewController.loadContent(
                //         "https://www.youtube.com/embed/" + yID,
                //         SourceType.url,
                //       );
                //     },
                //   )

                // onWebViewCreated: (controller) {
                //   webViewController = controller;
                // },
                // YoutubePlayerBuilder(
                //     player: YoutubePlayer(
                //       controller: widget._controller,
                //       showVideoProgressIndicator: true,
                //     ),
                //     builder: (context, player) {
                //       return Column(
                //         children: [
                //           // some widgets
                //           player,
                //           //some other widgets
                //         ],
                //       );
                //     })
                :
                //     :

                //     ? YoutubePlayerIFrame(
                //         controller: _controller,
                //         // YoutubePlayerController(
                //         //   initialVideoId:
                //         //       youtube_link.substring(32, youtube_link.length),
                //         //   params: YoutubePlayerParams(
                //         //     autoPlay: false,
                //         //     showControls: true,
                //         //     showFullscreenButton: true,
                //         //   ),
                //         // ),
                //         aspectRatio: 16 / 9,
                //       )
                //     :
                Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: widget.image != null
                        ? widget.image
                        : LoadFirebaseStorageImage(imageRef: widget.imageRef)),
            widget.hideSummary == true ? SizedBox() : Text(widget.summary!),

            //showInfo == true ? Text(info) : SizedBox(),
          ],
        ),
      ),
    );
  }
}
