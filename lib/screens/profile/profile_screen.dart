import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         backgroundColor: Colors.teal,
//         body: SafeArea(
//             child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             CircleAvatar(
//               radius: 50.0,
//               backgroundImage: AssetImage('images/angela.jpg'),
//             ),
//             Text(
//               'Angela Yu',
//               style: TextStyle(
//                 fontFamily: 'Pacifico',
//                 fontSize: 40.0,
//                 color: Colors.white,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             Text(
//               'FLUTTER DEVELOPER',
//               style: TextStyle(
//                 fontFamily: 'Source Sans Pro',
//                 color: Colors.teal.shade100,
//                 fontSize: 20.0,
//                 letterSpacing: 2.5,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             SizedBox(
//               height: 20.0,
//               width: 150.0,
//               child: Divider(
//                 color: Colors.teal.shade100,
//               ),
//             ),
//             Card(
//                 margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
//                 child: ListTile(
//                   leading: Icon(
//                     Icons.phone,
//                     color: Colors.teal,
//                   ),
//                   title: Text(
//                     '+44 123 456 789',
//                     style: TextStyle(
//                       color: Colors.teal.shade900,
//                       fontFamily: 'Source Sans Pro',
//                       fontSize: 20.0,
//                     ),
//                   ),
//                 )),
//             Card(
//                 margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
//                 child: ListTile(
//                   leading: Icon(
//                     Icons.email,
//                     color: Colors.teal,
//                   ),
//                   title: Text(
//                     'angela@email.com',
//                     style: TextStyle(
//                         fontSize: 20.0,
//                         color: Colors.teal.shade900,
//                         fontFamily: 'Source Sans Pro'),
//                   ),
//                 ))
//           ],
//         )),
//       ),
//     );
//   }
// }
