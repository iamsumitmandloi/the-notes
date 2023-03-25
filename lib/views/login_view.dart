import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:thenotes/constants/routes.dart';

import 'package:thenotes/utilities/show_error_dailog.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
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
        title: const Text('Login'),
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
            child: const Text('Login'),
            onPressed: () async {
              final email = _email.text;
              final pass = _password.text;
              try {

                await FirebaseAuth.instance.signInWithEmailAndPassword(
                  email: email,
                  password: pass,
                );
                final user = FirebaseAuth.instance.currentUser;
                if(user?.emailVerified??false){
                  //user's email is verified
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    notesRoute,
                        (route) => false,
                  );
                }
                else{
                  //user's email is not verified
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    verifyEmailRoute,
                        (route) => false,
                  );
                }

              } on FirebaseAuthException catch (e) {
                if (e.code == 'user-not-found') {
                  await showErrorDialog(
                    context,
                    'User not found',
                  );
                } else if (e.code == 'wrong-password') {
                  await showErrorDialog(
                    context,
                    'Wrong password',
                  );
                }
                else{
                  await showErrorDialog(
                    context,
                    'Error ${e.code}',
                  );
                }
              } catch (e) {
                await showErrorDialog(
                  context,
                  'some error occurred , Please try Again',
                );
              }
              // dev.log(userCredential);
            },
          ),
          // SizedBox(height: 20,),
          TextButton(
            child: const Text('Not Registered yet? Register here'),
            onPressed: () async {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(registerRoute, (route) => false);
            },
          ),
        ],
      ),
    );
  }
}
