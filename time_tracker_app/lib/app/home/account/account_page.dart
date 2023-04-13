import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_app/common_widget/platform_alert_dialog.dart';
import 'package:time_tracker_app/services/auth.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});
  Future<void> _signOut(BuildContext context) async {
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signout();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final didRequestSignOut = await const PlatformAlertDialog(
      title: 'Logout',
      content: 'Are you sure that you want to logout ?',
      cancelActionText: 'Cancel',
      defaultActionText: 'LogOut',
    ).show(context);
    if (didRequestSignOut == true) {
      _signOut(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Account'),
        actions: [
          TextButton(
              onPressed: () => _confirmSignOut(context),
              child: const Text(
                'Logout',
                style: TextStyle(color: Colors.white),
              ))
        ],
      ),
    );
  }
}
