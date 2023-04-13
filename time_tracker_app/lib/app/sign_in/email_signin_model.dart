import 'package:time_tracker_app/app/sign_in/validators.dart';

enum EmailSignInFormType { signIn, register }

class EmailSignInModel with EmailAndPasswordValidators {
  EmailSignInModel(
      {this.email = '',
      this.submitted = false,
      this.formType = EmailSignInFormType.signIn,
      this.isLoading = false,
      this.password = ''});
  final String email;
  final String password;
  final EmailSignInFormType formType;
  final bool isLoading;
  final bool submitted;
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

  bool? get canSubmit {
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

  EmailSignInModel copyWith({
    String? email,
    String? password,
    EmailSignInFormType? formType,
    bool? submitted,
    bool? isLoading,
  }) {
    return EmailSignInModel(
      email: email ?? this.email,
      password: password ?? this.password,
      formType: formType ?? this.formType,
      isLoading: isLoading ?? this.isLoading,
      submitted: submitted ?? this.submitted,
    );
  }
}
