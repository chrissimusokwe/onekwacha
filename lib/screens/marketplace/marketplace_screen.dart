import 'package:flutter/material.dart';
import 'package:onekwacha/widgets/bottom_nav.dart';

class MarketplaceScreen extends StatelessWidget {
  final int incomingData;
  MarketplaceScreen({
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
              'Marketplace',
              style: TextStyle(
                fontSize: 23.0,
              ),
            ),
          ],
        ),
      ),
      body: Center(child: Text("Marketplace")),
      bottomNavigationBar: BottomNavigation(
        incomingData: incomingData,
      ),
    );
  }
}
