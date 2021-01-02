import 'package:flutter/material.dart';
import 'package:onekwacha/screens/history/history_screen.dart';
import 'package:onekwacha/screens/home_screen.dart';
import 'package:onekwacha/screens/common/cards_details_screen.dart';
import 'package:onekwacha/screens/profile/profile_screen.dart';
import 'package:page_transition/page_transition.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed
    //final args = settings.arguments;

    switch (settings.name) {
      case '/':
        return PageTransition(
            child: HomeScreen(), type: PageTransitionType.fade);
        break;

      case '/History':
        return PageTransition(
            child: HistoryScreen(incomingData: 1),
            type: PageTransitionType.fade);
        break;

      case '/Profile':
        return PageTransition(
            child: ProfileScreen(incomingData: 2),
            type: PageTransitionType.fade);
        break;
      // case '/CardScreen':
      //   return PageTransition(
      //       child: CardScreen(incomingData: 2), type: PageTransitionType.fade);
      //   break;
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
