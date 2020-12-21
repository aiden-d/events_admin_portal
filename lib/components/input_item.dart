import 'package:flutter/material.dart';
import 'package:amcham_admin_web/constants.dart';
import 'rounded_text_field.dart';

class InputItem extends StatelessWidget {
  final String title;
  final String hint;
  final Function(String) onChanged;
  final bool isMultiLine;
  final int width;
  final double height;
  final bool isNumber;
  final int maxLength;

  InputItem({
    @required this.title,
    @required this.hint,
    @required this.onChanged,
    this.maxLength,
    this.isMultiLine,
    this.width,
    this.height,
    this.isNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: Constants.logoTitleStyle,
        ),
        RoundedTextField(
          maxLength: maxLength,
          isNumber: isNumber,
          isMultiLine: isMultiLine,
          hintText: hint,
          width: width != null ? width : 300,
          height: height != null ? height : null,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
