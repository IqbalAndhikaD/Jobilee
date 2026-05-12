// ignore_for_file: use_super_parameters, prefer_const_literals_to_create_immutables, prefer_const_constructors, sized_box_for_whitespace, use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jobilee/authentication/authen_service.dart';
import 'package:jobilee/navbar.dart';
import 'package:jobilee/register.dart';
import 'package:jobilee/rsc/colors.dart';
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
  bool _isLoading = false;

  void _setLoading(bool v) => setState(() => _isLoading = v);

  void handleLogin() async {
    _setLoading(true);
    try {
      var user = await AuthenService().loginWithEmailAndPassword(
        email: _email.text,
        password: _password.text,
      );

      if (user == AuthResultStatus.successful) {
        Fluttertoast.showToast(msg: "Login Successful");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => NavBar(index: 0)),
        );
      } else {
        final errorMsg = AuthException.generateExceptionMessage(user);
        Fluttertoast.showToast(msg: errorMsg);
      }
    } catch (e) {
      final errorMsg = AuthException.generateExceptionMessage(e);
      Fluttertoast.showToast(msg: errorMsg);
    }
    _setLoading(false);
  }

  void handleGoogleSignIn() async {
    _setLoading(true);
    try {
      final result = await AuthenService().signInWithGoogle();
      if (result == AuthResultStatus.successful) {
        Fluttertoast.showToast(msg: "Login Successful");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => NavBar(index: 0)),
        );
      } else {
        Fluttertoast.showToast(msg: "Google Sign-In failed. Please try again.");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Error: ${e.toString()}");
    }
    _setLoading(false);
  }

  void handleAppleSignIn() async {
    _setLoading(true);
    try {
      final result = await AuthenService().signInWithApple();
      if (result == AuthResultStatus.successful) {
        Fluttertoast.showToast(msg: "Login Successful");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => NavBar(index: 0)),
        );
      } else {
        Fluttertoast.showToast(msg: "Apple Sign-In failed. Please try again.");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Error: ${e.toString()}");
    }
    _setLoading(false);
  }

  @override
  void initState() {
    super.initState();
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
              SizedBox(height: 5),

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
              SizedBox(height: 33),

              // Email Field
              Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                Text('Email',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'GreycliffCF')),
              ]),
              SizedBox(height: 9),
              TextFormField(
                controller: _email,
                keyboardType: TextInputType.emailAddress,
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
              SizedBox(height: 10),

              // Password Field
              Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                Text('Password',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'GreycliffCF')),
              ]),
              SizedBox(height: 9),
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
              SizedBox(height: 24),

              // Button Login
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.all(14),
                    backgroundColor: lblue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: _isLoading
                      ? null
                      : () {
                          if (_formKey.currentState?.validate() ?? false) {
                            handleLogin();
                          }
                        },
                  child: _isLoading
                      ? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2))
                      : Text('Login',
                          style: TextStyle(
                              fontSize: 17,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'GreycliffCF')),
                ),
              ),
              SizedBox(height: 16),

              // Divider
              Row(children: [
                Expanded(child: Divider()),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Text('or',
                      style: TextStyle(color: Colors.grey, fontSize: 13)),
                ),
                Expanded(child: Divider()),
              ]),
              SizedBox(height: 16),

              // Button Google Sign-In
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.all(14),
                    side: BorderSide(color: Colors.grey.shade300),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: _isLoading ? null : handleGoogleSignIn,
                  icon: Image.network(
                    'https://www.google.com/favicon.ico',
                    height: 20,
                    width: 20,
                    errorBuilder: (_, __, ___) => Icon(Icons.g_mobiledata,
                        color: Colors.red, size: 24),
                  ),
                  label: Text(
                    'Continue with Google',
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.black87,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'GreycliffCF'),
                  ),
                ),
              ),
              SizedBox(height: 12),

              // Button Apple Sign-In (iOS only)
              if (Platform.isIOS)
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.all(14),
                      backgroundColor: Colors.black,
                      side: BorderSide(color: Colors.black),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: _isLoading ? null : handleAppleSignIn,
                    icon: Icon(Icons.apple, color: Colors.white, size: 22),
                    label: Text(
                      'Sign in with Apple',
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'GreycliffCF'),
                    ),
                  ),
                ),
              SizedBox(height: 16),

              // Register link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have any account?",
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                          fontFamily: 'GreycliffCF')),
                ],
              ),
              SizedBox(height: 12),

              // Button Create Account
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.all(14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(color: lblue)),
                  ),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Register()));
                  },
                  child: Text('Create Account',
                      style: TextStyle(
                          fontSize: 17,
                          color: lblue,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'GreycliffCF')),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
