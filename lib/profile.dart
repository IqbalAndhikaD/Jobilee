import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:tubes/login.dart';
import 'package:tubes/rsc/colors.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 100),
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
                            name: 'Ashel',
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
                'Ashel',
                style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'GreycliffCF',
                    fontWeight: FontWeight.bold),
              ),

              // Button logout
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 0.0, vertical: 240),
                child: Container(
                  width: 350,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.all(9),
                      backgroundColor: lblue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Login(),
                          ));
                    },
                    child: Text(
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
}
