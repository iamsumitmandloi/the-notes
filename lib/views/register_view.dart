import 'package:flutter/material.dart';
import 'package:thenotes/constants/routes.dart';
import 'package:thenotes/services/auth/auth_exceptions.dart';
import 'package:thenotes/services/auth/auth_services.dart';
import 'dart:developer' as dev show log;

import 'package:thenotes/utilities/show_error_dailog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _email,
            decoration: const InputDecoration(hintText: 'Enter Email'),
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
          ),
          TextField(
            controller: _password,
            decoration: const InputDecoration(hintText: 'Enter Password'),
            enableSuggestions: false,
            autocorrect: false,
            obscureText: true,
          ),
          TextButton(
            child: const Text('Register'),
            onPressed: () async {
              final email = _email.text;
              final pass = _password.text;
              try {
                await AuthService.firebase().createUser(
                  email: email,
                  password: pass,
                );
                final user = AuthService.firebase().currentUser;
                await AuthService.firebase().sendEmailVerification();
                Navigator.of(context).pushNamed(verifyEmailRoute);
              } on WeakPasswordAuthException {
                showErrorDialog(context, 'weak password');
              } on EmailAlreadyInUseAuthException {
                showErrorDialog(context,
                    'already register with this email please chane email');
              } on InvalidEmailAuthException {
                showErrorDialog(context, 'Email inValid');
              } on GenericAuthException {
                showErrorDialog(context, 'Error Please try Again');
              } catch (e) {
                showErrorDialog(context, 'Error please try Again');
              }
            },
          ),
          TextButton(
            child: const Text('Already Registered? Login here'),
            onPressed: () async {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(loginRoute, (route) => false);
            },
          ),
        ],
      ),
    );
  }
}
