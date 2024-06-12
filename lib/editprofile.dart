// ignore_for_file: camel_case_types, use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jobilee/rsc/log.dart';
import 'navbar.dart';

import 'package:jobilee/authentication/authen_service.dart';
import 'package:jobilee/rsc/colors.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class editProfile extends StatefulWidget {
  final String currentProfilePic;
  final ValueSetter<String> onProfilePicUpdated;
  const editProfile({
    super.key,
    required this.currentProfilePic,
    required this.onProfilePicUpdated,
  });

  @override
  State<editProfile> createState() => _editProfileState();
}

class _editProfileState extends State<editProfile> {
  bool _isSecurePassword = false;
  File? _image;

  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final user = AuthenService().currentUser;
  dynamic userInfo;

  Future<dynamic> getUserInfo() async {
    var result = await AuthenService().getUserInfo();
    if (result != null) {
      setState(() {
        userInfo = result;
      });
    }
  }

  Future<void> handleUpdate(BuildContext context) async {
    AppLog.info('${_username.text} ${_password.text}');
    try {
      if (_username.text != '') {
        await user!.updateDisplayName(_username.text);
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .update({
          'username': _username.text,
        });
      }
      if (_password.text != '') {
        await user!.updatePassword(_password.text);
      }
      Fluttertoast.showToast(msg: "Profile Updated");
      _applyNotifications(context);
    } catch (e) {
      final errorMsg = e.toString();
      Fluttertoast.showToast(msg: errorMsg);
    }
  }

  Future<void> uploadProfilePicture() async {
    if (_image != null) {
      var imageName = DateTime.now().millisecondsSinceEpoch.toString();
      var storageRef = FirebaseStorage.instance
          .ref()
          .child('profile_pic/${user!.uid}/$imageName.jpg');
      var uploadTask = storageRef.putFile(_image!);
      var downloadUrl = await (await uploadTask).ref.getDownloadURL();

      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .update({
          'profile_pic': downloadUrl,
        });
        Fluttertoast.showToast(msg: "Profile picture updated");
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const NavBar(index: 4),
            ));
      } catch (e) {
        final errorMsg = e.toString();
        Fluttertoast.showToast(msg: errorMsg);
      }
    } else {
      Fluttertoast.showToast(msg: "No image selected");
    }
  }

  @override
  void initState() {
    super.initState();
    getUserInfo();
    _formKey.currentState?.validate(); // call validate here
  }

  final ImagePicker _picker = ImagePicker();

  Future<void> _getImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });

      uploadProfilePicture();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData.fallback(),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.only(top: 0.0, right: 60.9, left: 60.0),
            child: Column(
              children: [
                // Judul = Profile
                const Text(
                  'Profile',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'GreycliffCF'),
                ),
                // Ava/PP
                Container(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          SizedBox(
                            width: 120,
                            height: 120,
                            child: ProfilePicture(
                              name: userInfo?['username'] ?? '',
                              radius: 55,
                              fontsize: 20,
                              img: userInfo?['profile_pic'] ?? '',
                            ),
                          ),
                          // Icon change ava/pp
                          Positioned(
                            left: 80,
                            top: 85,
                            child: Row(
                              children: [
                                Container(
                                    width: 35,
                                    height: 35,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: lblue,
                                    ),
                                    child: IconButton(
                                      icon: const Icon(Icons.edit),
                                      color: Colors.white,
                                      iconSize: 19,
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            backgroundColor: Colors.white,
                                            content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                ListTile(
                                                  title: Text(
                                                    'Camera',
                                                    style: TextStyle(
                                                        color: lblue,
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontFamily:
                                                            'GreycliffCF'),
                                                  ),
                                                  onTap: () {
                                                    Navigator.pop(context);
                                                    _getImage(
                                                        ImageSource.camera);
                                                  },
                                                ),
                                                ListTile(
                                                  title: Text(
                                                    'Gallery',
                                                    style: TextStyle(
                                                        color: lblue,
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontFamily:
                                                            'GreycliffCF'),
                                                  ),
                                                  onTap: () {
                                                    Navigator.pop(context);
                                                    _getImage(
                                                        ImageSource.gallery);
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    )),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Text(
                  'Fresh Graduate',
                  style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                      fontFamily: 'GreycliffCF',
                      fontWeight: FontWeight.bold),
                ),

                Text(
                  userInfo?['username'] ?? '',
                  style: const TextStyle(
                      fontSize: 20,
                      fontFamily: 'GreycliffCF',
                      fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 9),

                // Username Title
                const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Username',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'GreycliffCF'),
                      ),
                    ]),
                // First-Name Field
                TextFormField(
                  controller: _username,
                  validator: (text) {
                    if (text == null || text.trim().isEmpty) {
                      return 'Username is empty';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                      hintText: 'Enter your username',
                      hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                          fontFamily: 'GreycliffCF')),
                ),
                const SizedBox(
                  height: 20,
                ),

                // Password Title
                const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Password',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'GreycliffCF'),
                      ),
                    ]),
                // First-Name Field
                TextFormField(
                  controller: _password,
                  obscureText: true,
                  decoration: const InputDecoration(
                      hintText: 'Enter your password',
                      hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                          fontFamily: 'GreycliffCF')),
                ),
                const SizedBox(
                  height: 16,
                ),

                //Button Edit Profile
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 0.0, vertical: 5),
                  child: SizedBox(
                    width: 200,
                    child: TextButton(
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.all(9),
                          backgroundColor: lblue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: () => {
                              AppLog.info(_formKey.currentState?.validate()),
                              if (_formKey.currentState?.validate() ?? false)
                                {handleUpdate(context)}
                            },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Save',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'GreycliffCF'),
                            ),
                          ],
                        )),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget togglePassword() {
    return IconButton(
      onPressed: () {
        setState(() {
          _isSecurePassword = !_isSecurePassword;
        });
      },
      icon: _isSecurePassword
          ? const Icon(Icons.visibility)
          : const Icon(Icons.visibility_off),
      color: lblue,
    );
  }

  Future<void> _applyNotifications(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          icon: Icon(
            Icons.task_alt_rounded,
            size: 150,
            color: lblue,
          ),
          title: const Text(
            'Edit Profile Successfully',
            style: TextStyle(
                color: Colors.black,
                fontFamily: 'GreycliffCF',
                fontWeight: FontWeight.w600),
          ),
          content: const Text(
            'You can now see your account in profile page.',
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            TextButton(
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.all(10),
                  fixedSize: const Size(340, 0),
                  backgroundColor: lblue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const NavBar(index: 4),
                      ));
                },
                child: const Text(
                  'See My Profile',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'GreycliffCF',
                      fontWeight: FontWeight.w600),
                )),
          ],
        );
      },
    );
  }
}
