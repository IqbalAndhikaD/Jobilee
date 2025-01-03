// ignore_for_file: use_super_parameters, prefer_const_literals_to_create_immutables, prefer_const_constructors, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jobilee/authentication/authen_service.dart';
import 'package:jobilee/login.dart';
import 'package:jobilee/navbar.dart';
import 'package:jobilee/rsc/colors.dart';
import '../exception/auth_exception.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _LoginState();
}

class _LoginState extends State<Register> {
  final TextEditingController _username = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void handleSignUp() {
    //loadingDialog.showLoadingDiaglog(context, "Loading...");

    AuthenService()
        .signUpWithEmailAndPassword(
            username: _username.text,
            email: _email.text,
            password: _password.text)
        .then(
      (status) {
        if (status == AuthResultStatus.successful) {
          Fluttertoast.showToast(msg: "Successfull");
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => NavBar(
                      index: 0,
                    )),
          );
        } else {
          final errorMsg = AuthException.generateExceptionMessage(status);
          Fluttertoast.showToast(msg: errorMsg);
        }
      },
    );
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
                    'SIGN UP',
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
                  'Create your ',
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'GreycliffCF'),
                ),
                Text(
                  'Jobilee ',
                  style: TextStyle(
                      color: lblue,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'GreycliffCF'),
                ),
                Text(
                  'Account',
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
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

              // Username Field
              TextFormField(
                controller: _username,
                validator: (text) {
                  if (text == null || text.trim().isEmpty) {
                    return 'Username is empty';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Username",
                ),
              ),
              SizedBox(
                height: 13,
              ),

              // Email Sub-Title
              Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                Text(
                  'Email',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'GreycliffCF'),
                ),
              ]),
              SizedBox(
                height: 9,
              ),

              // Username Field
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
                height: 13,
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

              // Password Field
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
                  labelText: "password",
                ),
              ),
              SizedBox(
                height: 33,
              ),

              // Button Sign Up Jobilee
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0.0),
                child: Container(
                  width: 350,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.all(9),
                      backgroundColor: lblue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        handleSignUp();
                      }
                    },
                    //=> _registNotifications(context),
                    child: Text(
                      'Sign Up',
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

              // Text "Already have an account?"
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account?',
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'GreycliffCF'),
                  ),
                ],
              ),
              SizedBox(height: 16),

              // Button Login
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
                            builder: (context) => Login(),
                          ));
                    },
                    child: Text(
                      'Login',
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
