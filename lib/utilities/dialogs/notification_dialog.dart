import 'package:flutter/material.dart';
import 'package:mynotes/utilities/dialogs/generic_dialog.dart';

Future<void> showNotificationDialog(
  BuildContext context,
  String heading,
  String body,
) {
  return showGenericDialog<void>(
    context: context,
    title: heading,
    content: body,
    optionsBuilder: () => {
      'OK': null,
    },
  );
}
