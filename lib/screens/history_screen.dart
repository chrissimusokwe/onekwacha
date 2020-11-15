import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onekwacha/utils/custom_colors.dart';
import 'package:onekwacha/widgets/bottom_nav.dart';

class HistoryScreen extends StatelessWidget {
  final int incomingData;
  HistoryScreen({
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
                'History',
                style: TextStyle(
                  fontSize: 23.0,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Center(child: Text("History")),
      bottomNavigationBar: BottomNavigation(
        incomingData: incomingData,
      ),
    );
  }
}
