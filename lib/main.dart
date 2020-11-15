import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onekwacha/utils/custom_colors.dart';
import 'package:onekwacha/screens/home_screen.dart';
import 'package:onekwacha/utils/route_generator.dart';

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
      // Initially display FirstPage
      initialRoute: '/',
      onGenerateRoute: RouteGenerator.generateRoute,
      //home: HomeScreen(title: 'OneKwacha'),
    );
  }
}
