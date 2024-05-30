import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/rendering.dart';
import '../exception/auth_exception.dart';


class AuthenService {
  late AuthResultStatus status;
  Future<AuthResultStatus> loginWithEmailAndPassword ({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential authResult = 
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email, 
          password: password
        );
        if (authResult.user != null) {
          status = AuthResultStatus.successful;
        } else {
          status = AuthResultStatus.undefined;
        }
        return status;
    } catch (msg) {
      status = AuthException.handleException(msg);
    }
    return status;
  }

  Future<AuthResultStatus> signUpWithEmailAndPassword({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential authResult = 
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email, 
          password: password
        );
        if (authResult.user != null) {
          _saveUserDetails(
            username: username,
            email: email,
            userId: authResult.user!.uid, 
          );
          status = AuthResultStatus.successful;
        } else {
          status = AuthResultStatus.undefined;
        }
        return status;
    } catch (msg) {
      status = AuthException.handleException(msg);
    }
    return status;
  }

  void _saveUserDetails({required String username, email, userId}) {
    FirebaseFirestore.instance.collection('users').doc(userId).set({
      'username': username,
      'emaail': email,
      "userId": userId,
    }); 
  }

}