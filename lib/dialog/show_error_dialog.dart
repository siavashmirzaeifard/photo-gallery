import 'package:flutter/material.dart' show BuildContext;

import '/auth/auth_error.dart';
import '/dialog/generic_dialog.dart';

Future<void> showErrorDialog({
  required BuildContext context,
  required AuthError authError,
}) {
  return showGenericDialog<void>(
    context: context,
    title: authError.dialogTitle,
    content: authError.dialogText,
    optionBuilder: () => {"OK": true},
  );
}
