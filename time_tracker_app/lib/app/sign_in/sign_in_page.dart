import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_app/app/sign_in/email_sign_in_page.dart';
import 'package:time_tracker_app/app/sign_in/sign_in_bloc.dart';
import 'package:time_tracker_app/app/sign_in/sign_in_button.dart';
import 'package:time_tracker_app/app/sign_in/social_sign_in_button.dart';
import 'package:time_tracker_app/common_widget/platform_exception_dialog.dart';
import 'package:time_tracker_app/services/auth.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({
    super.key,
    required this.bloc,
    required this.isLoading,
  });
  final bool isLoading;
  final SignInBloc bloc;
  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context);
    return ChangeNotifierProvider<ValueNotifier<bool>>(
      create: (_) => ValueNotifier<bool>(false),
      child: Consumer<ValueNotifier<bool>>(
        builder: (_, isLoading, __) => Provider<SignInBloc>(
          create: (_) => SignInBloc(auth: auth, isLoading: isLoading),
          child: Consumer<SignInBloc>(
            builder: (context, bloc, _) =>
                SignInPage(bloc: bloc, isLoading: isLoading.value),
          ),
        ),
      ),
    );
  }

  void _showSignInError(BuildContext context, PlatformException exception) {
    PlatformExceptionAlertDialog(
      exception: exception,
      title: 'Sign in failed ',
    ).show(context);
  }

  Future<void> _signInAnonymously(BuildContext context) async {
    try {
      await bloc.signInAnonymously();
    } on PlatformException catch (e) {
      _showSignInError(context, e);
    }
  }

  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      await bloc.signInWithGoogle();
    } on PlatformException catch (e) {
      if (e.code != 'ERROR_ABORTED_BY_USER') {
        _showSignInError(context, e);
      }
    }
  }

  Future<void> _signInWithFacebook(BuildContext context) async {
    try {
      await bloc.signInWithFacebook();
    } on PlatformException catch (e) {
      if (e.code != 'ERROR_ABORTED_BY_USER') {
        _showSignInError(context, e);
      }
    }
  }

  void _signInWithEmail(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      fullscreenDialog: true,
      builder: (context) => EmailSignInPage(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    // Provider.of<AuthBase>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Time Tracker"),
        elevation: 2.0,
      ),
      body: _buildContent(context),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(height: 50.0, child: _buildHeader()),
          const SizedBox(
            height: 50.0,
          ),
          SocialSignInButton(
            assetName: 'images/g.png',
            text: 'Sign in with Google',
            textColor: Colors.black87,
            backgroundColor: Colors.white,
            onPressed: isLoading ? null : () => _signInWithGoogle(context),
          ),
          const SizedBox(
            height: 10,
          ),
          SocialSignInButton(
            assetName: 'images/f.png',
            text: 'Sign in with Facebook',
            textColor: Colors.white,
            backgroundColor: const Color.fromARGB(255, 62, 86, 151),
            onPressed: isLoading ? null : () => _signInWithFacebook(context),
          ),
          const SizedBox(
            height: 10,
          ),
          SignInButton(
            text: 'Sign in with Email',
            textColor: Colors.white,
            onPressed: isLoading ? null : () => _signInWithEmail(context),
            backgroundColor: const Color(0xFF00796B),
          ),
          const SizedBox(
            height: 10,
          ),
          const Text(
            'or',
            style: TextStyle(color: Colors.black87, fontSize: 15),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 10,
          ),
          SignInButton(
            text: 'Go anonymous',
            textColor: Colors.black87,
            onPressed: isLoading ? null : () => _signInAnonymously(context),
            backgroundColor: const Color(0xFFDCE775),
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return const Text(
      'Sign In',
      textAlign: TextAlign.center,
      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 32.0),
    );
  }
}
