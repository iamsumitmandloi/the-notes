import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:thenotes/constants/routes.dart';
import 'package:thenotes/firebase_options.dart';
import 'dart:developer' as dev show log;



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
                final userCredential = await FirebaseAuth.instance
                    .createUserWithEmailAndPassword(
                  email: email,
                  password: pass,
                );
                dev.log(userCredential.toString());
              }
              on FirebaseAuthException catch(e){
                if(e.code == 'weak-password') {
                  dev.log('weak password');
                }
                else if(e.code == 'email-already-in-use'){
                  dev.log('already register with this email please chane email');
                }
                else if(e.code == 'invalid-email'){
                  dev.log('Email inValid');
                }
              }
              catch(e){
                dev.log('some other error');
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