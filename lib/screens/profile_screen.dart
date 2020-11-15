import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onekwacha/utils/custom_colors.dart';
import 'package:onekwacha/widgets/bottom_nav.dart';

class ProfileScreen extends StatelessWidget {
  final int incomingData;
  ProfileScreen({
    Key key,
    @required this.incomingData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        title: Center(
          child: Column(
            children: <Widget>[
              Text(
                'Profile',
                style: TextStyle(
                  fontSize: 23.0,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Center(child: Text("Profile")),
      bottomNavigationBar: BottomNavigation(
        incomingData: incomingData,
      ),
    );
  }
}
