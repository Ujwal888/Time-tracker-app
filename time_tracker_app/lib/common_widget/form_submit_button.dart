import 'package:flutter/material.dart';
import 'package:time_tracker_app/common_widget/custom_elevated_button.dart';

class FormSubmitButton extends CustomElevatedButton {
  FormSubmitButton({
    super.key,
    required String text,
    required Color backgroundColor,
    required Color textColor,
    VoidCallback? onPressed,
  }) : super(
          child: Text(
            text,
            style: const TextStyle(color: Colors.white, fontSize: 15.0),
          ),
          height: 44.0,
          backgroundColor: Colors.indigo,
          onPressed: onPressed,
          borderRadius: 4.0,
        );
}
