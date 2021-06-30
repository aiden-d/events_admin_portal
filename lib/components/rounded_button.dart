import 'package:amcham_admin_web/constants.dart';
import 'package:flutter/material.dart';
import 'package:amcham_admin_web/size_config.dart';

class RoundedButton extends StatelessWidget {
  RoundedButton(
      {required this.title,
      this.colour,
      required this.onPressed,
      this.radius,
      this.textStyle,
      this.height,
      this.width,
      this.isLoading,
      this.boxDecoration});

  final Color? colour;
  final String? title;
  final Function? onPressed;
  final double? radius;
  final TextStyle? textStyle;
  final double? height;
  final double? width;
  final bool? isLoading;
  final boxDecoration;
  @override
  Widget build(BuildContext context) {
    bool _isLoading = isLoading ?? false;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(radius != null ? radius! : 30),
        child: Container(
          decoration: boxDecoration != null
              ? boxDecoration
              : BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(radius != null ? radius! : 30),
                  color: colour,
                ),
          child: MaterialButton(
            onPressed: onPressed as void Function()?,
            minWidth: width != null
                ? width! * SizeConfig().getBlockSizeHorizontal()! * 0.209
                : 200.0 * 0.209 * SizeConfig().getBlockSizeHorizontal()!,
            height: height != null
                ? height! * SizeConfig().getBlockSizeVertical()! / 10
                : 42.0 / 10 * SizeConfig().getBlockSizeVertical()!,
            child: Container(
              width: width != null
                  ? width! * SizeConfig().getBlockSizeHorizontal()! * 0.209
                  : 200.0 * 0.209 * SizeConfig().getBlockSizeHorizontal()!,
              height: height != null
                  ? height! * SizeConfig().getBlockSizeVertical()! / 10
                  : 42.0 / 10 * SizeConfig().getBlockSizeVertical()!,
              child: Stack(
                fit: StackFit.loose,
                children: [
                  Visibility(
                    visible: _isLoading ? false : true,
                    child: Center(
                      child: Text(
                        title != null ? title! : 'Lorem',
                        style: textStyle != null
                            ? textStyle
                            : TextStyle(
                                color: Colors.black,
                              ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: _isLoading,
                    child: Center(
                      child: SizedBox(
                        child: CircularProgressIndicator(
                            //valueColor: Colors.red,
                            ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
