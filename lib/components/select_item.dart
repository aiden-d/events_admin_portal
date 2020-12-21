import 'package:flutter/material.dart';
import 'rounded_button.dart';
import 'package:amcham_admin_web/constants.dart';

class SelectItem extends StatelessWidget {
  final Function onPressed;
  final String title;
  final String buttonText;
  final bool isNoError;
  final int width;

  SelectItem({
    @required this.onPressed,
    @required this.title,
    @required this.buttonText,
    @required this.isNoError,
    this.width,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          Text(
            title,
            style: isNoError != false
                ? Constants.logoTitleStyle
                : Constants.logoTitleStyleError,
          ),
          RoundedButton(
            width: width != null ? width : 50,
            title: buttonText,
            onPressed: onPressed,
          ),
        ],
      ),
    );
  }
}
