import 'package:flutter/material.dart';

class RoundedTextField extends StatelessWidget {
  final Color colour;
  final String title;
  final double radius;
  final TextStyle textStyle;
  final double height;
  final double width;
  final String hintText;
  final Function(String) onChanged;
  final Function(String) onSubmitted;
  final FocusNode focusNode;
  final TextInputAction textInputAction;
  final bool isPasswordField;
  final String textValue;
  final double shadowOpacity;
  final BoxBorder border;
  final bool isMultiLine;
  RoundedTextField({
    this.title,
    this.colour,
    this.radius,
    this.textStyle,
    this.height,
    this.width,
    this.hintText,
    this.onChanged,
    this.onSubmitted,
    this.focusNode,
    this.textInputAction,
    this.isPasswordField,
    this.textValue,
    this.shadowOpacity,
    this.border,
    this.isMultiLine,
  });

  @override
  Widget build(BuildContext context) {
    bool _isPasswordField = isPasswordField ?? false;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.0),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        height: height != null ? height : 50,
        width: width != null ? width : 200,
        decoration: BoxDecoration(
            border: border != null ? border : null,
            boxShadow: [
              BoxShadow(
                color: Colors.grey
                    .withOpacity(shadowOpacity != null ? shadowOpacity : 0),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
            color: colour != null ? colour : Colors.white,
            borderRadius: BorderRadius.circular(radius != null ? radius : 15)),
        child: Center(
          child: TextField(
            keyboardType: isMultiLine == true
                ? TextInputType.multiline
                : TextInputType.name,
            maxLines: isMultiLine == true ? null : 1,
            controller: TextEditingController(text: textValue),
            obscureText: _isPasswordField,
            textInputAction: textInputAction,
            onChanged: onChanged,
            focusNode: focusNode,
            onSubmitted: onSubmitted,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hintText != null ? hintText : 'Enter a search term',
              hintStyle: TextStyle(),
              contentPadding: EdgeInsets.symmetric(horizontal: 24),
            ),
          ),
        ),
      ),
    );
  }
}
