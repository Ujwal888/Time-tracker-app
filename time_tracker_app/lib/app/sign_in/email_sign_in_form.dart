// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:provider/provider.dart';
// import 'package:time_tracker_app/app/sign_in/email_signin_model.dart';
// import 'package:time_tracker_app/app/sign_in/validators.dart';
// import 'package:time_tracker_app/common_widget/form_submit_button.dart';
// import 'package:time_tracker_app/common_widget/platform_alert_dialog.dart';
// import 'package:time_tracker_app/common_widget/platform_exception_dialog.dart';
// import 'package:time_tracker_app/services/auth.dart';

// class EmailSignInFormStateful extends StatefulWidget
//     with EmailAndPasswordValidators {
//   @override
//   State<EmailSignInFormStateful> createState() => _EmailSignInFormStateful();
// }

// class _EmailSignInFormStateful extends State<EmailSignInFormStateful> {
//   final TextEditingController _emailController = TextEditingController();

//   final TextEditingController _passwordController = TextEditingController();
//   final FocusNode _emailFocusNode = FocusNode();
//   final FocusNode _passwordFocusNode = FocusNode();
//   String get _email => _emailController.text;
//   String get _password => _passwordController.text;

//   EmailSignInFormType _formType = EmailSignInFormType.signIn;
//   bool _submitted = false;
//   bool _isLoading = false;
//   @override
//   void dispose() {
//     _emailController.dispose();
//     _passwordController.dispose();
//     _emailFocusNode.dispose();
//     _passwordFocusNode.dispose();
//     super.dispose();
//   }

//   Future<void> _submit() async {
//     setState(() {
//       _submitted = true;
//       _isLoading = true;
//     });
//     try {
//       final auth = Provider.of<AuthBase>(context, listen: false);
//       if (_formType == EmailSignInFormType.signIn) {
//         await auth.signInWithEmailAndPassword(_email, _password);
//       } else {
//         await auth.createUserWithEmailAndPassword(_email, _password);
//       }
//       Navigator.of(context).pop();
//     } on PlatformException catch (e) {
//       // print(e.runtimeType);
//       PlatformExceptionAlertDialog(
//         title: 'Sign in failed',
//         exception: e,
//       ).show(context);
//     } on FirebaseAuthException catch (e) {
//       PlatformAlertDialog(
//         title: 'Sign in failed',
//         content: e.message!,
//         defaultActionText: 'OK',
//       ).show(context);
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   void _emailEditingComplete() {
//     final newFocus = widget.emailValidators.isValid(_email)
//         ? _passwordFocusNode
//         : _emailFocusNode;
//     FocusScope.of(context).requestFocus(_passwordFocusNode);
//   }

//   void _toogleFormType() {
//     setState(() {
//       _submitted = false;
//       _formType = _formType == EmailSignInFormType.signIn
//           ? EmailSignInFormType.register
//           : EmailSignInFormType.signIn;
//     });
//     _emailController.clear();
//     _passwordController.clear();
//   }

//   List<Widget> _buildChildren() {
//     final primaryText = _formType == EmailSignInFormType.signIn
//         ? 'Sign in '
//         : 'Create an account';
//     final secondaryText = _formType == EmailSignInFormType.signIn
//         ? 'Need an account? Register '
//         : 'Have an Account? Sign in';
//     bool submitEnabled = widget.emailValidators.isValid(_email) &&
//         widget.passwordValidators.isValid(_password) &&
//         !_isLoading;
//     return [
//       _buildEmailTextField(),
//       const SizedBox(
//         height: 12.0,
//       ),
//       _buildPasswordTextField(),
//       const SizedBox(
//         height: 12.0,
//       ),
//       FormSubmitButton(
//         text: primaryText,
//         onPressed: submitEnabled ? _submit : null,
//         textColor: Colors.black,
//         backgroundColor: Colors.white,
//       ),
//       const SizedBox(
//         height: 12.0,
//       ),
//       TextButton(
//           onPressed: !_isLoading ? _toogleFormType : null,
//           child: Text(
//             secondaryText,
//             style: const TextStyle(color: Colors.black),
//           )),
//     ];
//   }

//   TextField _buildPasswordTextField() {
//     bool passwordValid =
//         _submitted && !widget.passwordValidators.isValid(_password);
//     return TextField(
//       focusNode: _passwordFocusNode,
//       controller: _passwordController,
//       decoration: InputDecoration(
//         labelText: 'Password',
//         errorText: passwordValid ? widget.invalidPasswordErrorText : null,
//         enabled: _isLoading == false,
//       ),
//       obscureText: true,
//       textInputAction: TextInputAction.next,
//       onEditingComplete: _submit,
//       onChanged: (password) => updateState(),
//     );
//   }

//   TextField _buildEmailTextField() {
//     bool emailValid = _submitted && !widget.emailValidators.isValid(_email);
//     return TextField(
//       focusNode: _emailFocusNode,
//       controller: _emailController,
//       decoration: InputDecoration(
//         labelText: 'Email',
//         hintText: 'test@test.com',
//         errorText: emailValid ? widget.invalidEmailErrorText : null,
//         enabled: _isLoading == false,
//       ),
//       autocorrect: false,
//       keyboardType: TextInputType.emailAddress,
//       textInputAction: TextInputAction.next,
//       onEditingComplete: _emailEditingComplete,
//       onChanged: (email) => updateState(),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         mainAxisSize: MainAxisSize.min,
//         children: _buildChildren(),
//       ),
//     );
//   }

//   updateState() {
//     setState(() {});
//   }
// }
