import 'package:flutter/material.dart';
import 'package:amcham_admin_web/constants.dart';
import 'package:amcham_admin_web/size_config.dart';

class AmchamLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.safeBlockHorizontal * 80,
      child: Image.asset('lib/images/fulllogo.png'),
    );
  }
  // Material(
  // color: Colors.transparent,
  // child: FittedBox(
  // fit: BoxFit.fitHeight,
  // child: Column(
  // children: [
  // Image.asset(
  // 'lib/images/logo.png',
  // scale: 0.0000001,
  // width: SizeConfig().getBlockSizeVertical() * 20,
  // height: SizeConfig().getBlockSizeVertical() * 20,
  // ),
  // SizedBox(
  // height: (SizeConfig().getBlockSizeVertical() * 1.5),
  // ),
  // Center(
  // child: Text(
  // 'American Chamber of',
  // style: Constants.logoTitleStyle,
  // )),
  // Row(
  // mainAxisAlignment: MainAxisAlignment.center,
  // children: [
  // Text(
  // 'Commerce ',
  // style: Constants.logoTitleStyle,
  // ),
  // Text(
  // 'South Africa',
  // style: Constants.logoTitleStyleRed,
  // ),
  // ],
  // ),
  // ],
  // ),
  // ),
  // );
}
