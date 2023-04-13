import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';

class FirebaseUser {
  FirebaseUser({required this.uid});
  final String uid;
}

abstract class AuthBase {
  Stream<FirebaseUser?> get authStateChanges;
  Future<FirebaseUser?> currentUser();
  Future<FirebaseUser?> signInAnonymously();
  Future<void> signout();
  Future<FirebaseUser?> signInWithGoogle();
  Future<FirebaseUser?> signInWithFacebook();
  Future<FirebaseUser?> signInWithEmailAndPassword(
      String email, String password);
  Future<FirebaseUser?> createUserWithEmailAndPassword(
      String email, String password);
}

class Auth implements AuthBase {
  final _firebaseAuth = FirebaseAuth.instance;

  FirebaseUser? _userFromFirebase(User? user) {
    if (user == null) {
      return null;
    }
    return FirebaseUser(uid: user.uid);
  }

  @override
  Stream<FirebaseUser?> get authStateChanges {
    return _firebaseAuth.authStateChanges().map(_userFromFirebase);
  }

  @override
  Future<FirebaseUser?> currentUser() async {
    final user = _firebaseAuth.currentUser;
    return _userFromFirebase(user);
  }

  @override
  Future<FirebaseUser?> signInAnonymously() async {
    final authResult = await _firebaseAuth.signInAnonymously();
    return _userFromFirebase(authResult.user);
  }

  @override
  Future<FirebaseUser?> signInWithEmailAndPassword(
      String email, String password) async {
    final authResult = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    return _userFromFirebase(authResult.user);
  }

  @override
  Future<FirebaseUser?> createUserWithEmailAndPassword(
      String email, String password) async {
    final authResult = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    return _userFromFirebase(authResult.user);
  }

  @override
  Future<FirebaseUser?> signInWithGoogle() async {
    final googleSignIn = GoogleSignIn();
    final googleAccount = await googleSignIn.signIn();
    if (googleAccount != null) {
      final googleAuth = await googleAccount.authentication;
      if (googleAuth.idToken != null && googleAuth.accessToken != null) {
        final authResult = await _firebaseAuth.signInWithCredential(
          GoogleAuthProvider.credential(
              idToken: googleAuth.idToken, accessToken: googleAuth.accessToken),
        );
        return _userFromFirebase(authResult.user);
      } else {
        throw PlatformException(
          code: "ERROR_MISSING_GOOGLE_AUTH_TOKEN",
          message: 'Missing Google Auth Token',
        );
      }
    } else {
      throw PlatformException(
        code: "ERROR_ABBORTED_BY_USER",
        message: 'Sign In Aborted By User',
      );
    }
  }

  @override
  Future<FirebaseUser?> signInWithFacebook() async {
    final facebookLogin = FacebookLogin();
    final result = await facebookLogin.logIn();
    if (result.accessToken != null) {
      final authResult = await _firebaseAuth.signInWithCredential(
        FacebookAuthProvider.credential(
          result.accessToken!.token,
        ),
      );
      return _userFromFirebase(authResult.user);
    } else {
      throw PlatformException(
        code: "ERROR_ABBORTED_BY_USER",
        message: 'Sign In Aborted By User',
      );
    }
  }

  @override
  Future<void> signout() async {
    final googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
    final facebookLogin = FacebookLogin();
    await facebookLogin.logOut();
    await _firebaseAuth.signOut();
  }
}
