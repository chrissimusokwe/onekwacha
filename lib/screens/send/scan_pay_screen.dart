import 'package:flutter/material.dart';
import 'package:onekwacha/widgets/bottom_nav.dart';

class ScanPayScreen extends StatelessWidget {
  final int incomingData;
  ScanPayScreen({
    Key key,
    @required this.incomingData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        title: Column(
          children: <Widget>[
            Text(
              'Scan & Pay',
              style: TextStyle(
                fontSize: 23.0,
              ),
            ),
          ],
        ),
      ),
      body: Center(child: Text("Scan & Pay")),
      bottomNavigationBar: BottomNavigation(
        incomingData: incomingData,
      ),
    );
  }
}
