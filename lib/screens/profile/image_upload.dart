import 'dart:async';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:onekwacha/models/userModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:onekwacha/utils/custom_colors_fonts.dart';
import 'package:onekwacha/utils/global_strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:page_transition/page_transition.dart';
import 'package:onekwacha/screens/profile/profile_screen.dart';
import 'package:onekwacha/screens/home_screen.dart';

class ImageUpload extends StatefulWidget {
  final String userID,
      lastUpdateDate,
      phoneNumber,
      address,
      email,
      firstName,
      selectedGender,
      selectedDoB,
      middleName,
      lastName,
      nrcPassport;
  ImageUpload({
    @required this.userID,
    @required this.firstName,
    @required this.lastName,
    @required this.middleName,
    @required this.address,
    @required this.email,
    @required this.lastUpdateDate,
    @required this.nrcPassport,
    @required this.phoneNumber,
    @required this.selectedDoB,
    @required this.selectedGender,
    Key key,
  }) : super(key: key);

  @override
  _ImageUploadState createState() => _ImageUploadState();
}

class _ImageUploadState extends State<ImageUpload> {
  UserModel userModel = new UserModel();
  bool gallery = false;
  String userID,
      _loyaltyPoints,
      _cardNumber,
      _previousUpdateDate,
      _updateReason,
      _kycStatus;
  String returnURL;
  File _frontImage; // Used only if you need a single picture
  File _backImage;
  bool _uploaded = false;
  bool _updatedFront = false;
  bool _updatedBack = false;
  bool _userUpdated = false;
  bool _showUploadButton = true;
  //bool _enableFields;

  final Color yellow = Color(0xfffbc31b);
  final Color amber = Colors.amber;

  //Start the camera to capture the front or page 1 of the ID document
  Future getFrontImage() async {
    ImagePicker picker = ImagePicker();
    PickedFile pickedFile;
    userID = widget.userID;

    // Let user select photo from gallery
    if (gallery) {
      pickedFile = await picker.getImage(
        source: ImageSource.gallery,
      );
    }
    // Otherwise open camera to get new photo
    else {
      pickedFile = await picker.getImage(
        source: ImageSource.camera,
      );
    }

    setState(() {
      if (pickedFile != null) {
        //_images.add(File(pickedFile.path));
        _frontImage = File(pickedFile.path);
        print('Image is picked ' +
            _frontImage.path); // Use if you only need a single picture
      } else {
        print('No image selected.');
      }
    });
  }

  //Start the camera to capture the back or page 2 of the ID document
  Future getBackImage() async {
    ImagePicker picker = ImagePicker();
    PickedFile pickedFile;
    userID = widget.userID;

    // Let user select photo from gallery
    if (gallery) {
      pickedFile = await picker.getImage(
        source: ImageSource.gallery,
      );
    }
    // Otherwise open camera to get new photo
    else {
      pickedFile = await picker.getImage(
        source: ImageSource.camera,
      );
    }

    setState(() {
      if (pickedFile != null) {
        //_images.add(File(pickedFile.path));
        _backImage = File(pickedFile.path);
        print('Image is picked ' +
            _backImage.path); // Use if you only need a single picture
      } else {
        print('No image selected.');
      }
    });
  }

  //Save the image before uploading it to the user's storage folder
  Future saveImage(BuildContext context) async {
    // DocumentReference imageRef =
    //     FirebaseFirestore.instance.collection(userID).doc();

    // TODO: Will need to switch to authenticated user at some point.
    UserCredential userCredential =
        await FirebaseAuth.instance.signInAnonymously();

    if (userCredential != null) {
      String frontImageURL = await uploadFile(_frontImage, true);
      String backImageURL = await uploadFile(_frontImage, false);
      _updatedFront =
          await userModel.updateUserImageUrl(userID, frontImageURL, true);
      _updatedBack =
          await userModel.updateUserImageUrl(userID, backImageURL, false);

      if (_updatedFront && _updatedBack) {
        setState(() {
          _uploaded = true;
        });
      }
    }
  }

