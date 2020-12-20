import 'package:flutter/material.dart';
import 'screens/test.dart';

void main() {
  runApp(AmchamAdminWeb());
}

//test
class AmchamAdminWeb extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Amcham Admin Page',
      home: test(),
    );
  }
}
