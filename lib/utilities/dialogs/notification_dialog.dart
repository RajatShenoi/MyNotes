import 'package:flutter/material.dart';
import 'package:mynotes/utilities/dialogs/generic_dialog.dart';

Future<void> showNotificationDialog(
  BuildContext context,
  String text,
) {
  return showGenericDialog<void>(
    context: context,
    title: 'New Notification',
    content: text,
    optionsBuilder: () => {
      'OK': null,
    },
  );
}
