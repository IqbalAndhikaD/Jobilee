// ignore_for_file: unnecessary_import, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:jobilee/editprofile.dart';
import 'package:jobilee/login.dart';

import 'package:jobilee/authentication/authen_service.dart';
import 'package:jobilee/rsc/colors.dart';

import 'package:fluttertoast/fluttertoast.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool _isSecurePassword = false;
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

  void _signOut() async {
    try {
      await AuthenService().signOut();
      Fluttertoast.showToast(msg: "Logged Out");
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const Login(),
          ));
    } catch (e) {
      final errorMsg = e.toString();
      Fluttertoast.showToast(msg: errorMsg);
    }
  }

  @override
  void initState() {
    super.initState();
    getUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.only(top: 40.0, right: 40.9, left: 40.0),
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
                            radius: 36,
                            fontsize: 20,
                            img: userInfo?['profile_pic'] ?? '',
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
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => editProfile(
                                currentProfilePic: '',
                                onProfilePicUpdated: (String value) {},
                              ),
                            ));
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Edit Profile',
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'GreycliffCF'),
                          ),
                          Icon(
                            Icons.edit_square,
                            color: Colors.white,
                          )
                        ],
                      )),
                ),
              ),

              // Button logout
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 0.0, vertical: 14),
                child: SizedBox(
                  width: 350,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.all(9),
                      backgroundColor: lblue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    onPressed: () {
                      _signOut();
                    },
                    child: const Text(
                      'Logout',
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'GreycliffCF'),
                    ),
                  ),
                ),
              ),
            ],
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
}
