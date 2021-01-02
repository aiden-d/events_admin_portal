import 'package:flutter/material.dart';
import 'package:amcham_admin_web/constants.dart';
import 'rounded_text_field.dart';
import 'package:flutter/services.dart';

class InputItem extends StatelessWidget {
  final String title;
  final String hint;
  final Function(String) onChanged;
  final bool isMultiLine;
  final int width;
  final double height;
  final bool isNumber;
  //test
  final int maxLength;
  final String textValue;

  InputItem({
    @required this.title,
    @required this.hint,
    @required this.onChanged,
    this.maxLength,
    this.isMultiLine,
    this.width,
    this.height,
    this.isNumber,
    this.textValue,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: Constants.logoTitleStyle,
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          width: width != null ? width : 300,
          height: height != null ? height : null,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(15)),
          child: TextField(
            controller: TextEditingController(text: textValue),
            maxLength: maxLength,
            keyboardType: isMultiLine == true
                ? TextInputType.multiline
                : TextInputType.name,
            maxLines: isMultiLine == true ? null : 1,
            inputFormatters: isNumber == true
                ? [
                    WhitelistingTextInputFormatter.digitsOnly,
                  ]
                : [],
            decoration: InputDecoration(
              counterText: '',
              border: InputBorder.none,
              hintText: hint,
              hintStyle: TextStyle(),
              contentPadding: EdgeInsets.symmetric(horizontal: 24),
            ),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
