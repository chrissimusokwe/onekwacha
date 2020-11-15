import 'package:flutter/material.dart';
import 'package:onekwacha/screens/history_screen.dart';
import 'package:onekwacha/screens/home_screen.dart';
import 'package:onekwacha/screens/profile_screen.dart';
import 'package:onekwacha/main.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed
    //final args = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => HomeScreen());

      case '/History':
        return MaterialPageRoute(
          builder: (_) => HistoryScreen(incomingData: 1),
        );

      case '/Profile':
        return MaterialPageRoute(
          builder: (_) => ProfileScreen(incomingData: 2),
        );
      default:
        // If there is no such named route in the switch statement, e.g. /third
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}
