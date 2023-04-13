import 'package:flutter/material.dart';
import 'package:time_tracker_app/app/sign_in/email_signin_model.dart';
import 'package:time_tracker_app/app/sign_in/validators.dart';
import 'package:time_tracker_app/services/auth.dart';

class EmailSignInChangedModel with EmailAndPasswordValidators, ChangeNotifier {
  EmailSignInChangedModel(
      {required this.auth,
      this.email = '',
      this.submitted = false,
      this.formType = EmailSignInFormType.signIn,
      this.isLoading = false,
      this.password = ''});
  final AuthBase auth;
  String email;
  String password;
  EmailSignInFormType formType;
  bool isLoading;
  bool submitted;

  get updatePassword => null;

  get updateEmail => null;
  Future<void> submit() async {
    updateWith(submitted: true, isLoading: true);
    try {
      if (formType == EmailSignInFormType.signIn) {
        await auth.signInWithEmailAndPassword(email, password);
      } else {
        await auth.createUserWithEmailAndPassword(email, password);
      }
    } catch (e) {
      updateWith(isLoading: false);
      rethrow;
    }
  }

  String get primaryButtonText {
    return formType == EmailSignInFormType.signIn
        ? 'Sign in '
        : 'Create an account';
  }

  String get secondaryButtonText {
    return formType == EmailSignInFormType.signIn
        ? 'Need an account? Register '
        : 'Have an Account? Sign in';
  }

  bool get canSubmit {
    return emailValidators.isValid(email) &&
        passwordValidators.isValid(password) &&
        !isLoading;
  }

  String? get passwordErrorText {
    bool passwordValid = submitted && !passwordValidators.isValid(password);
    return passwordValid ? invalidPasswordErrorText : null;
  }

  String? get emailErrorText {
    bool emailValid = submitted && !emailValidators.isValid(email);
    return emailValid ? invalidEmailErrorText : null;
  }

  void toogleFormType() {
    final formType = this.formType == EmailSignInFormType.signIn
        ? EmailSignInFormType.register
        : EmailSignInFormType.signIn;
    updateWith(
      email: '',
      password: '',
      formType: formType,
      submitted: false,
      isLoading: false,
    );
  }

  void updateWith({
    String? email,
    String? password,
    EmailSignInFormType? formType,
    bool? submitted,
    bool? isLoading,
  }) {
    this.email = email ?? this.email;
    this.password = password ?? this.password;
    this.formType = formType ?? this.formType;
    this.isLoading = isLoading ?? this.isLoading;
    this.submitted = submitted ?? this.submitted;
    notifyListeners();
  }
}
