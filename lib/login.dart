// ignore_for_file: use_super_parameters, prefer_const_literals_to_create_immutables, prefer_const_constructors, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tubes/authentication/authen_service.dart';
import 'package:tubes/navbar.dart';
import 'package:tubes/register.dart';
import 'package:tubes/rsc/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../exception/auth_exception.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void handleLogin() async {
    try {
      var user = await AuthenService().loginWithEmailAndPassword(
        email: _email.text,
        password: _password.text,
      );

      if (user == AuthResultStatus.successful) {
        Fluttertoast.showToast(msg: "Successful");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => NavBar(
                    index: 0,
                  )),
        );
      } else {
        final errorMsg = AuthException.generateExceptionMessage(user);
        Fluttertoast.showToast(msg: errorMsg);
      }
    } catch (e) {
      final errorMsg = AuthException.generateExceptionMessage(e);
      Fluttertoast.showToast(msg: errorMsg);
    }
  }

  @override
  void initState() {
    super.initState();
    _formKey.currentState?.validate(); // call validate here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Form(
        key: _formKey,
        child: Container(
          margin: const EdgeInsets.all(38),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Title
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'LOGIN',
                    style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.w900,
                        fontFamily: 'GreycliffCF'),
                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),

              // Sub-Title
              Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                Text(
                  'Login to continue to access',
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'GreycliffCF'),
                ),
                Text(
                  ' Jobilee',
                  style: TextStyle(
                      color: lblue,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'GreycliffCF'),
                )
              ]),
              SizedBox(
                height: 33,
              ),

              // Username Sub-Title
              Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                Text(
                  'Username',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'GreycliffCF'),
                ),
              ]),
              SizedBox(
                height: 9,
              ),

              TextFormField(
                controller: _email,
                validator: (text) {
                  if (text == null || text.trim().isEmpty) {
                    return 'Email is empty';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Email",
                ),
              ),

              SizedBox(
                height: 10,
              ),

              // Password Sub-Title
              Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                Text(
                  'Password',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'GreycliffCF'),
                ),
              ]),
              SizedBox(
                height: 9,
              ),

              TextFormField(
                obscureText: true,
                controller: _password,
                validator: (text) {
                  if (text == null || text.trim().isEmpty) {
                    return 'Password is empty';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Password",
                ),
              ),

              SizedBox(
                height: 33,
              ),

              // Button Login Jobilee
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0.0),
                child: Container(
                  width: 350,
                  child: ElevatedButton(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.all(9),
                      backgroundColor: lblue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        handleLogin();
                      }
                    },
                    child: Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 17,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'GreycliffCF',
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),

              // Just Text
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Don\'t have any account?',
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'GreycliffCF'),
                  ),
                ],
              ),
              SizedBox(height: 16),

              // Button Create Account or Register Jobilee
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0.0),
                child: Container(
                  width: 350,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.all(9),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(color: lblue)),
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Register(),
                          ));
                    },
                    child: Text(
                      'Create Account',
                      style: TextStyle(
                          fontSize: 17,
                          color: lblue,
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
