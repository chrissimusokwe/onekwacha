import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onekwacha/utils/custom_colors.dart';
import 'package:onekwacha/utils/custom_icons_icons.dart';
import 'package:onekwacha/utils/payment_card.dart';
import 'package:onekwacha/widgets/bottom_nav.dart';
import 'package:moneytextformfield/moneytextformfield.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:onekwacha/screens/profile/cards_screen.dart';
import 'package:page_transition/page_transition.dart';

class ConfirmationScreen extends StatelessWidget {
  final int incomingData;
  ConfirmationScreen({
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
                'Confirm',
                style: TextStyle(
                  fontSize: 23.0,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Center(child: Text("Confirmation")),
      bottomNavigationBar: BottomNavigation(
        incomingData: incomingData,
      ),
    );
  }
}
