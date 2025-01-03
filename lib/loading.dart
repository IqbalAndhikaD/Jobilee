// ignore_for_file: use_super_parameters, annotate_overrides, prefer_const_constructors, use_build_context_synchronously, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:jobilee/login.dart';
import 'package:jobilee/navbar.dart';
import 'package:jobilee/rsc/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:jobilee/authentication/authen_service.dart';

class Loading extends StatefulWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  bool isLogin = false;
  var userInfo = AuthenService().userInfo;

  checkIfLogin() async {
    AuthenService().authStateChanges.listen((User? user) async {
      if (user == null) {
        setState(() {
          isLogin = false;
        });
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Login(),
            ));
      } else {
        if (userInfo == null) {
          var result = await AuthenService().getUserInfo();
          if (result != null) {
            setState(() {
              userInfo = result;
            });
          }
        }
        setState(() {
          isLogin = true;
        });
      }

      await _navigatetohome();
    });
  }

  void initState() {
    super.initState();
    checkIfLogin();
  }

  _navigatetohome() async {
    await Future.delayed(Duration(milliseconds: 4000), () {});
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => isLogin ? NavBar(index: 0) : Login()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Image(
                      image: AssetImage('assets/images/jobilee.png'),
                      height: 59,
                      width: 260,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 0.0, bottom: 10.0),
                    ),
                    Row(
                      children: [
                        Text(
                          'Apply your future',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'GreycliffCF'),
                        ),
                        Text(
                          ' seamlessly.',
                          style: TextStyle(
                              color: lblue,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'GreycliffCF'),
                        )
                      ],
                    )
                  ])
                ],
      ))),
    );
  }
}
