import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:thenotes/firebase_options.dart';



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
                        print(userCredential);
                      }
                      on FirebaseAuthException catch(e){
                        if(e.code == 'weak-password') {
                          print('weak password');
                        }
                        else if(e.code == 'email-already-in-use'){
                          print('already register with this email please chane email');
                        }
                        else if(e.code == 'invalid-email'){
                          print('Email inValid');
                        }
                      }
                      catch(e){
                        print('some other error');
                      }
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