  //Upload images to the user's storage folders
  Future<String> uploadFile(File _image, bool isFront) async {
    Reference frontStorageReference = FirebaseStorage.instance
        .ref()
        .child(userID + '/FrontPageIDDocument.jpg');

    Reference backStorageReference = FirebaseStorage.instance
        .ref()
        .child(userID + '/BackPageIDDocument.jpg');

    //Check if image is a front or page 1 image
    if (isFront) {
      await frontStorageReference.putFile(_image);

      await frontStorageReference.getDownloadURL().then((fileURL) {
        setState(() {
          returnURL = fileURL.toString();
        });
      });
    } //else image is a back or page 2
    else {
      await backStorageReference.putFile(_image);

      await backStorageReference.getDownloadURL().then((fileURL) {
        setState(() {
          returnURL = fileURL.toString();
        });
      });
    }

    return returnURL;
  }

  @override
  void initState() {
    super.initState();
    _uploaded = false;
  }

  //Update user's image URLs in the User profile
  void updateUser() async {
    Navigator.pop(context);
    _updateReason = 'User submitted for KYC Review';
    _kycStatus = 'Pending Review';
    _previousUpdateDate = widget.lastUpdateDate;
    _cardNumber = '';
    _loyaltyPoints = '';
    //_enableFields = true;
    _userUpdated = false;
    _userUpdated = await userModel.updateUser(
      userID,
      widget.address,
      _cardNumber,
      widget.email,
      widget.firstName,
      widget.selectedGender,
      widget.selectedDoB,
      widget.middleName,
      _kycStatus,
      widget.lastName,
      _loyaltyPoints,
      widget.nrcPassport,
      widget.phoneNumber,
      _previousUpdateDate,
      _updateReason,
    );
    if (_userUpdated) {
      Navigator.pushAndRemoveUntil(
          context,
          PageTransition(
            child: ProfileScreen(),
            type: PageTransitionType.fade,
          ),
          (route) => false);
    } else {
      submissionFailed();
    }
  }

