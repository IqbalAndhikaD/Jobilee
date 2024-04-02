// ignore_for_file: use_super_parameters, prefer_const_literals_to_create_immutables, prefer_const_constructors, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:tubes/home.dart';
import 'package:tubes/login.dart';
import 'package:tubes/rsc/colors.dart';

class Register extends StatefulWidget {
  const Register ({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _LoginState();
}

class _LoginState extends State<Register> {
  bool _isSecurePassword = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.all(38),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              // Title
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('SIGN UP', style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w900,
                    fontFamily: 'GreycliffCF'
                  ),),
                ],
              ),
              SizedBox(height: 5,),


              // Sub-Title
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('Create your ', style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'GreycliffCF'
                  ),),
                  Text('Jobilee ', style: TextStyle(
                    color: lblue,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'GreycliffCF'
                  ),),
                  Text('Account', style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'GreycliffCF'
                  ),)
                ]
              ),
              SizedBox(height: 33,),


              // Username Sub-Title
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('Username', style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'GreycliffCF'
                  ),),
                ]
              ),
              SizedBox(height: 9,),


              // Username Field
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0.0),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: TextField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Enter your username', 
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                          fontFamily: 'GreycliffCF'
                        )
                      ),
                    ),
                  ),
                ), 
              ),
              SizedBox(height: 13,),

              // Email Sub-Title
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('Email', style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'GreycliffCF'
                  ),),
                ]
              ),
              SizedBox(height: 9,),


              // Username Field
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0.0),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: TextField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Enter your email', 
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                          fontFamily: 'GreycliffCF'
                        )
                      ),
                    ),
                  ),
                ), 
              ),
              SizedBox(height: 13,),

              // Password Sub-Title 
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('Password', style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'GreycliffCF'
                  ),),
                ]
              ),
              SizedBox(height: 9,),


              // Password Field
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0.0),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: TextField(
                      obscureText: _isSecurePassword,
                      textAlignVertical: TextAlignVertical.center,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Enter your password', 
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                          fontFamily: 'GreycliffCF'
                        ),
                        suffixIcon: togglePassword(),
                      ),
                    ),
                  ),
                ), 
              ),
              SizedBox(height: 33,),


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
                      Navigator.push(context, MaterialPageRoute(builder: (context) => Home(title: 'Jobile',) ,));
                    },
                    child: Text('Sign Up',
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
                  Text('Already have an account?', 
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'GreycliffCF'
                    ),
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
                        side: BorderSide(color: lblue)
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => Login() ,));
                    },
                    child: Text('Login',
                      style: TextStyle(
                        fontSize: 17,
                        color: lblue,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'GreycliffCF'
                      ),
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

  Widget togglePassword () {
    return IconButton(onPressed: () {
      setState(() {
              _isSecurePassword = !_isSecurePassword;
      });
    }, icon: _isSecurePassword ? Icon(Icons.visibility) : Icon(Icons.visibility_off),
      color: lblue,
    );
  }
}
