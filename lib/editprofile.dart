import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:tubes/login.dart';
import 'package:tubes/profile.dart';
import 'package:tubes/rsc/log.dart';
import 'navbar.dart';

import 'package:tubes/authentication/authen_service.dart';
import 'package:tubes/rsc/colors.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class editProfile extends StatefulWidget {
  const editProfile({super.key});

  @override
  State<editProfile> createState() => _editProfileState();
}

class _editProfileState extends State<editProfile> {
  bool _isSecurePassword = false;

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

  Future<void> handleUpdate(
    BuildContext context
  ) async {
    AppLog.info(_username.text + ' ' + _password.text);
    try {
      if (_username.text != '') {
        await user!.updateDisplayName(_username.text);
        await FirebaseFirestore.instance.collection('users').doc(user!.uid).update({
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

  @override
  void initState() {
    super.initState();
    getUserInfo();
    _formKey.currentState?.validate(); // call validate here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData.fallback(),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.only(top: 0.0, right: 60.9, left: 60.0),
            child: Column(
              children: [
                // Judul = Profile
                Text(
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
                                      icon: Icon(Icons.edit),
                                      color: Colors.white,
                                      iconSize: 19,
                                      onPressed: () {},
                                    )),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Text(
                  'Fresh Graduate',
                  style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                      fontFamily: 'GreycliffCF',
                      fontWeight: FontWeight.bold),
                ),

                Text(
                  userInfo?['username'] ?? '',
                  style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'GreycliffCF',
                      fontWeight: FontWeight.bold),
                ),

                SizedBox(height: 9),

                // Username Title
                Row(mainAxisAlignment: MainAxisAlignment.start, children: [
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
                  decoration: InputDecoration(
                            hintText: 'Enter your username',
                            hintStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                                fontFamily: 'GreycliffCF'
                            )
                  ),
                ),
                SizedBox(
                  height: 20,
                ),

                // Password Title
                Row(mainAxisAlignment: MainAxisAlignment.start, children: [
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
                  decoration: InputDecoration(
                      hintText: 'Enter your password',
                      hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                          fontFamily: 'GreycliffCF')),
                ),
                SizedBox(
                  height: 16,
                ),

                //Button Edit Profile
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 0.0, vertical: 5),
                  child: Container(
                    width: 200,
                    child: TextButton(
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.all(9),
                          backgroundColor: lblue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: () => {
                          AppLog.info(_formKey.currentState?.validate()),
                          if (_formKey.currentState?.validate() ?? false) {
                            handleUpdate(context)
                          }
                        },
                        child: Row(
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
          ? Icon(Icons.visibility)
          : Icon(Icons.visibility_off),
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
                  padding: EdgeInsets.all(10),
                  fixedSize: Size(340, 0),
                  backgroundColor: lblue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NavBar(index: 4),
                      ));
                },
                child: Text(
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
