import 'package:flutter/material.dart';

class FeedbackBuilder {
  static Future<void> alertDialogBuilder(
    String title,
    String info,
    BuildContext context, [
    String? closeButtonTitle,
    bool? isProceedButton,
    Function? proceedFunction,
  ]) async {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(title != null ? title : "Error"),
            content: Container(
              child: Text(info),
            ),
            actions: [
              FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                      closeButtonTitle != null ? closeButtonTitle : "Close")),
              isProceedButton!
                  ? FlatButton(
                      onPressed: () {
                        proceedFunction!();
                      },
                      child: Text(closeButtonTitle != null
                          ? closeButtonTitle
                          : "Proceed"))
                  : SizedBox(),
            ],
          );
        });
  }
}
