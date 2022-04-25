import 'package:flutter/material.dart' show BuildContext;

import '/dialog/generic_dialog.dart';

Future<bool> showLogoutDialog(BuildContext context) {
  return showGenericDialog<bool>(
    context: context,
    title: "Logout",
    content: "Are you sure you want to logout?",
    optionBuilder: () => {
      "Cancel": false,
      "Log out": true,
    },
  ).then((value) => value ?? false);
}
