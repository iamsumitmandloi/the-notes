import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:thenotes/constants/routes.dart';
import 'package:thenotes/firebase_options.dart';
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
      appBar: AppBar(title: const Text('Register'),),
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
                await FirebaseAuth.instance
                    .createUserWithEmailAndPassword(
                  email: email,
                  password: pass,
                );
                final user = FirebaseAuth.instance.currentUser;
                await user?.sendEmailVerification();
                Navigator.of(context).pushNamed(verifyEmailRoute);
              }
              on FirebaseAuthException catch(e){
                if(e.code == 'weak-password') {
                  showErrorDialog(context, 'weak password');
                }
                else if(e.code == 'email-already-in-use'){
                  showErrorDialog(context, 'already register with this email please chane email');
                }
                else if(e.code == 'invalid-email'){
                  showErrorDialog(context, 'Email inValid');
                }
                else{
                  showErrorDialog(context, 'Error ${e.code}');
                }
              }
              catch(e){
                showErrorDialog(context, 'Error please try Again');
              }
            },
          ),
          TextButton(
            child: const Text('Already Registered? Login here'),
            onPressed: () async {
              Navigator.of(context).pushNamedAndRemoveUntil(loginRoute, (route) => false);
            },
          ),
        ],
      ),
    );
  }
}