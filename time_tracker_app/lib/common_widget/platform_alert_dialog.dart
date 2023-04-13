import 'dart:io';
import 'package:time_tracker_app/common_widget/platform_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class PlatformAlertDialog extends PlatformWidget {
  const PlatformAlertDialog(
      {super.key,
      required this.content,
      this.cancelActionText,
      required this.title,
      required this.defaultActionText});
  final String content;
  final String title;
  final String? cancelActionText;
  final String defaultActionText;

  Future<bool?> show(BuildContext context) async {
    return Platform.isIOS
        ? await showCupertinoDialog(
            context: context, builder: (context) => this)
        : await showDialog<bool>(
            barrierDismissible: true,
            context: context,
            builder: (content) => this,
          );
  }

  @override
  Widget buildCupertinoWidget(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(title),
      content: Text(content),
      actions: _buildActions(context),
    );
  }

  @override
  Widget buildMaterialWidget(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: _buildActions(context),
    );
  }

  List<Widget> _buildActions(BuildContext context) {
    final action = <Widget>[];
    if (cancelActionText != null) {
      action.add(PlatformAlertDialogAction(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(cancelActionText!)));
    }
    action.add(PlatformAlertDialogAction(
        onPressed: () => Navigator.of(context).pop(true),
        child: Text(defaultActionText)));
    return action;
  }
}

class PlatformAlertDialogAction extends PlatformWidget {
  const PlatformAlertDialogAction(
      {super.key, required this.child, required this.onPressed});
  final Widget child;
  final VoidCallback onPressed;

  @override
  Widget buildCupertinoWidget(BuildContext context) {
    return CupertinoDialogAction(
      child: child,
      onPressed: onPressed,
    );
  }

  @override
  Widget buildMaterialWidget(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: child,
    );
  }
}
