import 'package:flutter/services.dart';
import 'package:time_tracker_app/common_widget/platform_alert_dialog.dart';

class PlatformExceptionAlertDialog extends PlatformAlertDialog {
  PlatformExceptionAlertDialog({
    super.key,
    required String title,
    required PlatformException exception,
  }) : super(
          title: title,
          content: exception.message!,
          defaultActionText: 'OK',
        );
  static String? _messagge(PlatformException exception) {
    return exception.message;
  }

  static Map<String, String> _errors = {};
}
