import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:tubes/login.dart';
import 'package:tubes/profile.dart';
import 'package:tubes/rsc/colors.dart';

import 'navbar.dart';

class editProfile extends StatefulWidget {
  const editProfile({super.key});

  @override
  State<editProfile> createState() => _editProfileState();
}

class _editProfileState extends State<editProfile> {
  bool _isSecurePassword = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData.fallback(),
      ),
      body: SafeArea(
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
                              name: 'Ashel Alifyaa',
                              radius: 55,
                              fontsize: 20,
                              img:
                                  'https://i.pinimg.com/736x/d8/ef/ce/d8efce4fface78988c6cba03bca0fb6a.jpg',
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
                  'Ashel Alifyaa',
                  style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'GreycliffCF',
                      fontWeight: FontWeight.bold),
                ),

                //Button Upload CV
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 0.0, vertical: 5),
                  child: Container(
                    width: 300,
                    child: TextButton(
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.all(9),
                          backgroundColor: lblue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: () {},
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Upload CV',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'GreycliffCF'),
                            ),
                            Icon(
                              Icons.cloud_upload,
                              color: Colors.white,
                            )
                          ],
                        )),
                  ),
                ),

                SizedBox(height: 9),
                // First Name Title
                Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                  Text(
                    'First Name',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'GreycliffCF'),
                  ),
                ]),
                SizedBox(
                  height: 9,
                ),

                // First-Name Field
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0.0),
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0, bottom: 5.0),
                      child: TextField(
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Enter your first name',
                            hintStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                                fontFamily: 'GreycliffCF')),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 13,
                ),

                // Last-Name
                Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                  Text(
                    'Last Name',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'GreycliffCF'),
                  ),
                ]),
                SizedBox(
                  height: 9,
                ),

                // Last-Name Field
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0.0),
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0, bottom: 5.0),
                      child: TextField(
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Enter your last name',
                            hintStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                                fontFamily: 'GreycliffCF')),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 13,
                ),

                // Email sub
                Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                  Text(
                    'Email',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'GreycliffCF'),
                  ),
                ]),
                SizedBox(
                  height: 9,
                ),

                // Email Field
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0.0),
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0, bottom: 5.0),
                      child: TextField(
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Enter your email',
                            hintStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                                fontFamily: 'GreycliffCF')),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 13,
                ),

                // Password Sub-Title
                Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                  Text(
                    'Password',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'GreycliffCF'),
                  ),
                ]),
                SizedBox(
                  height: 9,
                ),

                // Password Field
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0.0),
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0, bottom: 5.0),
                      child: TextField(
                        obscureText: _isSecurePassword,
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Enter your password',
                          hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                              fontFamily: 'GreycliffCF'),
                          suffixIcon: togglePassword(),
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(
                  height: 14,
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
                        onPressed: () => _applyNotifications(context),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Saved',
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
