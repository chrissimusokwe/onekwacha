import 'package:onekwacha/utils/custom_icons_icons.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onekwacha/utils/custom_colors.dart';

class BottomNavigation extends StatefulWidget {
  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 0: Home',
      style: optionStyle,
    ),
    Text(
      'Index 2: History',
      style: optionStyle,
    ),
    Text(
      'Index 1: Scan & Pay',
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(
            CustomIcons.home_page,
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            CustomIcons.time_machine,
          ),
          label: 'History',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            CustomIcons.male_user,
          ),
          label: 'Profile',
        ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: kDarkPrimaryColor,
      onTap: _onItemTapped,
    );
  }
}
