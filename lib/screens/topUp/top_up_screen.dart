import 'package:flutter/material.dart';
import 'package:onekwacha/widgets/bottom_nav.dart';

class TopUpScreen extends StatefulWidget {
  final int incomingData;
  TopUpScreen({
    Key key,
    @required this.incomingData,
  }) : super(key: key);

  @override
  _TopUpScreenState createState() => _TopUpScreenState();
}

enum TopUpSource {
  MobileMoney,
  Card,
}

enum SendDestination {
  OneKwacha,
  MobileMoney,
}

enum TransactionPurpose {
  Business,
  Entertainment,
  Education,
  Family,
  Friend,
  Groceries,
  Travel,
}

class TopUp {
  TopUpSource source;
  int number;
  int amount;
  TransactionPurpose purpose;

  TopUp({
    this.source,
    this.number,
    this.amount,
    this.purpose,
  });
  Map<String, dynamic> toJson() => {
        'source': source,
        'number': number,
        'amount': amount,
        'purpose': purpose
      };
}

class _TopUpScreenState extends State<TopUpScreen> {
  final List<bool> _selectionFrom = List.generate(2, (_) => false);
  final GlobalKey _formKey = GlobalKey();
  final _formResult = TopUp();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        title: Column(
          children: <Widget>[
            Text(
              'Top up',
              style: TextStyle(
                fontSize: 23.0,
              ),
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                Text(
                  'From',
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                ),
              ],
            ),
            ToggleButtons(
              children: <Widget>[
                Text(
                  'Mobile Money',
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                ),
                Text(
                  'Card',
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                ),
              ],
              onPressed: (int index) {
                setState(() {
                  for (int buttonIndex = 0;
                      buttonIndex < _selectionFrom.length;
                      buttonIndex++) {
                    if (buttonIndex == index) {
                      _selectionFrom[buttonIndex] =
                          !_selectionFrom[buttonIndex];
                    } else {
                      _selectionFrom[buttonIndex] = false;
                    }
                  }
                });
              },
              isSelected: _selectionFrom,
            ),
            Text(
              'Amount: ',
              style: TextStyle(
                fontSize: 18.0,
              ),
            ),
            Text(
              'Purpose: ',
              style: TextStyle(
                fontSize: 18.0,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigation(
        incomingData: widget.incomingData,
      ),
    );
  }
}
