import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:onekwacha/screens/home_screen.dart';

class LoginScreen extends StatelessWidget {
  final _phoneController = TextEditingController();
  final _passController = TextEditingController();
  final _codeController = TextEditingController();

  //Place A
  Future<bool> loginUser(String phone, BuildContext context) async {
    FirebaseAuth _auth = FirebaseAuth.instance;

    _auth.verifyPhoneNumber(
      phoneNumber: phone,
      timeout: Duration(seconds: 60),
      verificationCompleted: (AuthCredential credential) async {
        Navigator.of(context).pop();

        UserCredential result = await _auth.signInWithCredential(credential);

        User user = result.user;

        if (user != null) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => HomeScreen(
                        user: user,
                      )));
        } else {
          print("Error");
        }

        //This callback would gets called when verification is done automaticlly
      },
      verificationFailed: (FirebaseAuthException exception) {
        print('verification has failed');
      },
      codeSent: (String verificationId, int resendToken) {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return AlertDialog(
                title: Text("Give the code?"),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextField(
                      controller: _codeController,
                    ),
                  ],
                ),
                actions: <Widget>[
                  FlatButton(
                    child: Text("Confirm"),
                    textColor: Colors.white,
                    color: Colors.blue,
                    onPressed: () async {
                      final code = _codeController.text.trim();
                      AuthCredential credential = PhoneAuthProvider.credential(
                          verificationId: verificationId, smsCode: code);

                      UserCredential result =
                          await _auth.signInWithCredential(credential);

                      User user = result.user;

                      if (user != null) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomeScreen(
                                      user: user,
                                    )));
                      } else {
                        print("Error");
                      }
                    },
                  )
                ],
              );
            });
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      padding: EdgeInsets.all(32),
      child: Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Login",
              style: TextStyle(
                  color: Colors.lightBlue,
                  fontSize: 36,
                  fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: 16,
            ),
            TextFormField(
              decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      borderSide: BorderSide(color: Colors.grey[200])),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      borderSide: BorderSide(color: Colors.grey[300])),
                  filled: true,
                  fillColor: Colors.grey[100],
                  hintText: "Phone Number"),
              controller: _phoneController,
            ),
            SizedBox(
              height: 16,
            ),
            TextFormField(
              decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      borderSide: BorderSide(color: Colors.grey[200])),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      borderSide: BorderSide(color: Colors.grey[300])),
                  filled: true,
                  fillColor: Colors.grey[100],
                  hintText: "Password"),
              controller: _passController,
            ),
            SizedBox(
              height: 16,
            ),
            Container(
              width: double.infinity,
              child: FlatButton(
                child: Text("Login"),
                textColor: Colors.white,
                padding: EdgeInsets.all(16),
                onPressed: () {
                  //code for sign in
                  loginUser(_phoneController.text, context);
                },
                color: Colors.blue,
              ),
            )
          ],
        ),
      ),
    ));
  }
}
