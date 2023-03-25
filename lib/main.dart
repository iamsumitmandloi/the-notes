import 'package:flutter/material.dart';
import 'package:thenotes/constants/routes.dart';
import 'package:thenotes/services/auth/auth_services.dart';
import 'package:thenotes/views/login_view.dart';
import 'package:thenotes/views/notes_view.dart';
import 'package:thenotes/views/register_view.dart';
import 'package:thenotes/views/verify_email.dart';
import 'firebase_options.dart';
import 'dart:developer' as dev show log;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
      routes: {
        loginRoute : (context) => const LoginView(),
        registerRoute : (context) => const RegisterView(),
        notesRoute : (context) => const NotesView(),
        verifyEmailRoute : (context) => const VerifyEmailView()
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService.firebase().initialize(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = AuthService.firebase().currentUser;
            if (user != null) {
              if (user.isEmailVerified) {
                dev.log('verified user');
                return const NotesView();
              } else {
                dev.log('verify your email');
                return const VerifyEmailView();
              }
            } else {
              return const LoginView();
            }
            return const Center(child: Text('Done'));

          default:
            return const Center(
              child: CircularProgressIndicator(),
            );
        }
      },
    );
  }
}

