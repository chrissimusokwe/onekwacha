import 'package:onekwacha/utils/custom_icons.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onekwacha/utils/custom_colors_fonts.dart';

class BottomNavigation extends StatelessWidget {
  final int incomingData;
  BottomNavigation({
    Key key,
    this.incomingData,
  }) : super(key: key);

  final List<String> _selectedOption = ["/Home", "/History", "/Profile"];

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: incomingData,
      selectedItemColor: kDarkPrimaryColor,
      onTap: (value) {
        Navigator.of(context).pushNamedAndRemoveUntil(
            _selectedOption[value], (route) => false,
            arguments: incomingData);
      },
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(
            //Icons.home,
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
    );
  }
}
