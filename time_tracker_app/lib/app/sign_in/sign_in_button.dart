import 'package:flutter/material.dart';
import 'package:time_tracker_app/common_widget/custom_elevated_button.dart';

class SignInButton extends CustomElevatedButton {
  SignInButton({
    super.key,
    required String text,
    required Color backgroundColor,
    required Color textColor,
    VoidCallback? onPressed,
  }) : super(
          child: Text(
            text,
            style: TextStyle(color: textColor, fontSize: 15.0),
          ),
          backgroundColor: backgroundColor,
          onPressed: onPressed,
        );
}
