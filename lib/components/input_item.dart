import 'package:flutter/material.dart';
import 'package:amcham_admin_web/constants.dart';
import 'rounded_text_field.dart';

class InputItem extends StatelessWidget {
  final String title;
  final String hint;
  final Function(String) onChanged;
  final bool isMultiLine;
  InputItem({
    @required this.title,
    @required this.hint,
    @required this.onChanged,
    this.isMultiLine,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Text(
            title,
            style: Constants.logoTitleStyle,
          ),
          RoundedTextField(
            isMultiLine: isMultiLine,
            hintText: hint,
            width: 300,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
