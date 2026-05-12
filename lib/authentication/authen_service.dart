import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:jobilee/rsc/log.dart';
import '../exception/auth_exception.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide User, AuthException, OAuthProvider;

class AuthenService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final _supabase = Supabase.instance.client;

  User? get currentUser => _firebaseAuth.currentUser;
  Map<String, dynamic>? userInfo;

  late AuthResultStatus status;
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  // ─────────────────────────────────────────
  // Email & Password
  // ─────────────────────────────────────────

  Future<AuthResultStatus> loginWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential authResult = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
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
      final UserCredential authResult = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      if (authResult.user != null) {
        await _saveUserDetails(
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

  // ─────────────────────────────────────────
  // Google Sign-In
  // ─────────────────────────────────────────

  Future<AuthResultStatus> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        // User cancelled
        return AuthResultStatus.undefined;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential authResult =
          await _firebaseAuth.signInWithCredential(credential);

      if (authResult.user != null) {
        // Save or update user info in Supabase
        await _saveUserDetails(
          username: authResult.user!.displayName ??
              googleUser.email.split('@').first,
          email: authResult.user!.email ?? googleUser.email,
          userId: authResult.user!.uid,
          profilePic: authResult.user!.photoURL,
        );
        await getUserInfo();
        return AuthResultStatus.successful;
      }
      return AuthResultStatus.undefined;
    } catch (e) {
      AppLog.info('Google Sign-In error: $e');
      return AuthResultStatus.undefined;
    }
  }

  // ─────────────────────────────────────────
  // Apple Sign-In
  // ─────────────────────────────────────────

  String _generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  String _sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<AuthResultStatus> signInWithApple() async {
    try {
      final rawNonce = _generateNonce();
      final nonce = _sha256ofString(rawNonce);

      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
      );

      final oauthCredential = OAuthProvider('apple.com').credential(
        idToken: appleCredential.identityToken,
        rawNonce: rawNonce,
      );

      final UserCredential authResult =
          await _firebaseAuth.signInWithCredential(oauthCredential);

      if (authResult.user != null) {
        final displayName = [
          appleCredential.givenName,
          appleCredential.familyName,
        ].where((e) => e != null && e.isNotEmpty).join(' ');

        await _saveUserDetails(
          username: displayName.isNotEmpty
              ? displayName
              : authResult.user!.email?.split('@').first ?? 'Apple User',
          email: authResult.user!.email ?? '',
          userId: authResult.user!.uid,
        );
        await getUserInfo();
        return AuthResultStatus.successful;
      }
      return AuthResultStatus.undefined;
    } catch (e) {
      AppLog.info('Apple Sign-In error: $e');
      return AuthResultStatus.undefined;
    }
  }

  // ─────────────────────────────────────────
  // User Data (Supabase)
  // ─────────────────────────────────────────

  Future<Map<String, dynamic>?> getUserInfo() async {
    final User? user = _firebaseAuth.currentUser;
    if (user == null) return null;
    final uid = user.uid;
    AppLog.info(uid);

    try {
      final result = await _supabase
          .from('users')
          .select()
          .eq('id', uid)
          .maybeSingle();
      userInfo = result;
      return userInfo;
    } catch (e) {
      AppLog.info('getUserInfo error: $e');
      return null;
    }
  }

  Future<void> _saveUserDetails({
    required String username,
    required String email,
    required String userId,
    String? profilePic,
  }) async {
    await _supabase.from('users').upsert({
      'id': userId,
      'username': username,
      'email': email,
      'profile_pic': profilePic ??
          'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png',
    });
  }

  Future<void> pushNotification(String title, String message) async {
    final uid = currentUser?.uid;
    if (uid == null) return;

    await _supabase.from('notifications').insert({
      'user_id': uid,
      'title': title,
      'msg': message,
      'datetime': DateTime.now().toIso8601String(),
    });
  }

  Future<void> signOut() async {
    await GoogleSignIn().signOut();
    await _firebaseAuth.signOut();
    userInfo = null;
  }
}
