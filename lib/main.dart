import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onekwacha/utils/custom_colors.dart';
import 'package:onekwacha/screens/home_screen.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OneKwacha',
      theme: ThemeData(
        primaryColor: kDefaultPrimaryColor,
      ),
      home: HomePage(title: 'OneKwacha'),
    );
  }
}


