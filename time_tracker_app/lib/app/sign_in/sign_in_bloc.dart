import 'dart:async';

import 'package:flutter/material.dart';
import 'package:time_tracker_app/services/auth.dart';

class SignInBloc {
  SignInBloc({required this.auth, required this.isLoading});
  final AuthBase auth;
  final ValueNotifier<bool> isLoading;
  Future<FirebaseUser?> _signIn(
      Future<FirebaseUser?> Function() signInMethod) async {
    try {
      isLoading.value = true;
      return await signInMethod();
    } catch (e) {
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<FirebaseUser?> signInAnonymously() async =>
      await _signIn(auth.signInAnonymously);

  Future<FirebaseUser?> signInWithGoogle() async =>
      await _signIn(auth.signInWithGoogle);
  Future<FirebaseUser?> signInWithFacebook() async =>
      await _signIn(auth.signInWithFacebook);
}
