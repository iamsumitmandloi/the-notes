import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:thenotes/firebase_options.dart';

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
      body: FutureBuilder(
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,),
        builder: (context,snapshot){
          switch (snapshot.connectionState){
            case ConnectionState.done:
              return Column(
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
                      try{
                      final userCredential =
                      await FirebaseAuth.instance.signInWithEmailAndPassword(
                      email: email,
                      password: pass,
                      );
                    }
                    on FirebaseAuthException catch(e){
                        if(e.code == 'user-not-found') {
                          print('user not found');
                        }
                        else if(e.code == 'wrong-password'){
                          print('wrong password');
                        }
                      }
                    catch(e){
                        print('some other error');
                    }
                      // print(userCredential);
                    },
                  ),
                ],
              );

            default:
              return const Center(child: Text('Loading'));
          }

        },
      ),
    );
  }
}
