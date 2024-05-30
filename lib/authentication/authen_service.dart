import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/rendering.dart';
import 'package:tubes/rsc/log.dart';
import '../exception/auth_exception.dart';

class AuthenService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  User? get currentUser => _firebaseAuth.currentUser;
  Map<String, dynamic>? userInfo;
  
  late AuthResultStatus status;
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<AuthResultStatus> loginWithEmailAndPassword ({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential authResult = 
        await _firebaseAuth.signInWithEmailAndPassword(
          email: email, 
          password: password
        );
        if (authResult.user != null) {
          status = AuthResultStatus.successful;
          await getUserInfo();
        } else {
          status = AuthResultStatus.undefined;
        }
        return status;
    } catch (msg) {
      status = AuthException.handleException(msg);
    }
    return status;
  }

  Future<AuthResultStatus> checkAuthStatus() async {
    if (_firebaseAuth.currentUser != null) {
      await getUserInfo();
      return AuthResultStatus.successful;
    } else {
      return AuthResultStatus.undefined;
    }
  }

  Future<AuthResultStatus> signUpWithEmailAndPassword({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential authResult = 
        await _firebaseAuth.createUserWithEmailAndPassword(
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

  Future<Map<String, dynamic>?> getUserInfo() async {
    final User? user = _firebaseAuth.currentUser;
    final uid = user!.uid;
    AppLog.info(uid);
    final result = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    userInfo = result.data();

    return userInfo;
  }

  void _saveUserDetails({required String username, email, userId}) {
    FirebaseFirestore.instance.collection('users').doc(userId).set({
      'username': username,
      'email': email,
      "userId": userId,
    }); 
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

}