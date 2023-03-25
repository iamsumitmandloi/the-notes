import 'package:flutter/material.dart';
import 'package:thenotes/constants/routes.dart';
import 'package:thenotes/enums/menu_actions.dart';
import 'dart:developer' as dev show log;

import 'package:thenotes/services/auth/auth_services.dart';

class NotesView extends StatefulWidget {
  const NotesView({Key? key}) : super(key: key);

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Main ui'),
        actions: [
          PopupMenuButton<MenuAction>(onSelected: (value) async {
            dev.log(value.toString());
            switch (value) {
              case MenuAction.logout:
                final shouldLogout = await showLogOutDialog(context);
                dev.log(shouldLogout.toString());
                if (shouldLogout) {
                  await AuthService.firebase().logOut();
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil(loginRoute, (route) => false);
                }
            }
          }, itemBuilder: (c) {
            return const [
              PopupMenuItem<MenuAction>(
                value: MenuAction.logout,
                child: Text('Logout'),
              ),
            ];
          }),
        ],
      ),
      body: TextButton(
        onPressed: () {},
        child: const Center(child: Text('Log out')),
      ),
    );
  }
}

Future<bool> showLogOutDialog(BuildContext context) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Sign out'),
          content: const Text('Are you sure you want to Sign Out'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text('LogOut'),
            ),
          ],
        );
      }).then((value) => value ?? false);
}