  //Dialog when submission fails due to something going wrong
  void submissionFailed() {
    showPlatformDialog(
      context: context,
      builder: (_) => BasicDialogAlert(
          title: Center(
              child: Column(
            children: [
              Icon(
                Icons.error_outline_rounded,
                color: kDarkPrimaryColor,
                size: 50,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Submission failed',
                style: TextStyle(color: Colors.red, fontSize: 25),
              ),
            ],
          )),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Center(
                  child: Text(
                    'Submission failed. Check network connectivity or try again later.',
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontSize: MyGlobalVariables.dialogFontSize),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            BasicDialogAction(
              title: Text(
                "DISMISS",
                style: TextStyle(color: kDarkPrimaryColor),
              ),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    PageTransition(
                      child: HomeScreen(),
                      type: PageTransitionType.fade,
                    ),
                    (route) => false);
              },
            ),
          ]),
    );
  }

  //Profile submission confirmation
  void confirmSubmittion() async {
    return showPlatformDialog(
      context: context,
      builder: (_) => BasicDialogAlert(
          title: Center(
              child: Column(
            children: [
              Icon(
                Icons.info_outlined,
                color: kDarkPrimaryColor,
                size: 50,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Confirm Submission',
                style: TextStyle(color: kDarkPrimaryColor, fontSize: 25),
              ),
            ],
          )),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Center(
                  child: Text(
                    'You are about to submit your Profile details for KYC Review',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Center(
                  child: Text(
                    'IMPORTANT NOTE',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: MyGlobalVariables.dialogFontSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: 3,
                ),
                Text(
                  'Unless we ask you to resubmit, you will not be able to edit your details while your Profile undergoes KYC review.',
                  textAlign: TextAlign.justify,
                  style: TextStyle(fontSize: MyGlobalVariables.dialogFontSize),
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  "Once you submit, your Profile KYC Status will progress to 'Pending Review' status. If everything checks out, we will activate it and you will be good to go.",
                  textAlign: TextAlign.justify,
                  style: TextStyle(fontSize: MyGlobalVariables.dialogFontSize),
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  "Check back later to confirm the status of your profile.",
                  textAlign: TextAlign.justify,
                  style: TextStyle(fontSize: MyGlobalVariables.dialogFontSize),
                ),
                SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            BasicDialogAction(
              title: Text(
                "SUBMIT",
                style: TextStyle(color: kDarkPrimaryColor, fontSize: 15),
              ),
              onPressed: updateUser,
            ),
            BasicDialogAction(
              title: Text(
                "CANCEL",
                style: TextStyle(color: kDarkPrimaryColor, fontSize: 15),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    //_showUploadButton = false;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Expanded(
              child: Text(
                'My Profile',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 23.0,
                ),
              ),
            ),
          ],
        ),
      ),
      body: Stack(
        children: <Widget>[
          Container(
            height: 360,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(50.0),
                    bottomRight: Radius.circular(50.0)),
                gradient: LinearGradient(
                    colors: [amber, yellow],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight)),
          ),
          Container(
            margin: const EdgeInsets.only(top: 30),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: (_uploaded)
                        ? Text(
                            "Upload complete!",
                            style: TextStyle(
                              color: kTextPrimaryColor,
                              fontSize: 22,
                            ),
                          )
                        : Text(
                            "Scan & Upload ID Documents",
                            style: TextStyle(
                              color: kTextPrimaryColor,
                              fontSize: 22,
                            ),
                          ),
                  ),
                ),
                SizedBox(height: 20.0),
                Expanded(
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          //height: double.infinity,
                          margin: const EdgeInsets.only(
                              left: 30.0, right: 30.0, top: 10.0),
                          child: ClipRRect(
                            //borderRadius: BorderRadius.circular(30.0),
                            child: _frontImage != null
                                ? (_uploaded)
                                    ? Image.file(_frontImage)
                                    : Row(
                                        children: [
                                          Image.file(_frontImage),
                                          FlatButton(
                                            onPressed: () {
                                              getFrontImage();
                                            },
                                            child: Row(
                                              children: [
                                                Icon(Icons.add_a_photo),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  "Rescan Front",
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    color: kTextPrimaryColor,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      FlatButton(
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.add_a_photo,
                                              size: 50,
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              'Front/Page 1',
                                              style: TextStyle(fontSize: 20),
                                            ),
                                          ],
                                        ),
                                        onPressed: getFrontImage,
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Expanded(
                        child: Container(
                          //height: double.infinity,
                          margin: const EdgeInsets.only(
                              left: 30.0, right: 30.0, top: 10.0),
                          child: ClipRRect(
                            //borderRadius: BorderRadius.circular(30.0),
                            child: _backImage != null
                                ? (_uploaded)
                                    ? Image.file(_backImage)
                                    : Row(
                                        children: [
                                          Image.file(_backImage),
                                          FlatButton(
                                            onPressed: () {
                                              getBackImage();
                                            },
                                            child: Row(
                                              children: [
                                                Icon(Icons.add_a_photo),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  "Rescan Back",
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    color: kTextPrimaryColor,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      FlatButton(
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.add_a_photo,
                                              size: 50,
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              'Back/Page 2',
                                              style: TextStyle(fontSize: 20),
                                            ),
                                          ],
                                        ),
                                        onPressed: getBackImage,
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                (_frontImage != null)
                    ? uploadImageButton(context)
                    : Container(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget uploadImageButton(BuildContext context) {
    return Container(
      child: Stack(
        children: <Widget>[
          (_showUploadButton)
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5.0, horizontal: 10.0),
                      margin: const EdgeInsets.only(
                          top: 30, left: 10.0, right: 10.0, bottom: 60.0),
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [yellow, amber],
                          ),
                          borderRadius: BorderRadius.circular(30.0)),
                      child: FlatButton(
                        onPressed: () {
                          setState(() {
                            _showUploadButton = false;
                          });
                          saveImage(context);
                        },
                        child: Row(
                          children: [
                            Icon(Icons.upload_outlined),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              "Upload",
                              style: TextStyle(
                                fontSize: 20,
                                color: kTextPrimaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              : Container(
                  child: (!_uploaded)
                      ? Container(
                          padding: const EdgeInsets.symmetric(vertical: 25.0),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Shouldn't be long...",
                                  style: TextStyle(
                                    fontSize: 17,
                                    color: kTextPrimaryColor,
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                CircularProgressIndicator(),
                              ],
                            ),
                          ),
                        )
                      : Column(
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5.0, horizontal: 16.0),
                              margin: const EdgeInsets.only(
                                  top: 20,
                                  left: 20.0,
                                  right: 20.0,
                                  bottom: 60.0),
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [yellow, amber],
                                  ),
                                  borderRadius: BorderRadius.circular(30.0)),
                              child: FlatButton(
                                onPressed: () {
                                  confirmSubmittion();
                                },
                                child: Text(
                                  "Submit Profile",
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: kTextPrimaryColor,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                ),
        ],
      ),
    );
  }
}
