import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '/bloc/app_bloc.dart';
import '/bloc/app_event.dart';
import '/dialog/delete_account_dialog.dart';
import '/dialog/logout_dialog.dart';

enum MenuAction { logout, deleteAccount }

class MainPopUpMenuButton extends StatelessWidget {
  const MainPopUpMenuButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<MenuAction>(onSelected: (value) async {
      switch (value) {
        case MenuAction.logout:
          final shouldLogout = await showLogoutDialog(context);
          if (shouldLogout) {
            context.read<AppBloc>().add(const AppEventLogout());
          }
          break;
        case MenuAction.deleteAccount:
          final shouldDeleteAccount = await showDeleteAccountDialog(context);
          if (shouldDeleteAccount) {
            context.read<AppBloc>().add(const AppEventDeleteAccount());
          }
          break;
      }
    }, itemBuilder: (context) {
      return [
        const PopupMenuItem(
          value: MenuAction.logout,
          child: Text("Log out"),
        ),
        const PopupMenuItem(
          value: MenuAction.deleteAccount,
          child: Text("Delete account"),
        ),
      ];
    });
  }
}
