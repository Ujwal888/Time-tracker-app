import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_app/app/sign_in/email_signin_changed-model.dart';
import 'package:time_tracker_app/common_widget/form_submit_button.dart';
import 'package:time_tracker_app/common_widget/platform_alert_dialog.dart';
import 'package:time_tracker_app/common_widget/platform_exception_dialog.dart';
import 'package:time_tracker_app/services/auth.dart';

class EmailSignInFormChangeNotifier extends StatefulWidget {
  const EmailSignInFormChangeNotifier({super.key, required this.model});
  final EmailSignInChangedModel model;

  static Widget create(BuildContext context) {
    final AuthBase auth = Provider.of<AuthBase>(context);
    return ChangeNotifierProvider<EmailSignInChangedModel>(
      create: (context) => EmailSignInChangedModel(auth: auth),
      child: Consumer<EmailSignInChangedModel>(
        builder: (context, model, _) =>
            EmailSignInFormChangeNotifier(model: model),
      ),
    );
  }

  @override
  State<EmailSignInFormChangeNotifier> createState() =>
      _EmailSignInFormChangeNotifier();
}

class _EmailSignInFormChangeNotifier
    extends State<EmailSignInFormChangeNotifier> {
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  EmailSignInChangedModel get model => widget.model;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _submit() async {
    try {
      await widget.model.submit();
      Navigator.of(context).pop();
    } on PlatformException catch (e) {
      // print(e.runtimeType);
      PlatformExceptionAlertDialog(
        title: 'Sign in failed',
        exception: e,
      ).show(context);
    } on FirebaseAuthException catch (e) {
      PlatformAlertDialog(
        title: 'Sign in failed',
        content: e.message!,
        defaultActionText: 'OK',
      ).show(context);
    }
  }

  void _emailEditingComplete() {
    final newFocus = model.emailValidators.isValid(model.email)
        ? _passwordFocusNode
        : _emailFocusNode;
    FocusScope.of(context).requestFocus(_passwordFocusNode);
  }

  void _toogleFormType() {
    widget.model.toogleFormType();
    _emailController.clear();
    _passwordController.clear();
  }

  List<Widget> _buildChildren() {
    return [
      _buildEmailTextField(),
      const SizedBox(
        height: 12.0,
      ),
      _buildPasswordTextField(),
      const SizedBox(
        height: 12.0,
      ),
      FormSubmitButton(
        text: model.primaryButtonText,
        onPressed: !model.canSubmit ? _submit : null,
        textColor: Colors.black,
        backgroundColor: Colors.white,
      ),
      const SizedBox(
        height: 12.0,
      ),
      TextButton(
          onPressed: !model.isLoading ? _toogleFormType : null,
          child: Text(
            model.secondaryButtonText,
            style: const TextStyle(color: Colors.black),
          )),
    ];
  }

  TextField _buildPasswordTextField() {
    return TextField(
      focusNode: _passwordFocusNode,
      controller: _passwordController,
      decoration: InputDecoration(
        labelText: 'Password',
        errorText: model.passwordErrorText,
        enabled: model.isLoading == false,
      ),
      obscureText: true,
      textInputAction: TextInputAction.next,
      onEditingComplete: _submit,
      onChanged: model.updatePassword,
    );
  }

  TextField _buildEmailTextField() {
    return TextField(
      focusNode: _emailFocusNode,
      controller: _emailController,
      decoration: InputDecoration(
        labelText: 'Email',
        hintText: 'test@test.com',
        errorText: model.emailErrorText,
        enabled: model.isLoading == false,
      ),
      autocorrect: false,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      onEditingComplete: () => _emailEditingComplete(),
      onChanged: model.updateEmail,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: _buildChildren(),
      ),
    );
  }
}
