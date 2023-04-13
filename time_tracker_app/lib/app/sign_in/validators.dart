abstract class StringValidators {
  bool isValid(String value);
}

class NonEmptyStringValidators implements StringValidators {
  @override
  bool isValid(String value) {
    return value.isNotEmpty;
  }
}

class EmailAndPasswordValidators {
  final StringValidators emailValidators = NonEmptyStringValidators();
  final StringValidators passwordValidators = NonEmptyStringValidators();
  final String invalidEmailErrorText = 'Email cant be empty';
  final String invalidPasswordErrorText = 'Password cant be empty';
}
